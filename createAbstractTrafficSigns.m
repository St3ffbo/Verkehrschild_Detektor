% Creates instances if the AbstractTrafficSign class based on the
% information extracted in the pipeline.
% Input: Currently considered color, number of vertices and bounding box
% coordinates per area.
% Output: A collection of abstract traffic signs.

function abstract_traffic_signs = createAbstractTrafficSigns(color, numbers_vertices_vectors, bounding_boxes)
number_vertices = size(numbers_vertices_vectors, 2);
number_bounding_boxes = size(bounding_boxes, 1);

% Check whether number_vertices and number_bounding_boxes are compatible.
if (number_vertices ~= number_bounding_boxes)
    error('Numbers of vertice counts and bounding boxes do not match')
    quit;
end
    
% Instantiate abstract traffic signs from the specified information.
abstract_traffic_signs = cell(1, number_bounding_boxes);
for index = 1:number_bounding_boxes
    abstract_traffic_signs{index} = AbstractTrafficSign(color, numbers_vertices_vectors{index}, bounding_boxes(index, :), NaN);
end
end
