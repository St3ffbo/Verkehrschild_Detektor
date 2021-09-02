function filled_images_bw = dilateErode(cropped_images_bw)

number_images = size(cropped_images_bw, 2);
filled_images_bw = cell(1, number_images);
se = strel(ones(5, 5));
sd = strel(ones(5, 5));

for image_index = 1:number_images

   cropped_images_bw{image_index} =  imfill(cropped_images_bw{image_index}, 'holes');
      
   dilated_image = imdilate(cropped_images_bw{image_index}, sd);
   eroded_image = imerode(dilated_image, se);
   
   filled_images_bw{image_index} = eroded_image;
   
%    figure('Name', 'finetuned image with dilate & erode');
%    montage([cropped_images_bw filled_images_bw]);   
end
end