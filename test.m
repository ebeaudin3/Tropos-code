% Test des fonctions IN

clear;
numSamples = [359:363 365 366];%[1 -365 -366];
temp = [-10 -12 -14 -16 -18 -20];
graph_corr=0;

correlation(numSamples,temp,graph_corr)
