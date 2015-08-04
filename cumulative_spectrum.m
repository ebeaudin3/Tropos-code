function [k_T, numS, T] = cumulative_spectrum(numSamples,datasSamples,PANGAEA_num,graph_cum,type)

%numSamples = [1 -365 -366];%[217 218 216];
%datasSamples = xlsread('datas_lab_IN.xlsx');
%[PANGAEA_num, PANGAEA_text, PANGAEA_all] = xlsread('PANGAEA-longterm.xlsx');
%graph_cum=1;

%% Re-arranging the vector numSamples, if necessary
if numSamples(1)==1, numS = nan(1,(length(datasSamples)+1)/3 -1); j=1;
    for k=1:3:length(datasSamples)-1, if datasSamples(1,k)>1, numS(j) = datasSamples(1,k); j=j+1; end; end
end
if sum(numSamples)<0, for k=2:length(numSamples), numS(find(numS==abs(numSamples(k))))=[]; end %#ok
end

if numSamples(1)>1 && sum(numSamples)>0, numS = numSamples; end

L = length(numS);

%% Initializating variables
T = nan(length(datasSamples(:,1))-2,L);
nb_frz = nan(length(datasSamples(:,1))-2,L);
cum_frz = nan(length(datasSamples(:,1))-2,L);
k_T = nan(length(datasSamples(:,1))-2,L);
[filter_infos_num filter_infos_txt filter_infos_all] = xlsread('infos_filtres.xlsx'); %#ok

%% Affecting values to the variables
for s=1:length(numS)
    T(:,s) = datasSamples(3:end,find(datasSamples(1,:)==numS(s))); %#ok
    nb_frz(:,s) = datasSamples(3:end,find(datasSamples(1,:)==numS(s))+1);
    cum_frz(:,s) = cumsum(nb_frz(:,s));
    
    volume(s) = (PANGAEA_num(find(PANGAEA_num(:,1)==floor(numS(s))),10)) / 140^2; %#ok
    nb_unfrz = 103-cum_frz(:,find(numS==numS(s))); %#ok
    k_T(:,s) = (1./volume(s)).*log(103./nb_unfrz);
end

% Remove "inf" and imaginary numbers
k_T(isinf(k_T))=nan;
k_T = real(k_T);

% Water
datas_water = [datasSamples(3:end,find(datasSamples(1,:)==0)) datasSamples(3:end,find(datasSamples(1,:)==0)+1)]; r=1; %#ok

for w=1:length(datas_water), if isnan(datas_water(w,1)), W(r)=w; r=r+1; end, end
datas_water(W,:)=[];
T_water = datas_water(:,1);
cum_water = cumsum(datas_water(:,2));
vol_water = 30*72/(140^2);
k_T_water = (1./vol_water).*log(103./(103-cum_water));
for k=1:length(k_T_water),
    if isinf(k_T_water(k)), k_T_water(k)=[]; T_water(k)=[]; k=k-1;
    end
end


%% Graphic
if graph_cum==1
    % Plot water first
    h = area(T_water,k_T_water,'HandleVisibility','off');
    set(h,'FaceColor',[0.9 0.95 1],'EdgeColor',[0.9 0.95 1]);
    
    % Plot k_T vs T
        for i=1:length(numS)
            %i/length(numS)
            hold on
            Color_f = color_data(numS(i),type,filter_infos_num,filter_infos_txt,PANGAEA_num);
            plot(T(:,i),k_T(:,i),'o','color',Color_f,'linewidth',2);
            plot(T(:,i),k_T(:,i),'.','color',Color_f,'HandleVisibility','off');
            plot(T(:,i),k_T(:,i),':','color',Color_f,'HandleVisibility','off');
            %legendInfo{i} = num2str(numS(i));
            % ERROR BARS
            dx=0.5;
            for j=1:length(T(:,i))
                dy = sqrt(k_T(j,i)/volume(i)); if k_T(j,i)-dy<0, y_d=0; else y_d=k_T(j,i)-dy; end
                plot([T(j,i)-dx T(j,i)+dx],[k_T(j,i) k_T(j,i)],'color',Color_f)
                plot([T(j,i) T(j,i)],[y_d k_T(j,i)+dy],'color',Color_f)
            end
            hold off
        end
    
    % Graph settings
    xlabel('Temperature [^{o}C]')
    ylabel('Cumulative spectrum')
    %legend(legendInfo)
end