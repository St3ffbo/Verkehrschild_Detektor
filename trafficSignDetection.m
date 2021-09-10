% Detects traffic signs that have the given color on a given image.
% Input: The image to detect traffic signs on, the color of the traffic
% signs to look for and whether debug_mode plots and message should be shown.
% Output: Detected traffic signs as instances of the AbstractTrafficSign
% class.

function abstract_traffic_signs = trafficSignDetection(image, color, debug_mode)

    %% Apply color masks on image and get results as black white images.
    [bw_color_mask, ~] = colorMask(color, image);
    
    % Check whether any pixel has been masked by the color mask. If not,
    % return immediately.
    if ~any(bw_color_mask, 'all')
        printToConsole(append('No ', string(color), 'area(s) found.'), debug_mode);
        abstract_traffic_signs = {};
        return
    end
    
    % Plot color masked image if desired.
    if debug_mode
        figure('Name', append('Color masked image (',string(color),')'));
        imshow(bw_color_mask);
    end

    %% Determine relevant areas from color mask images.
    bw_color_mask_relevant_areas = determineRelevantAreas(bw_color_mask);
    
    % Check whether any relevant areas were found and return immediately if
    % not.
    if isempty(bw_color_mask_relevant_areas)
        printToConsole(append(string(color), ' pipeline: No relevant area(s) found.'), debug_mode);
        abstract_traffic_signs = {};
        return
    end
    
    % Plot relevant areas if desired.
    if debug_mode
        figure('Name', append('Relevant areas (',string(color),')'));
        imshow(bw_color_mask_relevant_areas);
    end
       

    %% Determine bounding boxes of all relevant areas. Crop relevant areas from image using the bounding boxes.
    bounding_boxes = determineBoundingBoxes(bw_color_mask_relevant_areas, color);
    [cropped_images_original, cropped_images_bw] = cropImage(image, bw_color_mask_relevant_areas, bounding_boxes);
    
    printToConsole(append(string(color), ' pipeline: Cropped ', num2str(size(bounding_boxes, 1)), ' area(s) from image.'), debug_mode);
    
    % Plot all cropped and black-white cropped images in one montage if desired.
    if debug_mode
        figure('Name', append('Relevant area(s) cropped from image (',string(color),')'));
        montage([cropped_images_original cropped_images_bw], 'Size', [2 size(cropped_images_original, 2)]);
    end

    %% Dilate and erode image each cropped image. Return cropped images with only the biggest area contained.
     cropped_images_bw_finetuned = fineTune(cropped_images_bw);
     
     % Plot all cropped and finetuned images in one montage if desired.
     if debug_mode
        figure('Name', append('Finetuned cropped images (',string(color),')'));
        montage([cropped_images_original cropped_images_bw_finetuned], 'Size', [2 size(cropped_images_original, 2)]);
     end

    %% Compute distance vectors for each relevant area. Count the area's vertices based on the outline distances.
    distances_to_outlines = createDistanceMatrix(cropped_images_bw_finetuned);
    
    % Plot all distance plots in one subplot if desired.
    if debug_mode
        figure('Name', append('Distance plot for each relevant area (',string(color),')'));        
        for image_index = 1: length(distances_to_outlines)
            subplot(length(distances_to_outlines), 1, image_index);
            plot(distances_to_outlines{image_index});
            title(append('Distance plot of relevant area no. ', num2str(image_index)));
        end
    end

    %% Count the vertices of each relevant area.
    [sorted_indices, fft_arrays]  = vertexCounter(distances_to_outlines);

    % Plot FFT of outline distances if desired in one subplot.
    if debug_mode
        figure('Name', append('FFTs of outline distances (',string(color),')'));
        number_images = length(fft_arrays);
        for image_index = 1:number_images
            subplot(number_images, 1, image_index);           
            f = (2:10)-1;        
            stem(f,fft_arrays{image_index});
            title(append('FFT of distance plot of relevant area no. ', num2str(image_index)));   
        end
    end

    %% Extract inner content information from cropped images.    
    inner_content_information = checkInnerContent(color, cropped_images_bw_finetuned, cropped_images_original);
    
    %% Create AbstractTrafficSign objects based on the extracted information.
    abstract_traffic_signs = createAbstractTrafficSigns(color, sorted_indices, bounding_boxes, inner_content_information);
    
end

