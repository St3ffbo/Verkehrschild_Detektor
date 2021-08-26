% Determines all relevant coherent areas in a black-white image that 
% resulted from applying a color mask.
% Input: Black-white image resulting from applied color mask.
% Output: Black-white image containing biggest coherent areas.

function bw_relevant_areas = determineRelevantAreas(bw_color_mask)
%% Determine coherent areas in black white images.
bw_color_mask_img_props = regionprops(bw_color_mask, 'Area');

if (~isempty(bw_color_mask_img_props))
    bw_color_mask_areas = extractfield(bw_color_mask_img_props, 'Area');
end
bw_color_mask_max_area = max(bw_color_mask_areas);

%% Determine relevant areas by selecting the biggest one and those that have at least 1/4 of the biggest area's size.
max_area_threshold = round((bw_color_mask_max_area / 4), 0);
bw_relevant_areas = bwareaopen(bw_color_mask , max_area_threshold); 

end