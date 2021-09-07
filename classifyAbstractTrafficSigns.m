% Classifies abstract traffic sign objects based on their properties.
% Input: The original image and and the abstract traffic signs created by
% the pipeline.
% Output: The result image containing the traffic sign annotations.

function annotated_image = classifyAbstractTrafficSigns(original_image, abstract_traffic_signs, debug_mode)

% Check whether abstract traffic signs are available.
if isempty(abstract_traffic_signs)
    annotated_image = original_image;
    return
end

% Get copy of original_image to annotate.
number_traffic_signs = size(abstract_traffic_signs, 2);
annotated_image = padarray(original_image,[20 20], 'replicate', 'both');

% Iterate over each given abstrac traffic sign.
for index = 1:number_traffic_signs
    
    % Get current abstract traffic sign.
    abstract_traffic_sign = abstract_traffic_signs{index};
    
    % Define an annotation string that holds the object's description.
    annotation_string = '';
    
    if (abstract_traffic_sign.color == Color.Red)
        % Check cases for red traffic signs.        
        switch abstract_traffic_sign.number_vertices
            case 3
                annotation_string = 'Vorfahrt gewähren';
            case 8
                annotation_string = 'Stop';
            otherwise
                annotation_string = 'Unknown';
        end
    elseif (abstract_traffic_sign.color == Color.Yellow)
        % Check cases for yellow traffic signs.
        switch abstract_traffic_sign.number_vertices
            case 4
                annotation_string = 'Vorfahrtstraße';
            otherwise
                annotation_string = 'Unknown';
        end
    elseif (abstract_traffic_sign.color == Color.Unknown)
        % Unknown color.
        annotation_string = 'Unknown';
    end
   
    % Insert object annotation in resulting image.
    if strcmp(annotation_string, 'Unknown') && debug_mode
        annotated_image = insertObjectAnnotation(annotated_image, 'rectangle', abstract_traffic_sign.bounding_box, annotation_string,...
            'TextBoxOpacity', 0.9, 'FontSize', 18, 'LineWidth', 3, 'Color', 'red');    
    elseif ~strcmp(annotation_string, 'Unknown')
        annotated_image = insertObjectAnnotation(annotated_image, 'rectangle', abstract_traffic_sign.bounding_box, annotation_string,...
            'TextBoxOpacity', 0.9, 'FontSize', 18, 'LineWidth', 3, 'Color', 'green'); 
    end
    
end

end