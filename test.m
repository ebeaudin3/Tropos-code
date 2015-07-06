% Test des fonctions IN

clear;
numSamples = 1; %[359:364 365.5 366.5 367];%[1 -365 -366];
temp = [-8 -12 -16 -20];
graph_corr=1;

correlation(numSamples,temp,graph_corr)
