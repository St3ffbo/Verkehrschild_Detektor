% "Fine-tunes" the specified cropped images by firstly filling up all enclosed
% areas per cropped image. Afterwards, the cropped image is dilated and
% eroded. Lastly, the largest area of each cropped image is extracted.
% Input: Cropped black-white images.
% Output: "Fine-tuned" images as described above.

function finetuned_images_bw = fineTune(cropped_images_bw)

% Determine number of specified images.
number_images = size(cropped_images_bw, 2);

% Create a cell array to store the "fine-tuned" images in.
finetuned_images_bw = cell(1, number_images);

% Define the structuring elements for the dilation and erosion.
se = strel(ones(5, 5));
sd = strel(ones(5, 5));

% "Fine-tune" each specified image.
for image_index = 1:number_images
    
   % Fill all enclosed areas contained inside the current cropped image.
   cropped_images_bw{image_index} =  imfill(cropped_images_bw{image_index}, 'holes');
   
   % Dilate and erode current cropped image to get rid of small anomalies.
   dilated_image = imdilate(cropped_images_bw{image_index}, sd);
   eroded_image = imerode(dilated_image, se);
   
   % Extract the largest area from all given areas in the current cropped image.
   eroded_image_props = regionprops(eroded_image, 'Area');
   eroded_image_areas = extractfield(eroded_image_props, 'Area');   
   eroded_image_big_area = bwareaopen(eroded_image, max(eroded_image_areas));
   finetuned_images_bw{image_index} = eroded_image_big_area;
      
end

end