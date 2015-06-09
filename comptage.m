clear;
crop=1;

%% Read the image
files = {'liquide.jpg','solide.jpg','ice.jpg','ice2.jpg','ice3.jpg','ice5.jpg','petri.png'};
I = imread(num2str(cell2mat(files(2))));

%% B&W image
bmat = I(:,:,1);
levelb = 0.5;
I_BW = im2bw(bmat,levelb);
imshow(I_BW)

%% Extract features
[labeled,numObjects] = bwlabel(I_BW,8);
numObjects
stats = regionprops(labeled,'Eccentricity','Area','BoundingBox','Centroid','EquivDiameter','PixelList');
areas = [stats.Area];
ecc = [stats.Eccentricity];
diam = [stats.EquivDiameter];
barycentre = [cat(1, stats.Centroid)]';
for p=1:length(stats), pixel{p} = cat(1, stats(p).PixelList); end

if crop==1
    %% Crop image
    imageSize = size(I);
    crop_ind = 2;%input('Crop index: ');%2;%find(areas==max(areas));
    crop_radius = diam(crop_ind)*0.8;
    crop_bary = barycentre(:,crop_ind);
    ci = [crop_bary(2), crop_bary(1), crop_radius];     % center and radius of circle ([c_row, c_col, r])
    [xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));
    mask = uint8((xx.^2 + yy.^2)<ci(3)^2);
    croppedImage = uint8(zeros(size(I)));
    croppedImage(:,:,1) = I(:,:,1).*mask;
    croppedImage(:,:,2) = I(:,:,2).*mask;
    croppedImage(:,:,3) = I(:,:,3).*mask;
    %imshow(croppedImage);
    
    I_BW = im2bw(croppedImage(:,:,1),levelb);
    
    %% New stats with cropped image
    [labeled,numObjects] = bwlabel(I_BW,8);
    numObjects
    stats = regionprops(labeled,'Eccentricity','Area','BoundingBox','Centroid','EquivDiameter','PixelList');
    areas = [stats.Area];
    ecc = [stats.Eccentricity];
    diam = [stats.EquivDiameter];
    barycentre = [cat(1, stats.Centroid)]';
    pixel = [cat(1, stats.PixelList)]';
    
end

%% Circle droplets
ind_drop=0;
k=1;
seuil_ecc=0.9;
for j=1:length(ecc)
    if ecc(j)>0 && ecc(j)<seuil_ecc %&& areas(j)<1000
        ind_drop(k)=j;
        k=k+1;
    end
end

statsDef = stats(ind_drop);
figure, imshow(I), hold on
for i=1:length(ind_drop)
    
    h = rectangle('Position',statsDef(i).BoundingBox,'LineWidth',2);
    set(h,'EdgeColor',[.75 0 0]);
    hold on;
    
end

%hist(diam(find(diam<10)))

