%splits the rgb-image into multiple crops based on the given relevantbounding_boxes
%Input: original rbg image, bounding_boxes-Array
%Output: Cell-Array of all image crops still in rgb
function cropped_images = cropImage(image, bounding_boxes)
    
    [number_of_bounding_boxes , ~] = size(bounding_boxes);
    cropped_images = cell(1, number_of_bounding_boxes);
    
for bounding_box_index = 1:(number_of_bounding_boxes)
    cropped_images{bounding_box_index} = imcrop(image, bounding_boxes(bounding_box_index, :));
end
    %Access to a Cell with cropped_images(n)
    %Access to the content of a Cell with cropped_images{n}
end