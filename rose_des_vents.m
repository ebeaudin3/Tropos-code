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

%theta = nan(1,length(numS));
%E=0; NE=0; N=0; NO=0; O=0; SO=0; S=0; SE=0;


%for s=1:48
%    ind = find(infos_num(:,1)==numS(s)) +1;
%    switch sum(double(char(infos_txt(ind,4))));
%        
%        case 69, theta(s) = 0; E=E+1; %E
%        case 147, theta(s) = pi/4; NE=NE+1; %NE
 %       case 78, theta(s) = pi/2; N=N+1; %N
 %       case 157, theta(s) = 3*pi/4; NO=NO+1; %NO
%        case 79, theta(s) = pi; O=O+1; %O
%        case 162, theta(s) = 5*pi/4; SO=SO+1; %SO
%        case 83, theta(s) = 3*pi/2; S=S+1; %S
%        case 152, theta(s) = 7*pi/4; SE=SE+1; %SE
%    end
%end

directions = [69 147 78 157 79 162 83 152];
angle = [0 pi/4 pi/2 3*pi/4 pi 5*pi/4 3*pi/2 7*pi/4];
sum_dir=zeros(1,length(directions));
sum_kT = zeros(1,length(directions));
t=1;
for i=1:8
    for l=1:length(infos_txt)
     if sum(double(cell2mat(infos_all(l,4)))) == directions(i)
         sum_dir(i)=sum_dir(i) + 1;
         ind = find(numS==cell2mat(infos_all(l,1)));
         if isempty(ind), break; end
         sum_kT(i) = sum_kT(i) + x(t,ind)
     end
    end
end

a=1;
b=0;
theta = nan(1,sum(round(sum_kT*100)));
for j=1:8
    nn = round(sum_kT(j)*100/(sum_dir(j)+1));
    b=b+nn;
    theta(1,a:b) = ones(1,nn)*angle(j);
    a=b+1;
end

rose(theta)