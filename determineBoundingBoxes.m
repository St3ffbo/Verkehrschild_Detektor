function bounding_boxes = determineBoundingBoxes(bw_color_mask_relevant_areas)

%% Determine the bounding boxes of all areas given in the black-white image.
bw_color_mask_relevant_areas_img_props = regionprops(bw_color_mask_relevant_areas, 'BoundingBox');
bw_color_mask_relevant_areas_bb = reshape(extractfield(bw_color_mask_relevant_areas_img_props, 'BoundingBox'), 4, [])';

%% Enlarge bounding boxes by 10%.
bounding_boxes = [bw_color_mask_relevant_areas_bb(:,1)-bw_color_mask_relevant_areas_bb(:,1).*0.1...
        bw_color_mask_relevant_areas_bb(:,2)-bw_color_mask_relevant_areas_bb(:,2).*0.1...
        bw_color_mask_relevant_areas_bb(:,3)+2*bw_color_mask_relevant_areas_bb(:,3).*0.1...
        bw_color_mask_relevant_areas_bb(:,4)+2*bw_color_mask_relevant_areas_bb(:,4).*0.1];
end