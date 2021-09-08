function dilation_mask = dilateYellowArea(cropped_image_bw)
       %% Dilate relevant areas.
        
       color_mask_area_boundary = bwboundaries(cropped_image_bw);
       area_width = size(color_mask_area_boundary{1}, 1) / 4;
     
       factor = round(area_width * 0.4);
       se = strel('diamond', factor);        
       dilation_mask = imdilate(cropped_image_bw, se);
end

