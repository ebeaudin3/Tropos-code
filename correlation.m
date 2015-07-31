function correlation(numSamples,temp,graph_corr,type)

%numSamples = [1];%[217 218 216];
%datasSamples = xlsread('datas_lab_IN.xlsx');
%[info_num, info_text, info_all] = xlsread('PANGAEA-longterm.xlsx');
%temp = [-8 -12 -16 -20];
%graph_corr=1;

[infos_num, infos_text, infos_all] = xlsread('PANGAEA-longterm.xlsx'); %#ok
datasSamples = xlsread('datas_lab_IN.xlsx');
[filter_infos_num filter_infos_txt filter_infos_all] = xlsread('infos_filtres.xlsx'); %#ok


%% Initializating variables

graph_cum=1;
[k_T, numS, T] = cumulative_spectrum(numSamples,datasSamples,infos_num,graph_cum,type);

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
if graph_corr==1
    for i=1:25%length(info_num(1,:)) %until 25, because we don't care about the rest
        figure
        x=0; y=0; z=0; %#ok
        
        for t=1:length(temp)
            for s=1:length(numS)
                % Variables
                y = k_T_temp(s,t);
                    if isnan(y), y=max(numS); end
                x = infos_num(find(infos_num(:,1)==floor(numS(s))),i); %#ok
                    if isnan(x), x=max(infos_num(s,i)); end
                z = numS(s); %if you want to make a 3D graph
                valeurs(s,:,i) = [z x y];
                
                % Color
                Color_f = color_data(numS(s),type,filter_infos_num,filter_infos_txt,infos_num);
                
                % Plot                
                hold on
                subplot(dim(1),dim(2),t)
                plot(x,y,'*','color',Color_f,'linewidth',1.2)
                %plot(x,y,'.','color',Color_f,'linewidth',1)
                %title(sprintf('Temperature %d',temp(t)))
                %ylabel('K_T')
                xlabel(infos_text(1,i))
                %xlim([min(x) max(x)])
                switch t
                    case 1, ylim([0 10])
                    case 2, ylim([0 50])
                    case 3, ylim([0 100])
                    case 4, ylim([0 150])
                end
                
                
                % Curve fitting
                %[p, res, mu] = polyfit(x,y,1);
                %sumres(t,i) = res.normr;
                %[sum(isnan(p)), sum(isnan(x)), sum(isnan(y))]
                %x_fit = min(x):0.001:max(x);
                %plot(x_fit,p(1).*x_fit+p(2),':r')
                %r(t,i) = corrcoef(x,y);
                hold off
            end
        end
    end
end
end