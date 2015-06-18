% Concentration IN en fonction de la temperature

T = fliplr(-25:-1);

% Eau
Nb_frz = [0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 6 1 11 27 24 18 7 3 4 0];
Tot_frz = cumsum(Nb_frz);
Perc_frz = Tot_frz/max(Tot_frz);

L = 500; %nb de litres d'air par minute
H = [24 72]; %nb d'heures d'exposition au flow
Vol_m3 = 0.06.*L.*H; %[m^3]
Vol_L = 60.*L.*H; %[L]

Vol = Vol_L*103;

semilogy(T,Tot_frz./Vol(1),'*c',T,Tot_frz./Vol(2),'*m')
%legend('24h','72h')

% Échantillons
E365 = [-1 -2 -3 -4 -5 -6 -7 -8 -9 -9.5 -10 -10.5 -11 -11.5 -12 -13 -14 -15 -16 -17 -17.5;
        0 0 0 0 0 1 0 5 28 14 17 9 6 4 2 2 7 0 2 4 1];
    E365(2,:) = cumsum(E365(2,:))/sum(E365(2,:));
E366a = [-1 -2 -3 -4 -5 -6 -7 -8 -8.5;
          0 0 0 0 0 0 0 40 63];
    E366a(2,:) = cumsum(E366a(2,:))/sum(E366a(2,:));  
E366b = [-6 -6.25 -6.5 -6.75 -7 -7.25 -7.5 -7.75 -8 -8.5 -8.75;
          0 0 0 0 0 1 3 8 26 64 3];
    E366b(2,:) = cumsum(E366b(2,:))/sum(E366b(2,:));
    
E180 = [-1 -2 -3 -4 -5 -6 -7 -8 -9 -9.5 -10 -10.5 -11 -11.5 -12 -12.5 ...
    -13 -13.5 -14 -14.5 -15 -15.5 -16 -16.5 -17 -17.5 -18 -18.5 -19 -19.5;
          0 0 0 0 0 0 1 0 1 1 0 4 3 0 1 2 2 2 2 0 5 3 5 5 15 26 3 19 0 3];
    E180(2,:) = cumsum(E180(2,:))/sum(E180(2,:));

E216 = [-1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -13.5 -14 -14.5 -15 ...
        -15.5 -16 -16.5 -17 -17.5 -18;
          0 0 0 0 0 0 0 3 5 2 1 4 30 17 11 6 9 4 4 2 0 3 2];
    E216(2,:) = cumsum(E216(2,:))/sum(E216(2,:));
    
hold on
semilogy(E365(1,:),E365(2,:)./Vol(1),'om')
semilogy(E366a(1,:),E366a(2,:)./Vol(1),'ob')
semilogy(E366b(1,:),E366b(2,:)./Vol(1),'ob')
semilogy(E180(1,:),E180(2,:)./Vol(2),'or')
semilogy(E216(1,:),E216(2,:)./Vol(2),'og')

% Données de André
A365 = [-1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 -16 -16.5;
        0 0 0 0 0 0 1 6 38 24 21 6 1 1 2 2 1];
    A365(2,:) = cumsum(A365(2,:))/sum(A365(2,:));  
A366 = [-1 -2 -3 -4 -5 -6 -7 -7.5 -8 -8.5;
        0 0 0 0 0 1 4 20 52 26];
    A366(2,:) = cumsum(A366(2,:))/sum(A366(2,:));
    
semilogy(A365(1,:),A365(2,:),'dg',A366(1,:),A366(2,:),'db')
    
% Courbes litérature
T_th = -40:0;
y_DeMott = 0.117.*exp(-0.125.*T_th);
hold on
h(1) = semilogy(T_th,y_DeMott,':g');

y_Fletcher = 1e-5.*exp(-0.6.*T_th);
h(2) = semilogy(T_th,y_Fletcher,':b');

y_Cooper = 0.0954.*exp(-0.135.*T_th);
h(3) = semilogy(T_th,y_Cooper,':r');

y_Meyers = 0.0608.*exp(-0.262.*T_th);
h(4) = semilogy(T_th,y_Meyers,':k');

%%%%%%%%%%%%%

box on
%xlim([-25 -5])

xlabel('Temperature [°C]')
ylabel('IN concentration [Nb L^{-1}]')
legend(h([1 2 3 4]),'DeMott','Fletcher','Cooper','Meyers')