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
contrast_adjust = [.2 .6];

adjusted_image = imadjust(image, contrast_adjust,[]);

if debug_mode
    figure('Name', 'Original image vs. gaussian-blurred vs. contrast-corrected image');
    montage({original_image, image, adjusted_image});
end

%% Detect and classify traffic signs.

% Red signs.
red_abstract_traffic_signs = trafficSignDetection(adjusted_image, Color.Red, debug_mode);
annotated_result_image = classifyAbstractTrafficSigns(annotated_result_image, red_abstract_traffic_signs, debug_mode);

% Yellow signs.
yellow_abstract_traffic_signs = trafficSignDetection(adjusted_image, Color.Yellow, debug_mode);
annotated_result_image = classifyAbstractTrafficSigns(annotated_result_image, yellow_abstract_traffic_signs, debug_mode);

% Show annotated result image.
figure('Name', 'Result');
imshow(annotated_result_image);