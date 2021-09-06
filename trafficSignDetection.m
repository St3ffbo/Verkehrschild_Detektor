function abstract_traffic_signs = trafficSignDetection(image, color, debug_mode)
    %% Apply color masks on image and get results as black white images.
    [bw_color_mask, ~] = colorMask(color, image);
    
    if ~any(bw_color_mask, 'all')
        abstract_traffic_signs = {-1};
        return
    end
    
    if debug_mode
        figure('Name', strcat('Color masked image (',string(color),')'));
        imshow(bw_color_mask);
    end

    %% Determine relevant areas from color mask images.
    bw_color_mask_relevant_areas = determineRelevantAreas(bw_color_mask);

    %if lenght(bw_color_mask_relevant_areas) == 0
    
    if debug_mode
        figure('Name', strcat('Relevant areas (',string(color),')'));
        imshow(bw_color_mask_relevant_areas);
    end

    %% Determine bounding boxes of all relevant areas. Crop relevant areas from image using the bounding boxes.
    bounding_boxes = determineBoundingBoxes(bw_color_mask_relevant_areas);
    [cropped_images_original, cropped_images_bw] = cropImage(image, bw_color_mask_relevant_areas, bounding_boxes);
    if debug_mode
        figure('Name', strcat('Relevant area(s) cropped from image (',string(color),')'));
        montage([cropped_images_original cropped_images_bw], 'Size', [2 size(cropped_images_original, 2)]);
    end

    %% Dilate and erode image each cropped image. Return cropped images with only the biggest area contained.
     cropped_images_bw_finetuned = dilateErode(cropped_images_bw);
     if debug_mode
        figure('Name', strcat('Finetuned cropped images (',string(color),')'));
        montage([cropped_images_original cropped_images_bw_finetuned], 'Size', [2 size(cropped_images_original, 2)]);
     end

    %% Compute distance vectors for each relevant area. Count the area's vertices based on the outline distances.
    distances_to_outlines = createDistanceMatrix(cropped_images_bw_finetuned);
    if debug_mode
        figure('Name', strcat('Distance plot for each relevant area (',string(color),')'));
        % Plot all distance plots in one subplot.
        for image_index = 1: length(distances_to_outlines)
            subplot(length(distances_to_outlines), 1, image_index);
            plot(distances_to_outlines{image_index});
            title(strcat('Distance plot of relevant area no. ', num2str(image_index)));
        end
    end

    %% Count the vertices of each relevant area.
    [counted_vertices,fft_arrays]  = vertexCounter(distances_to_outlines);

    % Plot FFT of outline distances if desired in one subplot.
    if debug_mode
        figure('Name', strcat('FFTs of outline distances (',string(color),')'));
        number_images = length(fft_arrays);
        for image_index = 1:number_images
            subplot(number_images, 1, image_index);           
            f = (2:10)-1;        
            stem(f,fft_arrays{image_index});
            title(strcat('FFT of distance plot of relevant area no. ', num2str(image_index)));   
        end
    end

    %% Finally classify and annotate traffic signs in the original image.

    abstract_traffic_signs = createAbstractTrafficSigns(color, counted_vertices, bounding_boxes);
end

