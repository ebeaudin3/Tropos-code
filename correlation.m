function correlation(numSamples,temp,graph_corr)

%numSamples = [1 -365 -366];%[217 218 216];
%datasSamples = xlsread('datas_lab_IN.xlsx');
%[info_num, info_text, info_all] = xlsread('PANGAEA-longterm.xlsx');
%temp = [-8 -12 -16 -20];
%graph_corr=1;

[info_num, info_text, info_all] = xlsread('PANGAEA-longterm.xlsx');
datasSamples = xlsread('datas_lab_IN.xlsx');

%% Initializating variables

graph_cum=1;
[k_T, numS, T] = cumulative_spectrum(numSamples,datasSamples,info_num,graph_cum);

if length(temp)>6, error('Length of "temp" vector should not exceed 6. If you insist, then enter the function and fix this.');
else
    switch length(temp)
        case 1, a=1; b=1;
        case 2, a=1; b=2;
        case 3, a=1; b=3;
        case 4, a=2; b=2;
        case 5, a=2; b=3;
        case 6, a=2; b=3;
    end
end

nb_IN = nan(length(numS),length(temp));
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
    
    % Color and shape for each category:
    % Winter: *     Spring: d    Summer: o   Automn: s
    % Marine: blue  Desert: yellow  Europe: red     America: green
        
    filter_infos = xlsread('infos_filtres.xlsx');
    color_filtre = [
        135, 206, 250;
        255, 255, 254;
        250, 235, 215;
        245, 222, 179;
        210, 180, 140;
        205, 133, 63;
        153, 76, 0;
        122, 51, 0;
          ]/255;
    
    % Plot K_T_temp against infos
    
    for i=1:length(info_num(1,:))
        x=0; y=0; z=0;
        figure
        for t=1:length(temp)
            for s=1:length(numS)
                z(s) = numS(s);
                y(s) = k_T_temp(s,t);
                    if isnan(y(s)), y(s)=max(numS); end
                x(s) = info_num(find(info_num(:,1)==floor(numS(s))),i);
                    if isnan(x(s)), x(s)=max(info_num(s,i)); end
            
                teinte = filter_infos(find(filter_infos(:,1)==floor(numS(s))),2);
                color(s,:) = color_filtre(teinte-1,:);
                    
                %switch source(s)
                %    case 1, colorb='b';
                %    case 2, colorb='m';
                %    case 3, colorb='r';
                %    case 4, colorb='g';
                %end
            
                %if teinte<6,
                hold on
                subplot(a,b,t)
                plot(x(s),y(s),'.','color',color(s,:),'linewidth',1.5)
                %end
            end
            
            % plot
            title(sprintf('Temperature %d',temp(t)))
            ylabel('K_T')
            xlabel(info_text(1,i))
            %xlim([min(x) max(x)])
            
            % curve fitting
            [p, res, mu] = polyfit(x,y,1);
            sumres(t,i) = res.normr;
            
            %[sum(isnan(p)), sum(isnan(x)), sum(isnan(y))]
            
            x_fit = min(x):0.001:max(x);
            %hold on
            %plot(x_fit,p(1).*x_fit+p(2),':r')
            %r(t,i) = corrcoef(x,y);
            
        end
    end
end