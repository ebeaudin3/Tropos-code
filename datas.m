%function [T, cum_frz, nb_frz] = datas(S,plott)

% S : number or vector containing the samples. ex : [180 365 366]
%     for all the samples, use S=1
% plott = 1 for a graph, plott = [1 0 1] to plot the first and the third

Samples = [1];%[217 218 216];
plott=1;

num = xlsread('datas_lab_IN.xlsx');
[info_num, info_text, info_all] = xlsread('PANGAEA-longterm.xlsx');

if Samples(1)==1, S = nan(1,length(num)/3 -1); j=1;
    for k=1:3:length(num)-1, if num(1,k)>1, S(j) = num(1,k); j=j+1; end; end
end
if sum(Samples)<0, for k=2:length(Samples), S(find(S==abs(Samples(k))))=[]; end
end

L = length(S);

T = nan(length(num(:,1))-2,L);
nb_frz = nan(length(num(:,1))-2,L);
cum_frz = nan(length(num(:,1))-2,L);
k_T = nan(length(num(:,1))-2,L);


% Variables
for s=1:L
    col = [find(num(1,:)==S(s)) find(num(1,:)==S(s))+1];
    T(:,s) = num(3:end,col(1));
    nb_frz(:,s) = num(3:end,col(2));
    cum_frz(:,s) = cumsum(nb_frz(:,s));
    k_T(:,s) = (140.^2).*(1./(info_num(find(info_num(:,1)==S(s)),10))).*log(103./(103-cum_frz(:,find(S==S(s)))));    
end

% On enleve les inf
    k_T(isinf(k_T))=nan;

% Plot k_T vs T
if length(plott)==1 && plott==1, 
    plott=ones(1,L); 
    color = hsv(L);

    % water
    lines_water = abs(isnan([num(3:end,find(num(1,:)==0)) num(3:end,find(num(1,:)==0)+1)])-1);
    water = [num(3:end,find(num(1,:)==0)) num(3:end,find(num(1,:)==0)+1)]; r=1;
    for w=1:length(water), if isnan(water(w,1)), W(r)=w; r=r+1; end, end
        water(W,:)=[];
        cum_water = [water(:,1) cumsum(water(:,2))];
        vol_water = 30*72/(140^2);
        k_T_water = [water(:,1) (1./vol_water).*log(103./(103-cum_water(:,2)))];
        for k=1:length(k_T_water), if isinf(k_T_water(k,2)), k_T_water(k,:)=nan; k=k-1; end, end
        h = area(k_T_water(:,1),k_T_water(:,2),'HandleVisibility','off');
        set(h,'FaceColor',[0.9 0.95 1],'EdgeColor',[0.9 0.95 1]);
    end
    
for i=1:length(S)
    hold on
    if plott(i)==1, 
        plot(T(:,i),k_T(:,i),'.','color',color(i,:));
        plot(T(:,i),k_T(:,i),':','color',color(i,:),'HandleVisibility','off');
        legendInfo{i} = num2str(S(i));
    end
end

xlabel('Temperature [C]')
ylabel('Ice Nucleation')
legend(legendInfo)
break;


% Graphiques de correlation entre l'experience et les infos
temp = [-8 -12 -16 -20];

% Number of ice nucleation for certains temperatures
nb_IN = nan(L,length(temp));

for t=1:length(temp)
    for s=1:L
        a = find(T(:,s)==temp(t)); if length(a)>1, a=a(1); end
        if isempty(a), nb_IN(s,t)=103; K_T(s,t)=max(k_T(s,:));
        else nb_IN(s,t) = cum_frz(a,s);
            % Connen 2012
            K_T(s,t) = k_T(a,s);%(140.^2).*(1./(info_num(find(info_num(:,1)==S(s)),10))).*log(103./(103-cum_frz(a,find(S==S(s)))));
        end
    end
end


taux_IN = nb_IN/103;

figure
plot(temp,taux_IN,'o-')




% against infos
figure

for i=1:length(info_num(1,:))
    x=0; y=0; z=0;
    figure
    for t=1:length(temp)
        for s=1:length(S)
            z(s) = S(s);
            y(s) = K_T(s,t);
            x(s) = info_num(find(info_num(:,1)==S(s)),i);
        end
        
        % plot
        subplot(2,2,t)
        plot(x,y,'.')
        title(sprintf('Temperature %d',temp(t)))
        ylabel('K_T')
        xlabel(info_text(1,i))
        %xlim([min(x) max(x)])
        
        
        % curve fitting
        [p, res, mu] = polyfit(x,y,1);
        sumres(t,i) = res.normr;
        
        x_fit = min(x):0.001:max(x);
        hold on
        %plot(x_fit,p(1).*x_fit+p(2),':r')
        %r(t,i) = corrcoef(x,y);
        
    end   
end 

