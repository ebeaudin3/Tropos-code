%function [T, cum_frz, nb_frz] = analyse_IN(S,plott)

% S : number or vector containing the samples. ex : [180 365 366]
%     for all the samples, use S=1
% plott = 1 for a graph, plott = [1 0 1] to plot the first and the third

S = 1;%[217 218 216 180 365 366 219];
plott=1;

num = xlsread('datas_lab_IN.xls');

if S==1, S = nan(1,length(num)/3 -1); j=1;
    for k=1:3:length(num)-1, if num(1,k)>1, S(j) = num(1,k); j=j+1; end; end
end
L = length(S);

T = nan(length(num(:,1))-2,L);
nb_frz = nan(length(num(:,1))-2,L);
cum_frz = nan(length(num(:,1))-2,L);
taux_frz = nan(length(num(:,1))-2,L);

% Samples
for s=1:L
    
    col = [find(num(1,:)==S(s)) find(num(1,:)==S(s))+1];
    T(:,s) = num(3:end,col(1));
    nb_frz(:,s) = num(3:end,col(2));
    cum_frz(:,s) = cumsum(nb_frz(:,s));
    taux_frz(:,s) = cum_frz(:,s)/103;
end

% Plot water
    lines_water = abs(isnan([num(3:end,find(num(1,:)==0)) num(3:end,find(num(1,:)==0)+1)])-1);
    water = [num(3:end,find(num(1,:)==0)) num(3:end,find(num(1,:)==0)+1)]; r=1;
    for w=1:length(water), if isnan(water(w,1)), W(r)=w; r=r+1; end, end
    water(W,:)=[];
    cum_water = [water(:,1) cumsum(water(:,2))];
    h = area(cum_water(:,1),cum_water(:,2));
    set(h,'FaceColor',[0.9 0.95 1],'EdgeColor',[0.9 0.95 1]);


% Plot
if length(plott)==1 && plott==1, plott=ones(1,L); end
color = hsv(L);
legendInfo = cell(1,L);
for i=1:L
    hold on
    if plott(i)==1,
        %fill(T_W,frz_W,'b');
        h(i) = plot(T(:,i),taux_frz(:,i),'.','color',color(i,:));
        plot(T(:,i),taux_frz(:,i),':','color',color(i,:),'handlevisibility','off')
        legendInfo{i} = num2str(S(i));
    end    
end

xlabel('Température [°C]')
ylabel('Taux de nucléation')
legend(legendInfo)