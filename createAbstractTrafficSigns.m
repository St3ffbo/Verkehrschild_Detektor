% Creates instances if the AbstractTrafficSign class based on the
% information extracted in the pipeline.
% Input: Currently considered color, number of vertices and bounding box
% coordinates per area.
% Output: A collection of abstract traffic signs.

function abstract_traffic_signs = createAbstractTrafficSigns(color, sorted_indices, bounding_boxes, inner_content_information)

% Get number of vertex numbers and bounding boxes.
number_index_vectors = size(sorted_indices, 2);
number_bounding_boxes = size(bounding_boxes, 1);

% Check whether number_vertices and number_bounding_boxes are compatible.
if (number_index_vectors ~= number_bounding_boxes)
    error('Numbers of vertice counts and bounding boxes do not match')
end
    
% Instantiate abstract traffic signs using the specified information.
abstract_traffic_signs = cell(1, number_bounding_boxes);
for index = 1:number_bounding_boxes    
    abstract_traffic_signs{index} = AbstractTrafficSign(color, sorted_indices{1, index}, bounding_boxes(index, :), inner_content_information{index});    
end

end
