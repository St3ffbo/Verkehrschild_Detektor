clear;
close all;
clc;

%% Let the user select an image and load it.
[filepath, user_canceled] = imgetfile('InitialPath','.\resources');
if user_canceled 
    return; 
end

image = imread(filepath);
original_image = imresize(image, [1024 NaN]);
image = imgaussfilt(image, .5);
image = imadjust(image, [.2 .6],[]);
figure('Name', 'Original image vs. blurred image');
montage({original_image, image});

%% Apply color masks on image and get results as black white images.
[bw_red_mask, ~] = redmask(image);      % Red.

%% Determine relevant areas from color mask images.
bw_red_mask_relevant_areas = determineRelevantAreas(bw_red_mask);

%% Determine bounding boxes of all relevant areas. Crop relevant areas from image using the bounding boxes.
bounding_boxes = determineBoundingBoxes(bw_red_mask_relevant_areas);
[cropped_images_original, cropped_images_bw] = cropImage(image, bw_red_mask_relevant_areas, bounding_boxes);
figure('Name', 'Relevant area(s) cropped from image');
montage([cropped_images_original cropped_images_bw], 'Size', [2 size(cropped_images_original, 2)]);

%% Extract edges from given image.
canny_images_original = findEdges(cropped_images_original, 'canny');
figure('Name', 'Edge image(s) of original cropped image(s)');
montage(canny_images_original);

%% Erode image.
outline_images_bw = fillRegions(cropped_images_bw, canny_images_original);
figure('Name', 'Filled images');
montage([cropped_images_original outline_images_bw], 'Size', [2 size(cropped_images_original, 2)]);

%% Create Distance Matrix.
distances_to_outlines = createDistanceMatrix(cropped_images_bw);
figure('Name', 'DistancePlots');
%montage(distances_to_outlines, 'Size', [2 size(distances_to_outlines, 2)]);
plot(distances_to_outlines{1});

return;

% cropped_img_props = regionprops(cropped_image, 'Area');
% bw_red_mask_areas = [];
% 
% if (~isempty(cropped_img_props))
%     bw_red_mask_areas = extractfield(cropped_img_props, 'Area');
% end
% bw_red_mask_max_area = max(bw_red_mask_areas);
% 
% max_area_threshold = round((bw_red_mask_max_area / 4), 0);
% cropped_image2 = bwareaopen(cropped_image , max_area_threshold);
% [ny, nx] = size(cropped_image2);
% center = round([nx ny]/2);
% 
% figure('Name','groeßte Area vs. gefilterte Areas nach Threshhold');
% cropped_image2 = imfill(cropped_image2, center);

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