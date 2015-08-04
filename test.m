% Correlation with PANGAEA and cumulative spectrum (IN/m^3)

clear;
numSamples = 1; %[359:364 365.5 366.5 367];%[1 -365 -366];
temp = [-8 -12 -16 -20];
graph_corr=1;
type=1;

correlation(numSamples,temp,graph_corr,type);
% Notes : valeurs = [nb_sample x y]