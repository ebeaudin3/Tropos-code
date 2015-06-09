%function [T, cum_frz, nb_frz] = datas(S,plott)

% S : number or vector containing the samples. ex : [180 365 366]
%     for all the samples, use S=1
% plott = 1 for a graph, plott = [1 0 1] to plot the first and the third

S = 1;%[217 218 216];
plott=1;

%num = xlsread('datas_lab_IN.xlsx');

T = nan(length(num(:,1))-2,length(S));
nb_frz = nan(length(num(:,1))-2,length(S));
cum_frz = nan(length(num(:,1))-2,length(S));

if S==1, S = nan(1,length(num)/3 -1); j=1;
    for k=1:3:length(num)-1, if num(1,k)>1, S(j) = num(1,k); j=j+1; end; end
end
L = length(S);

% Variables
for s=1:L
    col = [find(num(1,:)==S(s)) find(num(1,:)==S(s))+1];
    T(:,s) = num(3:end,col(1));
    nb_frz(:,s) = num(3:end,col(2));
    cum_frz(:,s) = cumsum(nb_frz(:,s));
end

% Plot
if length(plott)==1 && plott==1, plott=ones(1,L); end
color = hsv(L);

    % water
    lines_water = abs(isnan([num(3:end,find(num(1,:)==0)) num(3:end,find(num(1,:)==0)+1)])-1);
    water = [num(3:end,find(num(1,:)==0)) num(3:end,find(num(1,:)==0)+1)]; r=1;
        for w=1:length(water), if isnan(water(w,1)), W(r)=w; r=r+1; end, end
        water(W,:)=[];
        cum_water = [water(:,1) cumsum(water(:,2))];
    h = area(cum_water(:,1),cum_water(:,2));
    set(h,'FaceColor',[0.9 0.95 1],'EdgeColor',[0.9 0.95 1]);
    
    
for i=1:length(S)
    hold on
    if plott(i)==1, 
        plot(T(:,i),cum_frz(:,i),'.','color',color(i,:));
        plot(T(:,i),cum_frz(:,i),':','color',color(i,:),'HandleVisibility','off');
        %legend_entry{i} = sprintf('%d',S(i));
    end
end

%xtick('Temperature [C]')
%ytick('Ice Nucleation')
%legend(S,legend_entry)


a = load('MAAP2008.cor2.1h',-ASCII);

