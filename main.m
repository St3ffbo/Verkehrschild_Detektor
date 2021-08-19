clear;
close all;
clc;


[filepath ,user_canceled] = imgetfile('InitialPath','.\resources');
image = imread(filepath);
image = imresize(image, [1024 NaN]);

bwMask_ofRed = redmask(image);      %gute Erkennung der roten Fläche

bwMark_img_props = regionprops(bwMask_ofRed, 'Area', 'BoundingBox');
r_areas = [];
boundingboxes = reshape(extractfield(bwMark_img_props, 'BoundingBox'), 4, [])';

if (~isempty(bwMark_img_props))
    r_areas = extractfield(bwMark_img_props, 'Area');
end
max_area = max(r_areas);

area_threshold = round((max_area / 4), 0);
bw_image_ofRed = bwareaopen(bwMask_ofRed , area_threshold); 

bwMark_img_props = regionprops(bw_image_ofRed, 'BoundingBox');
boundingboxes = reshape(extractfield(bwMark_img_props, 'BoundingBox'), 4, [])';

bonuspixel = [boundingboxes(1,3)*0.1 boundingboxes(1,4)*0.1];
rect = [boundingboxes(1,1)-bonuspixel(1) boundingboxes(1,2)-bonuspixel(2) boundingboxes(1,3)+2*bonuspixel(1) boundingboxes(1,4)+2*bonuspixel(2)];

canny_ofImg = edge(rgb2gray(image), 'canny');


figure('Name','Canny vs. redMask');
imshowpair(canny_ofImg, bw_image_ofRed, 'montage')

bw_image_ofRed = imfill(bw_image_ofRed, 'holes');
figure('Name','flatArea vs. Erode');
se = strel(ones(20, 20));
erode_BW = imerode(bw_image_ofRed, se);
%imshow(~erode_BW + bw_image_ofRed);
imshowpair(bw_image_ofRed, erode_BW, 'montage')

canny_and_erode = canny_ofImg - erode_BW;
canny_and_erode = canny_and_erode>0;

figure('Name','Canny and erode');
imshowpair(canny_ofImg, canny_and_erode, 'montage')

%imshowpair(image, sobel_Image, 'montage')
figure;
imshow(image)
rectangle('Position',rect,'EdgeColor', 'Magenta', 'LineWidth', 4)

cropped_image = imcrop(canny_and_erode, rect);

figure;
imshow(cropped_image)

cropped_img_props = regionprops(cropped_image, 'Area');
r_areas = [];

if (~isempty(cropped_img_props))
    r_areas = extractfield(cropped_img_props, 'Area');
end
max_area = max(r_areas);

area_threshold = round((max_area / 4), 0);
cropped_image2 = bwareaopen(cropped_image , area_threshold);
[ny, nx] = size(cropped_image2);
center = round([nx ny]/2);

figure;
cropped_image2 = imfill(cropped_image2, center);

cropped_img2_props = regionprops(cropped_image, 'Area');
r_areas = [];
if (~isempty(cropped_img2_props))
    r_areas = extractfield(cropped_img2_props, 'Area');
end

max_area = max(r_areas);
cropped_image3 = bwareaopen(cropped_image2, max_area);
%bwareaopen benutzt intern Area von regionprops. outlines werden nicht als
%Area erkannt. boundaries erkennt aber später die outline als area.
imshowpair(cropped_image3, cropped_image2, 'montage')
%Nachschauen warum bwareaopen nicht funktioniert. evtl mit bwconncomp
%nachbauen
boundaries = bwboundaries(cropped_image3);
boundaries = boundaries{1};

hold on;
plot(center(1),center(2),'*r')
hold on;
plot(boundaries(:,2),boundaries(:,1),'*g')

distance_vector = sqrt((boundaries(:,1) - center(1)).^2 + ((boundaries(:,2) - center(2)).^2));
figure;
plot(distance_vector);
figure;
y = abs(fft(distance_vector));
y = y(1:length(y)/2);

f = 0:length(y)-1;
stem(f,y)