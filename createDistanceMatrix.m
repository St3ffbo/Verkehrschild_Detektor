% Computes a distance vector for each relevant area in the specified cropped
% images. It describes a boundary pixel's distance to its area center.
% Input: Finetuned and cropped black-white images.
% Output: Distance vectors for each relevant area in each cropped image.

function distances_to_outline = createDistanceMatrix(cropped_images_bw_finetuned)

% Determine number of specified images.
number_images = size(cropped_images_bw_finetuned, 2);

% Create the cell array to stroe the distances in.
distances_to_outline = cell(1, number_images);

for image_index = 1:number_images     
    
    % Get the center coordinates of the current area.
    outline_props = regionprops(cropped_images_bw_finetuned{image_index}, 'Centroid');
    center = round(extractfield(outline_props, 'Centroid'),0);
    
    % Get the boundary pixels of the current area.
    boundaries = cell2mat(bwboundaries(cropped_images_bw_finetuned{image_index}));

    % Compute the distance to the area center for each pixel (pythagoras).
    distances_to_outline{image_index} = sqrt((boundaries(:,2) - center(1)).^2 + ((boundaries(:,1) - center(2)).^2));
    temp = round(0.01*length(boundaries));
    distances_to_outline{image_index} = movmean(distances_to_outline{image_index}, temp);

end

end