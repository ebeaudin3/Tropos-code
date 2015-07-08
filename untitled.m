% Rose des vents
clear;

numSamples = [1];%[217 218 216];
datasSamples = xlsread('datas_lab_IN.xlsx');
[info_num, info_text, info_all] = xlsread('PANGAEA-longterm.xlsx');
graph_cum=0;
[k_T, numS, T] = cumulative_spectrum(numSamples,datasSamples,info_num,graph_cum);

temperatures = [-8 -12 -16 -20];
for t=1:length(temperatures)
    for i=1:length(numS)
        ind = find(T(:,i)==temperatures(t));
        while isempty(k_T(ind,i)), ind=find(T(:,i)==min(T(:,i))); end
        x(t,i) = k_T(ind,i);
    end
end

[infos_num infos_txt infos_all]= xlsread('infos_filtres.xlsx'); %#ok

theta = nan(1,length(numS));

for s=1:48
    ind = find(infos_num(:,1)==numS(s)) +1;
    switch sum(double(char(infos_txt(ind,4))));
        
        case 69, theta(s) = 0; %E
        case 147, theta(s) = pi/4; %NE
        case 78, theta(s) = pi/2; %N
        case 157, theta(s) = 3*pi/4; %NO
        case 79, theta(s) = pi; %O
        case 162, theta(s) = 5*pi/4; %SO
        case 83, theta(s) = 3*pi/2; %S
        case 152, theta(s) = 7*pi/4; %SE
    end
end

rose(0:pi/4:7*pi/4,8)