% Blur image

function I_blurred = BlurImage(file)

%files = {'P1010494.JPG'};
%clear;
%I= imread(num2str(cell2mat(files)));
I = imread(file);
scale = 1/12;
%imshow(I)
I = imresize(I,scale);
Im2blur = I(:,:,2);
I_blurred=nan(size(Im2blur));
%figure, imshow(Im2blur)

filter1 = [1 1 1; 1 1 1; 1 1 1];
filter_gauss = (1/4)*[1 2 1; 2 4 2; 1 2 1];
filter_edgeR = (1/4)*[1 2; 2 4; 1 2];%[1 1; 1 1; 1 1];%
filter_edgeL = (1/4)*[2 1; 4 2; 2 1];%[1 1; 1 1; 1 1]; %
filter_edgeT = (1/4)*[2 4 2; 1 2 1];%[1 1 1; 1 1 1]; %
filter_edgeB = (1/4)*[1 2 1; 2 4 2];%[1 1 1; 1 1 1]; %
filter_cornerTR = (1/4)*[2 4; 1 2];%[1 1; 1 1]; %
filter_cornerTL = (1/4)*[4 2; 2 1];%[1 1; 1 1]; %
filter_cornerBR = (1/4)*[1 2; 2 4];%[1 1; 1 1]; %
filter_cornerBL = (1/4)*[2 1; 4 2];%[1 1; 1 1]; %

size(Im2blur)

for i=1:size(Im2blur,1)
    for j=1:size(Im2blur,2)
        filter = 0; pix=0;
        %corner
        if [i j]==[1 1], filter=filter_cornerTL;
            pix=double([Im2blur(i,j) Im2blur(i,j+1); Im2blur(i+1,j) Im2blur(i+1,j+1)]);
        elseif [i j]==[1 size(Im2blur,2)], filter=filter_cornerTR;
            pix=double([Im2blur(i,j-1) Im2blur(i,j); Im2blur(i+1,j-1) Im2blur(i+1,j)]);
        elseif [i j]==[size(Im2blur,1) 1], filter=filter_cornerBL;
            pix=double([Im2blur(i-1,j) Im2blur(i-1,j+1); Im2blur(i,j) Im2blur(i,j+1)]);
        elseif [i j]==[size(Im2blur,1) size(Im2blur,2)], filter=filter_cornerBR;
            pix=double([Im2blur(i-1,j-1) Im2blur(i-1,j); Im2blur(i,j-1) Im2blur(i,j)]);
        %edge
        elseif i==1 && j~=1 && j~=size(Im2blur,2), filter=filter_edgeT;
            pix=double([Im2blur(i,j-1) Im2blur(i,j) Im2blur(i,j+1); Im2blur(i+1,j-1) Im2blur(i+1,j) Im2blur(i+1,j+1)]);
        elseif i==size(Im2blur,1) && j~=1 && j~=size(Im2blur,2), filter=filter_edgeB;
            pix=double([Im2blur(i-1,j-1) Im2blur(i-1,j) Im2blur(i-1,j+1); Im2blur(i,j-1) Im2blur(i,j) Im2blur(i,j+1)]);
        elseif i~=1 && i~=size(Im2blur,1) && j==1, filter=filter_edgeL;
            pix=double([Im2blur(i-1,j) Im2blur(i,j); Im2blur(i+1,j) Im2blur(i-1,j+1); Im2blur(i,j+1) Im2blur(i+1,j+1)]);
        elseif i~=1 && i~=size(Im2blur,1) && j==size(Im2blur,2), filter=filter_edgeR;
            pix=double([Im2blur(i-1,j-1) Im2blur(i-1,j); Im2blur(i,j-1) Im2blur(i,j); Im2blur(i+1,j-1) Im2blur(i+1,j)]);
        %else
        else filter=filter_gauss; 
            pix=double([Im2blur(i-1,j-1) Im2blur(i-1,j) Im2blur(i-1,j+1);...
                Im2blur(i,j-1) Im2blur(i,j) Im2blur(i,j+1);...
                Im2blur(i+1,j-1) Im2blur(i+1,j) Im2blur(i+1,j+1)]);
        end
        
        I_blurred(i,j) = 0.01*mean(mean(filter.*pix));
        
    end
end

figure
imshow(I_blurred)




