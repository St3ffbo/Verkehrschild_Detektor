clear all;
close all;

%% Let the user select an image and load it.
[filepath, user_canceled] = imgetfile('InitialPath','.\resources');
if user_canceled 
    return; 
end

original_image = imread(filepath);
original_image = imresize(original_image, [1024 NaN]);imresize(original_image, [1024 NaN]);
figure;
imshow(original_image);


traffic_sign = AbstractTrafficSign(Color.Red, 8, [611.35, 29.35, 245.3, 267.3], NaN);
abstract_traffic_signs = [traffic_sign];
annotated_image = classifyAbstractTrafficSigns(original_image, abstract_traffic_signs);

figure('Name', 'Results of classification');
imshow(annotated_image);