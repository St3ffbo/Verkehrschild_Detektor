function distances_to_outline = createDistanceMatrix(outline_images_bw)

number_images = size(outline_images_bw, 2);
distances_to_outline = cell(1, number_images);

for image_index = 1:number_images
    %[ny, nx] = size(outline_images_bw{image_index});
    %center = round([nx ny]/2);
    
    outline_filled = imfill(outline_images_bw{image_index}, 'holes');
    
    outline_props = regionprops(outline_filled, 'Centroid');
    center = extractfield(outline_props, 'Centroid');
    boundaries = bwboundaries(outline_filled);
       
    distances_to_outline{image_index} = sqrt((boundaries(:,1) - center(1)).^2 + ((boundaries(:,2) - center(2)).^2));
end
end