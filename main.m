clear;
close all;
clc;

%% Let the user select an image and load it.
[filepath, user_canceled] = imgetfile('InitialPath','.\resources');
image = imread(filepath);
image = imresize(image, [1024 NaN]);

%% Apply color masks on image and get results as black white images.
[bw_red_mask, ~] = redmask(image);      % Red.

%% Determine relevant areas from color mask images.
bw_red_mask_relevant_areas = determineRelevantAreas(bw_red_mask);

%% Determine bounding boxes of all relevant areas. Compute rectangles around these boxes that are 10% bigger than the boxes themselves.
bounding_boxes = determineBoundingBoxes(bw_red_mask_relevant_areas);

%% Extract edges from given image.
canny_image = edge(rgb2gray(image), 'canny');
figure('Name','Canny vs. Relevant Areas of red masked image');
imshowpair(canny_image, bw_red_mask_relevant_areas, 'montage')

cropped_images = cropImage(image, bounding_boxes);
figure;
montage(cropped_images);

%% Erode image.

bw_red_mask_relevant_areas = imfill(bw_red_mask_relevant_areas, 'holes');
figure('Name','flatArea vs. Erode');
se = strel(ones(20, 20));
erode_BW = imerode(bw_red_mask_relevant_areas, se);
%imshow(~erode_BW + bw_red_mask_relevant_areas);
imshowpair(bw_red_mask_relevant_areas, erode_BW, 'montage')

canny_and_erode = canny_image - erode_BW;
canny_and_erode = canny_and_erode>0;

figure('Name','Canny and erode');
imshowpair(canny_image, canny_and_erode, 'montage')

%imshowpair(image, sobel_Image, 'montage')
figure;
imshow(image)
rectangle('Position',rect,'EdgeColor', 'Magenta', 'LineWidth', 4)

cropped_image = imcrop(canny_and_erode, rect);

figure;
imshow(cropped_image)

cropped_img_props = regionprops(cropped_image, 'Area');
bw_red_mask_areas = [];

if (~isempty(cropped_img_props))
    bw_red_mask_areas = extractfield(cropped_img_props, 'Area');
end
bw_red_mask_max_area = max(bw_red_mask_areas);

max_area_threshold = round((bw_red_mask_max_area / 4), 0);
cropped_image2 = bwareaopen(cropped_image , max_area_threshold);
[ny, nx] = size(cropped_image2);
center = round([nx ny]/2);

figure('Name','groeßte Area vs. gefilterte Areas nach Threshhold');
cropped_image2 = imfill(cropped_image2, center);

cropped_img2_props = regionprops(cropped_image2, 'Area');
bw_red_mask_areas = [];
if (~isempty(cropped_img2_props))
    bw_red_mask_areas = extractfield(cropped_img2_props, 'Area');
end

bw_red_mask_max_area = max(bw_red_mask_areas);
cropped_image3 = bwareaopen(cropped_image2, bw_red_mask_max_area);


imshowpair(cropped_image3, cropped_image2, 'montage')

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