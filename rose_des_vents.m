% ROSE DES VENTS
clear;

%% INITIALIZATING VARIABLES
numSamples = 1; %"1" means all. otherwise, write a vector such as [401 402 403];
datasSamples = xlsread('datas_lab_IN.xlsx');
[PANGAEA_num, PANGAEA_text, PANGAEA_all] = xlsread('PANGAEA-longterm.xlsx');
[infos_num infos_txt infos_all]= xlsread('infos_filtres.xlsx'); %#ok
graph_cum=0; type=1;
[k_T, numS, T] = cumulative_spectrum(numSamples,datasSamples,PANGAEA_num,graph_cum,type);

%now we have the k_T value, associated with the temperature (T).
%let's extract the season and the wind direction for each sample.

season_samples=nan(1,length(numS));
seasons = [12 1 2; 3 4 5; 6 7 8; 9 10 11]; %winter=1,spring=2,summer=3,autumn=4
for s=1:length(numS)
    month(s) = PANGAEA_num(find(PANGAEA_num(:,1)==floor(numS(s))),3); %#ok
    [i,j]=find(seasons==month(s));
    season_samples(s) = i;
    wind_samples(s) = infos_txt(find(infos_num(:,1)==floor(numS(s)))+1,4); %#ok
end

% Directions of the wind are put into numerical values
wind_dir = [rms(double('E')) rms(double('ENE')) rms(double('NE')) rms(double('NNE')) ...
    rms(double('N')) rms(double('NNO')) rms(double('NO')) rms(double('ONO')) rms(double('O')) ...
    rms(double('OSO')) rms(double('SO')) rms(double('SSO')) rms(double('S')) rms(double('SSE')) ...
    rms(double('SE')) rms(double('ESE'))];
angles = 0:(360/length(wind_dir)):359;
sum_kT = zeros(1,length(wind_dir));

% x = k_T for the temperatures selected, for the samples selected
temperature = [-8 -12 -16 -20];
x = nan(length(temperature),length(numS));
for t=1:length(temperature)
    for i=1:length(numS)
        ind = find(T(:,i)==temperature(t));
        if isempty(k_T(ind,i)),ind=find(T(:,i)==min(T(:,i)))-1; end
        while isnan(k_T(ind,i)), k_T(ind,i) = k_T(ind-1,i); end
        x(t,i) = k_T(ind,i);
    end
end

% One wind rose per temperature, and one color per season
for t=1:length(temperature)
    figure, hold on
    A = zeros(4,16); %sum_kT for 4 seasons, 16 wind directions
    nb = zeros(4,16);
    
    for i=1:length(numS)
        %we look first to which category the i^th sample corresponds
        ind_s = season_samples(i);
        ind_w = find((rms(double(cell2mat(wind_samples(i)))))==wind_dir);
        %and we put its k_t value in the correct box
        A(ind_s,ind_w) = A(ind_s,ind_w)+x(t,i);
        %we want to know how many samples are in each category
        nb(ind_s,ind_w) = nb(ind_s,ind_w) +1;
    end
    
    scale=100; %scale factor needed not to lose precision. See further.
    I=[]; D=[];
    for j=1:length(wind_dir)
        for k=1:max(season_samples)
            if nb(k,j)>0,
                qty = ones(1,round(scale*A(k,j)/nb(k,j)));
                
                I=[I k*qty]; %multypling by k gives the color (season), and the length of the added vector represents the intensity
                D=[D angles(j)*qty];
            end
        end
    end
    
    wind_rose(D,I)
    
end