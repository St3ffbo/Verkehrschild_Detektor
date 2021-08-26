function filled_images_bw = fillRegions(cropped_images_bw, canny_images_original)

number_images = size(cropped_images_bw, 2);
filled_images_bw = cell(1, number_images);
se = strel(ones(20, 20));

for image_index = 1:number_images
   cropped_images_bw{image_index} =  imfill(cropped_images_bw{image_index}, 'holes');
      
   eroded_image = imerode(cropped_images_bw{image_index}, se);   
   
   filled_images_bw{image_index} = (canny_images_original{image_index} - eroded_image) > 0;
end

end