clear;
close all;
clc;

%% Let the user select an image and load it.
[filepath, user_canceled] = imgetfile('InitialPath','.\resources');
if user_canceled 
    return; 
end

original_image = imread(filepath);

% Resize image to 1024 pixels height and resize accordingly.
resized_image = imresize(original_image, [1024 NaN]);
annotated_result_image = resized_image;

% Apply a gaussian blur filter on the image.
image = imgaussfilt(resized_image, .5);
image = imadjust(image, [.2 .6],[]);
figure('Name', 'Original image vs. blurred image');
montage({original_image, image});

%% Apply color masks on image and get results as black white images.
[bw_red_mask, ~] = colorMask(Color.Red, image);      % Red.

%% Determine relevant areas from color mask images.
bw_red_mask_relevant_areas = determineRelevantAreas(bw_red_mask);

%% Determine bounding boxes of all relevant areas. Crop relevant areas from image using the bounding boxes.
bounding_boxes = determineBoundingBoxes(bw_red_mask_relevant_areas);
[cropped_images_original, cropped_images_bw] = cropImage(image, bw_red_mask_relevant_areas, bounding_boxes);
figure('Name', 'Relevant area(s) cropped from image');
montage([cropped_images_original cropped_images_bw], 'Size', [2 size(cropped_images_original, 2)]);

%% Dilate and erode image.
 cropped_images_bw_finetuned = dilateErode(cropped_images_bw);
 figure('Name', 'Filled images');
 montage([cropped_images_original cropped_images_bw_finetuned], 'Size', [2 size(cropped_images_original, 2)]);

%% Create distance matrix for each relevant area.
distances_to_outlines = createDistanceMatrix(cropped_images_bw_finetuned);
figure('Name', 'DistancePlots');

for image_index = 1: length(distances_to_outlines)
    plot(distances_to_outlines{image_index});
    hold on;
end
legend;

%% Count the vertices of each relevant area.
counted_vertices = cornerCounter(distances_to_outlines);
counted_vertices = transpose(repelem(8, size(bounding_boxes, 1))); % TEMP!!!

%% Finally classify and annotate traffic signs in the original image.

% Red relevant areas.
red_abstract_traffic_signs = createAbstractTrafficSigns(Color.Red, counted_vertices, bounding_boxes);
annotated_result_image = classifyAbstractTrafficSigns(annotated_result_image, red_abstract_traffic_signs);

% TODO: Yellow relevant areas.

% Show annotated result image.
figure('Name', 'Result');
imshow(annotated_result_image);

%% Some other stuff.
% y = abs(fft(distance_vector));
% y = y(1:length(y)/2);
% 
% f = 0:length(y)-1;
% stem(f,y)