function cropped_images = cropImage(image, bounding_boxes)

cropped_images = zeros(length(bounding_boxes), 4);

for bounding_box_index = 1:(length(bounding_boxes) + 1)
    cropped_images(bounding_box_index) = imcrop(image, bounding_boxes(bounding_box_index, :));
end

end