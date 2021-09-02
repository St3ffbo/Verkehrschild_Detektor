function distances_to_outline = createDistanceMatrix(cropped_images_bw_finetuned)

number_images = size(cropped_images_bw_finetuned, 2);
distances_to_outline = cell(1, number_images);

for image_index = 1:number_images  
        
    outline_props = regionprops(cropped_images_bw_finetuned{image_index}, 'Centroid');
    center = round(extractfield(outline_props, 'Centroid'),0);
    boundaries = cell2mat(bwboundaries(cropped_images_bw_finetuned{image_index}));

    distances_to_outline{image_index} = sqrt((boundaries(:,2) - center(1)).^2 + ((boundaries(:,1) - center(2)).^2));

%     figure('Name', 'distance measure with centre');
%     imshow(cropped_images_bw_finetuned{image_index})
%     hold on;
%     plot(center(1),center(2),'*r')
%     hold on;
%     x = boundaries(:,1);
%     y = boundaries(:,2);
%     plot(y,x,'*g')
end
end