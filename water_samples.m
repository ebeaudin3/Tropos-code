% Water sample
clear;
[data_num data_txt data_all] = xlsread('Water_Sample.xlsx'); %#ok

t = -(1:27)';
volume = 0.1; %100?L=0.1cm^3

%nb_unfrz = nan();
for i=1:size(data_num,2)
    nb_unfrz(:,i) = max(cumsum(data_num(:,i)))-cumsum(data_num(:,i));
    k_T(:,i) = (1/volume).*log(max(cumsum(data_num(:,i)))./nb_unfrz(:,i));
end

% Remove "inf" and imaginary numbers
k_T(isinf(k_T))=nan;
k_T = real(k_T);

% Graphiques
pairs_SML = [1 11; 2 12; 3 13; 4 14; 5 15];
pairs_ULW = [6 16; 7 17; 8 18; 9 19; 10 20];
pairs_f = [1 6; 2 7; 3 8; 4 9; 5 10];
pairs_nf = [11 16; 12 17; 13 18; 14 19; 15 20];

nb=[11 22 25 29 36];

for k=1:4
    
    switch k
        case 1, pairs=pairs_SML; titre='SML';
        case 2, pairs=pairs_ULW; titre='ULW';
        case 3, pairs=pairs_f; titre='filtered';
        case 4, pairs=pairs_nf; titre='non-filtered';
    end

    figure
    for j=1:5
        subplot(3,2,j), box on, grid on
        hold on
        plot(t,k_T(:,pairs(j,1)),'r.-');
        plot(t,k_T(:,pairs(j,2)),'.:');
        hold off
        xlabel('Temperature [^oC]')
        ylabel('IN/cm^3')
        
        %legend section
        switch k
            case 1, title(sprintf('%d %s',nb(j),titre)), legend('f','nf')
            case 2, title(sprintf('%d %s',nb(j),titre)), legend('f','nf')
            case 3, title(sprintf('%d %s',nb(j),titre)), legend('SML','ULW')
            case 4, title(sprintf('%d %s',nb(j),titre)), legend('SML','ULW')
        end
    end
end


nn = [1:5; 6:10; 11:15; 16:20];
titres={'SML f', 'UWL f', 'SML nf', 'ULW nf'};

figure
for i=1:4
    subplot(2,2,i), box on
    grid on
    plot(t,k_T(:,nn(i,:)),'.-','linewidth',2)
    title(titres{i})
    legend('11','22','25','29','36')
    xlabel('Temperature [^oC]')
    ylabel('IN/cm^3')
end
print

