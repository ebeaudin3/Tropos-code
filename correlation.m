function correlation(numSamples,temp,graph_corr,type)

%clear;
%numSamples = [1];%[217 218 216];
%temp = [-8 -12 -16 -20];
%graph_corr=0;
%type=1;

[PANGAEA_num, PANGAEA_text, PANGAEA_all] = xlsread('PANGAEA-longterm.xlsx');
datasSamples = xlsread('datas_lab_IN.xlsx');
[filter_infos_num filter_infos_txt filter_infos_all] = xlsread('infos_filtres.xlsx'); %#ok


%% Initializating variables

graph_cum=0;
[k_T, numS, T] = cumulative_spectrum(numSamples,datasSamples,PANGAEA_num,graph_cum,type);

% Subplots position
if length(temp)>6, error('Length of "temp" vector should not exceed 6. If you insist, then enter the function and fix this.');
else a = [1 1; 1 2; 1 3; 2 2; 2 3; 2 3]; dim = [a(length(temp),1) a(length(temp),2)];
end

k_T_temp = nan(length(numS),length(temp));


%% Number of ice nucleation for certain temperatures

for t=1:length(temp)
    for s=1:length(numS)
        A = find(T(:,s)==temp(t)); if length(A)>1, A=A(1); end
        if isempty(A), k_T_temp(s,t)=max(k_T(:,s));
        else k_T_temp(s,t) = k_T(A,s);
        end
    end
end


%% Graphics

for i=1:25%length(info_num(1,:)) %until 25, because we don't care about the rest
    if graph_corr==1, figure, end
    x=0; y=0; z=0;
    
    for t=1:length(temp)
        x=0; y=0; z=0;
        
        for s=1:length(numS)
            % Variables
            y(s) = k_T_temp(s,t);
            if isnan(y(s)), y(s)=max(k_T_temp(s,:)); end
            x(s) = PANGAEA_num(find(PANGAEA_num(:,1)==floor(numS(s))),i); %#ok
            if isnan(x(s)), x(s)=max(PANGAEA_num(s,i)); end
            z = numS(s); %if you want to make a 3D graph
            %valeurs(s,:,i) = [z x(s) y(s)];
            
            if graph_corr==1
                % COLORS
                Color_f = color_data(numS(s),type,filter_infos_num,filter_infos_txt,PANGAEA_num);
                
                % PLOT
                hold on
                subplot(dim(1),dim(2),t)
                plot(x(s),y(s),'.','color',Color_f)
                plot(x(s),y(s),'o','color',Color_f,'linewidth',1.5)
                % ERROR BARS
                volume = (PANGAEA_num(find(PANGAEA_num(:,1)==floor(numS(s))),10)) / 140^2; %#ok
                dy = sqrt(y(s)/volume); if y(s)-dy<0, y_d=0; else y_d=y(s)-dy; end
                plot([x(s) x(s)],[y_d y(s)+dy],'color',Color_f)
                % GRAPHIC INFORMATION
                %title(sprintf('Temperature %d',temp(t)))
                %ylabel('K_T')
                xlabel(PANGAEA_text(1,i))
                %ylim_U = [10 50 100 150];
                %ylim([0 ylim_U(t)])
                %set(gca,'yscale','log')
            end
        end
        
        % CURVE FITTING
        nan_ind=find(isnan(x));
        x(nan_ind)=[]; y(nan_ind)=[];
        [p, res] = polyfit(x,y,1);
        sumres(t,i) = res.normr;
        x_fit = linspace(0.8.*min(x),1.1.*max(x),30);
        if graph_corr==1, plot(x_fit,p(1).*x_fit+p(2),':r'), hold off, end
        [rr, PP] = corrcoef(x,y);
        r(t,i)=rr(1,2); P(t,i)=PP(1,2);
        %if rr(1,2)>0.5 && PP(1,2)<0.05, disp([t,i,r(t,i),P(t,i)]), end
    end
end