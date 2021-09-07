% Extracts information from possible traffic signs about their inner
% contents.
% Input: Cropped original images and cropped black-white masks of these
% images.
% Output: A collection of inner content objects containing the extracted
% information for each specified cropped image.

function inner_content_information = checkInnerContent(color, cropped_images_bw_finetuned, cropped_images_original)

% Get number of cropped masks and cropped original images.
number_masks = length(cropped_images_bw_finetuned);
number_images = length(cropped_images_original);

% Check whether the number of cropped masks and cropped original images are
% equal.
if number_masks ~= number_images
    error('Number of black-white masks does not equal number of cropped images')
end

% Instantiate collection for inner content objects.
inner_content_information = cell(1, number_images);

for index = 1:number_images    

    % Get masked rgb image.
    current_cropped_mask = cropped_images_bw_finetuned{index};
    masked_rgb = bsxfun(@times, cropped_images_original{index}, cast(current_cropped_mask, 'like', cropped_images_original{index}));
    figure;
    imshow(masked_rgb);
    
    % Dummy variables.
    ratio = NaN;
    number_inner_areas = 0;
    
    % Execute actions based on the relevant color.
    switch color
        case Color.Red
            % Compute red portion of image.
            red_portion_mask = colorMask(Color.Red, masked_rgb);
            figure('Name', 'Red portion');
            imshow(red_portion_mask);  

            % Compute inner portion of sign.
            inner_portion_mask = logical(current_cropped_mask - red_portion_mask);
            figure('Name', 'Inner portion');
            imshow(inner_portion_mask);  

            % Extract relevant areas from inner portion by removing all
            % those areas whose size is less than the half of the biggest
            % are's size.
            inner_portion_props = regionprops(inner_portion_mask, 'Area');
            inner_portion_areas = extractfield(inner_portion_props, 'Area');
            inner_portion_max_area = max(inner_portion_areas);
            max_area_threshold = round((inner_portion_max_area / 2), 0);
            
            % Overwriting old mask to only contain the relevant areas.
            inner_portion_mask = bwareaopen(inner_portion_mask, max_area_threshold);        
            inner_portion_props = regionprops(inner_portion_mask, 'Area');
            inner_portion_areas = extractfield(inner_portion_props, 'Area');
            
            % Get number of inner portion areas.
            number_inner_areas = length(inner_portion_areas);

            % If there is only one inner area, compute the ratio between
            % the inner content mask and the binary inner content.
            if number_inner_areas == 1            
                
                % Compute rgb masked inner portion.
                inner_portion_masked_rgb = bsxfun(@times, cropped_images_original{index}, cast(inner_portion_mask, 'like', cropped_images_original{index}));
                figure('Name', 'Inner portion masked rgb');
                imshow(inner_portion_masked_rgb);

                % Binarize rgb masked inner portion.
                inner_content_mask = imbinarize(rgb2gray(inner_portion_masked_rgb));
                figure('Name', 'Inner portion content mask');
                imshow(inner_content_mask);

                % Count number of white pixels in inner portion mask and
                % inner content mask.
                count_inner_portion = sum(inner_portion_mask(:) == 1);
                count_inner_content = sum(inner_content_mask(:) == 1);

                % Compute ratio between the numbers in order to identify
                % to which amount the inner content matches the inner
                % portion.
                % ratio = 1: no difference (no content at all)
                % ratio << 1: difference (there is some content)
                ratio = count_inner_content / count_inner_portion;
            end
        
        case Color.Yellow
            % TODO: Implement!
    end
    
    % Create inner content object based on trhe extracted information.
    inner_content_information{index} = InnerContent(number_inner_areas, ratio);
    
end        

end

