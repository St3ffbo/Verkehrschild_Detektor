% Determines all relevant coherent areas in a black-white image that 
% resulted from applying a color mask.
% Input: Black-white image resulting from applied color mask.
% Output: Black-white image containing biggest coherent areas.

function bw_relevant_areas = determineRelevantAreas(bw_color_mask)

% Determine coherent areas in black white images.
bw_color_mask_img_props = regionprops(bw_color_mask, 'Area', 'BoundingBox');

if (~isempty(bw_color_mask_img_props))
    bw_color_mask_areas = extractfield(bw_color_mask_img_props, 'Area');
    bw_color_mask_bounding_boxes = reshape(extractfield(bw_color_mask_img_props, 'BoundingBox'), 4, [])';
end

% Remove all areas that have a bounding box smaller than 
% bb_min_width x bb_min_height.
bb_min_width = 30;
bb_min_height = 30;
deletion_index = 1;
for index = 1:size(bw_color_mask_bounding_boxes, 1)    
    if (bw_color_mask_bounding_boxes(deletion_index, 3) < bb_min_width) || (bw_color_mask_bounding_boxes(deletion_index, 4) < bb_min_height)
        bw_color_mask_areas(deletion_index) = [];
        bw_color_mask_bounding_boxes(deletion_index, :) = [];
    else
        deletion_index = deletion_index + 1;
    end        
end

% If all areas have been removed because they are all too small, return
% immediately.
if isempty(bw_color_mask_areas)
    bw_relevant_areas = [];
    return;
end

% Determine relevant area with biggest area size.
bw_color_mask_max_area = max(bw_color_mask_areas);

% Define relevant areas as those that have at least 1/4 of the biggest area's size.
max_area_threshold = round((bw_color_mask_max_area / 5), 0);
bw_relevant_areas = bwareaopen(bw_color_mask , max_area_threshold); 

end