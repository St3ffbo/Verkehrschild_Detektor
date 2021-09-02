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

%% Dilate and Erode image.
 cropped_images_bw_finetuned = dilateErode(cropped_images_bw);
 figure('Name', 'Filled images');
 montage([cropped_images_original cropped_images_bw_finetuned], 'Size', [2 size(cropped_images_original, 2)]);

%% Create Distance Matrix.
distances_to_outlines = createDistanceMatrix(cropped_images_bw_finetuned);
figure('Name', 'DistancePlots');

for image_index = 1: length(distances_to_outlines)
    plot(distances_to_outlines{image_index});
    hold on;
end
legend;

counted_corners = cornerCounter(distances_to_outlines);


% y = abs(fft(distance_vector));
% y = y(1:length(y)/2);
% 
% f = 0:length(y)-1;
% stem(f,y)