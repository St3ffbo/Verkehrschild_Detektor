function bounding_boxes = determineBoundingBoxes(bw_color_mask_relevant_areas)

%% Determine the bounding boxes of all areas given in the black-white image.
bw_color_mask_relevant_areas_img_props = regionprops(bw_color_mask_relevant_areas, 'BoundingBox');
bw_color_mask_relevant_areas_bb = reshape(extractfield(bw_color_mask_relevant_areas_img_props, 'BoundingBox'), 4, [])';

%% Enlarge bounding boxes by 10%.
scale = 1.1;
bounding_boxes = zeros(size(bw_color_mask_relevant_areas_bb, 1), 4);

% Adjust the lower left corner.
bounding_boxes(:, 1:2) = bw_color_mask_relevant_areas_bb(:, 1:2) - bw_color_mask_relevant_areas_bb(:, 3:4) * 0.5 * (scale -1);

% Adjust the width and the height.
bounding_boxes(:, 3:4) = bw_color_mask_relevant_areas_bb(:, 3:4) * scale;

end