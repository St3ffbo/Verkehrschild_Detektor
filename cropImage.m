% Splits the rgb-image into multiple crops based on the given relevant
% bounding_boxes.
% Input: Original rgb image, bounding_boxes array.
% Output: Cell array of all rgb image crops.

function cropped_images = cropImage(image, bounding_boxes)
%% Create array that holds the cropped images. 
number_of_bounding_boxes = size(bounding_boxes, 1);
cropped_images = cell(1, number_of_bounding_boxes);
    
%% Crop the images from the main image based on the bounding boxes.
for bounding_box_index = 1:(number_of_bounding_boxes)
    cropped_images{bounding_box_index} = imcrop(image, bounding_boxes(bounding_box_index, :));
end

%% Annotation:
% Access to a Cell with cropped_images(n).
% Access to the content of a Cell with cropped_images{n}.
end