% Classifies abstract traffic sign objects based on their properties.
% Input: The original image and and the abstract traffic signs created by
% the pipeline.
% Output: The result image containing the traffic sign annotations.

function annotated_image = classifyAbstractTrafficSigns(original_image, abstract_traffic_signs, debug_mode, already_padded)

annotated_image = original_image;

% Check whether abstract traffic signs are available.
if isempty(abstract_traffic_signs)    
    return
end

% Add constant border pixels to image if not already done.
number_constant_pixels = 20;
if ~already_padded    
    annotated_image = padarray(original_image,[number_constant_pixels number_constant_pixels], 'replicate', 'both');
end

% Get copy of original_image to annotate.
number_traffic_signs = size(abstract_traffic_signs, 2);

% Iterate over each given abstrac traffic sign.
for index = 1:number_traffic_signs
    
    MAX_SCORE = 3;
    stop_score = 0;
    vorfahrt_gew_score = 0;
    vorfahrt_score = 0;
    vorfahrt_strasse_score = 0;
    
    % Get current abstract traffic sign.
    abstract_traffic_sign = abstract_traffic_signs{index};
    
    % Define an annotation string that holds the object's description.
    annotation_string = '';
    
    % Color.
    switch abstract_traffic_sign.color
        
        case Color.Red
            
            % Vertices.
            switch abstract_traffic_sign.vertex_indices(1)
                
                case 2
                    switch abstract_traffic_sign.vertex_indices(2)                                                
                        
                        case 3
                            vorfahrt_gew_score = vorfahrt_gew_score + 0.75;
                            vorfahrt_score = vorfahrt_score + 0.75;
                        
                        case 7
                            stop_score = stop_score + 0.2;
                        
                        case 8
                            stop_score = stop_score + 0.8;
                            
                    end
                
                case 3
                    vorfahrt_gew_score = vorfahrt_gew_score + 1;
                    vorfahrt_score = vorfahrt_score + 1;
                
                case 7
                    stop_score = stop_score + 0.3;                                    
                    
                case 8
                    stop_score = stop_score + 1;                                    
                    
            end
            
            % Number of areas.
            switch abstract_traffic_sign.inner_content.number_inner_areas
                
                case 1
                    vorfahrt_gew_score = vorfahrt_gew_score + 1;
                    vorfahrt_score = vorfahrt_score + 1;
                
                case 3
                    stop_score = stop_score + 0.75;
                    
                case 4
                    stop_score = stop_score + 1;
                    
                otherwise
                    if isnan(abstract_traffic_sign.inner_content.number_inner_areas)
                        vorfahrt_score = vorfahrt_score + 1;
                    end
                    
            end
            
            % Ratio.
            if isnan(abstract_traffic_sign.inner_content.ratio)
                stop_score = stop_score + 1;
            elseif isInRange(abstract_traffic_sign.inner_content.ratio, [0.95 1])
                vorfahrt_gew_score = vorfahrt_gew_score + 1;
            elseif isInRange(abstract_traffic_sign.inner_content.ratio, [0.90 1])
                vorfahrt_gew_score = vorfahrt_gew_score + 0.75;               
            elseif isInRange(abstract_traffic_sign.inner_content.ratio, [0.7 0.75])    
                vorfahrt_score = vorfahrt_score + 1;
            elseif isInRange(abstract_traffic_sign.inner_content.ratio, [0.6 0.85])    
                vorfahrt_score = vorfahrt_score + 0.75;
            end
            
        case Color.Yellow
            
            % Vertices.
            switch abstract_traffic_sign.vertex_indices(1)
                
                case 2
                    switch abstract_traffic_sign.vertex_indices(2)
                        
                        case 4
                            vorfahrt_strasse_score = vorfahrt_strasse_score + 0.5;
                            
                    end
                
                case 4
                    vorfahrt_strasse_score = vorfahrt_strasse_score + 1;                                        
                    
            end
            
            % Number of areas.
            switch abstract_traffic_sign.inner_content.number_inner_areas                                
                    
                otherwise
                    if isnan(abstract_traffic_sign.inner_content.number_inner_areas)
                        vorfahrt_strasse_score = vorfahrt_strasse_score + 1;
                    end
                    
            end
            
            % Ratio.
            if isInRange(abstract_traffic_sign.inner_content.ratio, [1.2 1.35])
                vorfahrt_strasse_score = vorfahrt_strasse_score + 1;
            elseif isInRange(abstract_traffic_sign.inner_content.ratio, [1.1 1.45])
                vorfahrt_strasse_score = vorfahrt_strasse_score + 0.5;
            elseif isInRange(abstract_traffic_sign.inner_content.ratio, [1 1.55])
                vorfahrt_strasse_score = vorfahrt_strasse_score + 0.25;
            end
            
    end
       
    [best_score, best_score_index] = max([stop_score vorfahrt_gew_score vorfahrt_score vorfahrt_strasse_score]);
    confidence = round((best_score / MAX_SCORE) * 100);
    
    % Build annotation strin based on the max score.
    switch best_score_index
        
        case 1
            annotation_string = strcat('Stop (', num2str(confidence), '%)');
        case 2
            annotation_string = strcat('Vorfahrt gewähren (', num2str(confidence), '%)');
        case 3
            annotation_string = strcat('Vorfahrt (', num2str(confidence), '%)');
        case 4
            annotation_string = strcat('Vorfahrtstraße (', num2str(confidence), '%)');
    end
    
    % Adjust bounding box to image with constant border pixels.
    abstract_traffic_sign.bounding_box(1) = abstract_traffic_sign.bounding_box(1) + number_constant_pixels;
    abstract_traffic_sign.bounding_box(2) = abstract_traffic_sign.bounding_box(2) + number_constant_pixels;
    
    confidence_threshold = 50;
    color = '';        
    if confidence >= 0 && confidence < 33
        color = 'red';
    elseif confidence >= 33 && confidence < 66
        color = 'yellow';
    elseif confidence >= 66 && confidence <= 100 
        color = 'green';
    end    
    
    if debug_mode
        % Insert object annotation in resulting image.
        annotated_image = insertObjectAnnotation(annotated_image, 'rectangle', abstract_traffic_sign.bounding_box, annotation_string,...
            'TextBoxOpacity', 0.9, 'FontSize', 18, 'LineWidth', 3, 'Color', color);  
    elseif confidence > confidence_threshold
            % Insert object annotation in resulting image.
            annotated_image = insertObjectAnnotation(annotated_image, 'rectangle', abstract_traffic_sign.bounding_box, annotation_string,...
                'TextBoxOpacity', 0.9, 'FontSize', 18, 'LineWidth', 3, 'Color', color); 
    end        
    
end

end