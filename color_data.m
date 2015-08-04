function Color_f = color_data(numS,type,filter_infos_num,filter_infos_txt,infos_num)

% Types
% 1 source (marine, desert or terrestrial)
% 2 season (humid and dry)
% 3 filter color
% 4 PM10

switch type
    
    case 1 %source
        source = filter_infos_txt(find(filter_infos_num(:,1)==floor(numS))+1,3);
        switch sum(double(char(source)))
            case double('M'), Color_f = [0 0 255]; %blue
            case sum(double('MT')), Color_f = [128 0 128]; %purple
            case double('T'), Color_f = [255 0 0]; %red
            case sum(double('DT')), Color_f = [255 165 0]; %orange
            case double('D'), Color_f = [255 215 0]; %yellow
            case sum(double('MD')), Color_f = [154 205 50]; %green
            case sum(double('MDT')), Color_f = [153 76 0]; %brown
        end
        Color_f = Color_f./255;
        
    case 2 %season
        month = infos_num(find(infos_num(:,1)==floor(numS)),3);
        %if month==3 || month==4 || month==5, Color_f=[0 1 0]; %spring
        %elseif month==6 || month==7 || month==8, Color_f=[1 0 0];%Color_f=[154 205 50]/255; %summer
        %elseif month==9 || month==10 || month==11, Color_f=[1 0 0];%Color_f=[255 140 0]/255; %autumn
        %elseif month==12 || month==1 || month==2, Color_f=[0 1 0];%Color_f=[0 191 255]/255; %winter

        if month>3 && month<11, Color_f=[1 0 0]; %dry
        else Color_f=[0 0 1]; %humid
        end
        
        
    case 3 %filter color
        color_filtre = [135, 206, 250; 255, 255, 254; 250, 235, 215; 245, 222, 179;
            210, 180, 140; 205, 133, 63; 153, 76, 0; 122, 51, 0;]/255;
        if isempty(find(filter_infos_num(:,1)==floor(numS))), %#ok
            warning('L''echantillon %d n''a pas de couleur associee.',numS);
            Color_f = [0 0 0];
        else
            teinte = filter_infos(find(filter_infos_num(:,1)==floor(numS)),2) -1;
            Color_f = color_filtre(teinte,:);
        end
        
    case 4 %PM10
        PM10_mass = infos_num(find(infos_num(:,1)==floor(numS)),11); %#ok
        if PM10_mass>100, Color_f=[1 0 0];
        elseif PM10_mass>75 && PM10_mass<=100, Color_f=[1 0.65 0];
        elseif PM10_mass>50 && PM10_mass<=75, Color_f=[1 0.85 0];
        elseif PM10_mass>25 && PM10_mass<=50, Color_f=[1 0.95 0];
        else Color_f=[1 1 0.5];
        end
        
end