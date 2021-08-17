clear;
close all;
clc;


[filepath ,user_canceled] = imgetfile('InitialPath','.\');
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
%cropped_image = imcrop(image, rect);



figure('Name','Canny vs. redMask');
imshowpair(canny_ofImg, bw_image_ofRed, 'montage')

bw_image_ofRed = imfill(bw_image_ofRed, 'holes');
figure('Name','flatArea vs. Erode');
imshow(bw_image_ofRed)

diff_img_canny = imabsdiff(canny_ofImg, bw_image_ofRed);

figure('Name','Canny vs. Diff');
imshowpair(canny_ofImg, diff_img_canny, 'montage')

%imshowpair(image, sobel_Image, 'montage')
figure;
imshow(image)
rectangle('Position',rect,'EdgeColor', 'Magenta', 'LineWidth', 4)