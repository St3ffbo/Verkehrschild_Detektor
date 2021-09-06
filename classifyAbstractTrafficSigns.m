function annotated_image = classifyAbstractTrafficSigns(original_image, abstract_traffic_signs)

% Get copy of original_image to annotate.
number_traffic_signs = size(abstract_traffic_signs, 2);
annotated_image = original_image;

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
    annotated_image = insertObjectAnnotation(annotated_image, 'rectangle', abstract_traffic_sign.bounding_box, annotation_string,...
        'TextBoxOpacity', 0.9, 'FontSize', 18, 'LineWidth', 3, 'Color', 'green');    
end

end