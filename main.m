clear;
close all;
clc;

%% Variables.
debug_mode = true;

%% Let the user select an image and load it.
[filepath, user_canceled] = imgetfile('InitialPath','.\resources');
if user_canceled 
    return; 
end

% Load the original image.
original_image = imread(filepath);

% Resize image to 1024 pixels height and resize accordingly.
resized_image = imresize(original_image, [1024 NaN]);

% Create a copy of the resized image to annotate for later.
annotated_result_image = resized_image;

%% Apply a gaussian blur filter on the resized image.
image = imgaussfilt(resized_image, .5);
if debug_mode
    figure('Name', 'Original image vs. gaussian-blurred image');
    montage({original_image, image});
end

%% Adjust the image's contrast.
image = imadjust(image, [.2 .6],[]);
if debug_mode
    figure('Name', 'Original image vs. gaussian-blurred and contrast-corrected image');
    montage({original_image, image});
end

%% Apply color masks on image and get results as black white images.
[bw_red_mask, ~] = colorMask(Color.Red, image);         % Red.
[bw_yellow_mask, ~] = colorMask(Color.Yellow, image);   % Yellow.
if debug_mode
    figure('Name', 'Color masks applied');
    subplot(1, 2, 1);
    imshow(bw_red_mask);
    title('Red-masked image');
    subplot(1, 2, 2);
    imshow(bw_yellow_mask);
    title('Yellow-masked image');
end
%% Determine relevant areas from color mask images.
bw_red_mask_relevant_areas = determineRelevantAreas(bw_red_mask);
bw_yellow_mask_relevant_areas = determineRelevantAreas(bw_yellow_mask);
if debug_mode
    figure('Name', 'Relevant areas');
    subplot(1, 2, 1);
    imshow(bw_red_mask_relevant_areas);
    title('Red-masked image with relevant areas');
    subplot(1, 2, 2);
    imshow(bw_yellow_mask_relevant_areas);
    title('Yellow-masked image with relevant areas');
end

%% Determine bounding boxes of all relevant areas. Crop relevant areas from image using the bounding boxes.
bounding_boxes = determineBoundingBoxes(bw_red_mask_relevant_areas);
[cropped_images_original, cropped_images_bw] = cropImage(image, bw_red_mask_relevant_areas, bounding_boxes);
if debug_mode
    figure('Name', 'Relevant area(s) cropped from image');
    montage([cropped_images_original cropped_images_bw], 'Size', [2 size(cropped_images_original, 2)]);
end

%% Dilate and erode image each cropped image. Return cropped images with only the biggest area contained.
 cropped_images_bw_finetuned = dilateErode(cropped_images_bw);
 if debug_mode
    figure('Name', 'Finetuned cropped images');
    montage([cropped_images_original cropped_images_bw_finetuned], 'Size', [2 size(cropped_images_original, 2)]);
 end

%% Compute distance vectors for each relevant area. Count the area's vertices based on the outline distances.
distances_to_outlines = createDistanceMatrix(cropped_images_bw_finetuned);
if debug_mode
    figure('Name', 'Distance plot for each relevant area');
    % Plot all distance plots in one subplot.
    for image_index = 1: length(distances_to_outlines)
        subplot(length(distances_to_outlines), 1, image_index);
        plot(distances_to_outlines{image_index});
        title(strcat('Distance plot of relevant area no. ', num2str(image_index)));
    end
end

%% Count the vertices of each relevant area.
counted_vertices = vertexCounter(distances_to_outlines, debug_mode);
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