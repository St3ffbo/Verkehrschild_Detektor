function filled_images_bw = fillRegions(cropped_images_bw, canny_images_original)

number_images = size(cropped_images_bw, 2);
filled_images_bw = cell(1, number_images);
se = strel(ones(15, 15));
sd = strel(ones(5, 5));

for image_index = 1:number_images
    
%    [ny, nx] = size(cropped_images_bw{image_index});
%    center = round([nx ny]/2);
    
   cropped_images_bw{image_index} =  imfill(cropped_images_bw{image_index}, 'holes');
      
   eroded_image = imerode(cropped_images_bw{image_index}, se);
   dilated_image = imdilate(cropped_images_bw{image_index}, sd);
   
   mask = (dilated_image + eroded_image)~=1;
   
   filled_images_bw{image_index} = (canny_images_original{image_index} - mask)> 0;
   
   figure('Name', 'Mask for edge-seperation');
   montage([canny_images_original{image_index} cropped_images_bw{image_index} eroded_image dilated_image mask]);
   
end
end