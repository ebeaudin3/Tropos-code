% Correlation with PANGAEA and cumulative spectrum (IN/m^3)
clear;

% Some information about this code in general...

% When you see %#ok, it is just to tell matlab to stop the warning about 
% the current line.
% To use this code, you write the number of the samples you want to
% inspect. For all of them, write numSamples=1. If you want all of them but
% not the 401, for example, write numSamples=[1 -401]. For the samples 380,
% 400 and 512, write numSamples=[380 400 512].
% If you want to see the correlation graph, graph_corr=1. Otherwhise, 0.
% Type stands for the color chart. See color_data.m for more information.
% It is important to put "clear;" at the beginning of the start page (as 
% here) so all the variables are reset. Otherwise, some errors may occur
% and it is sometimes hard to find them. But, don't put it inside the
% functions!

numSamples = 1; %[359:364 365.5 366.5 367];%[1 -365 -366];
temperatures = [-8 -12 -16 -20];
graph_corr=1;
type=1;

correlation(numSamples,temperatures,graph_corr,type);
% Notes : valeurs = [nb_sample x y]