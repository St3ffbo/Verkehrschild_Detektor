function abstract_traffic_signs = createAbstractTrafficSigns(color, numbers_vertices_vectors, bounding_boxes)
number_vertices = size(numbers_vertices_vectors, 1);
number_bounding_boxes = size(bounding_boxes, 1);

if (number_vertices ~= number_bounding_boxes)
    error('Numbers of vertice counts and bounding boxes do not match')
    quit;
end
    
abstract_traffic_signs = cell(1, number_bounding_boxes);

for index = 1:number_bounding_boxes
    abstract_traffic_signs{index} = AbstractTrafficSign(color, numbers_vertices_vectors(index), bounding_boxes(index, :), NaN);
end
end
