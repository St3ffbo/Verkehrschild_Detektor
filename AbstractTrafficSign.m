classdef AbstractTrafficSign
    properties
        color
        number_vertices
        bounding_box
        inner_content
    end
    methods
        function obj = AbstractTrafficSign(color, number_vertices, bounding_box, inner_content)
                obj.color = color;
                obj.number_vertices = number_vertices;
                obj.bounding_box = bounding_box;
                obj.inner_content = inner_content;
        end
    end
end