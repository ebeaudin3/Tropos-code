% ROSE DES VENTS
% warning! the values on the graph are scaled by a factor of 100
clear;
scale = zeros(1,4);

% Variables
numSamples = [1];%[217 218 216];
datasSamples = xlsread('datas_lab_IN.xlsx');
[info_num, info_text, info_all] = xlsread('PANGAEA-longterm.xlsx');
graph_cum=0;
[k_T, numS, T] = cumulative_spectrum(numSamples,datasSamples,info_num,graph_cum);
[infos_num infos_txt infos_all]= xlsread('infos_filtres.xlsx'); %#ok

% Directions of the wind are put into numerical values
E = double('E'); ENE = sum(double('ENE')); NE = sum(double('NE')); NNE = sum(double('NNE'));
N = double('N'); NNO = sum(double('NNO')); NO = sum(double('NO')); ONO = sum(double('ONO'));
O = double('O'); OSO = sum(double('OSO')); SO = sum(double('SO')); SSO = sum(double('SSO'));
S = double('S'); SSE = sum(double('SSE')); SE = sum(double('SE')); ESE = sum(double('ESE'));

wind_dir = [E ENE NE NNE N NNO NO ONO O OSO SO SSO S SSE SE ESE];
angle = 0:(pi/8):15*pi/8;
sum_kT = zeros(1,length(wind_dir));

% x = k_T for the temperatures selected, for the samples selected
temperature = [-8 -12 -16 -20];
x = nan(length(temperature),length(numS));
for t=1:length(temperature)
    for i=1:length(numS)
        ind = find(T(:,i)==temperature(t));
        if isempty(k_T(ind,i)), ind=find(T(:,i)==min(T(:,i))); end
        if isnan(k_T(ind,i)), k_T(ind,i) = k_T(ind-1,i); end
        x(t,i) = k_T(ind,i);
    end
end

% rose wind for each temperature

for t=1:length(temperature)
    
    sum_dir=zeros(1,length(wind_dir));
    
    for i=1:length(wind_dir)
        for l=1:length(infos_txt)
            if sum(double(cell2mat(infos_all(l,4)))) == wind_dir(i)
                sum_dir(i)=sum_dir(i) + 1;
                ind = find(numS==cell2mat(infos_all(l,1)));
                if isempty(ind), break; end
                % cumulative sum of k_T for each wind direction
                sum_kT(i) = sum_kT(i) + x(t,ind);
                
            end
        end
    end
    
    % vector theta replace sum_kT for the windrose graph
    a=1;
    b=0;
    theta = nan(1,sum(round(sum_kT*100)));
    
    for j=1:length(wind_dir)
        % theta is scale over the number of data
        scale = 100;
        nn = round(sum_kT(j)*scale/(sum_dir(j)+1));
        b=b+nn;
        theta(1,a:b) = ones(1,nn)*angle(j);
        a=b+1;
    end
    
    subplot(2,2,t)
    rose(theta)
    title(sprintf('Temperature %d^oC',temperature(t)))
    
end