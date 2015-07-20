function Color_f = color_source(source)

switch sum(double(char(source)))
    case double('M'), Color_f = [0 0 255];
    case sum(double('MT')), Color_f = [128 0 128];
    case double('T'), Color_f = [255 0 0];
    case sum(double('DT')), Color_f = [255 165 0];
    case double('D'), Color_f = [255 215 0];
    case sum(double('MD')), Color_f = [154 205 50];
    case sum(double('MDT')), Color_f = [153 76 0];                  
end

Color_f = Color_f./255;