% Defines an object that represents a possible traffic sign.

classdef AbstractTrafficSign
    properties
        color
        number_vertices
        bounding_box
        inner_content
        ends
    methods
        function obj = AbstractTrafficSign(color, number_vertices, bounding_box, inner_content)
                obj.color = color;
                obj.number_vertices = number_vertices;
                obj.bounding_box = bounding_box;
                obj.inner_content = inner_content;
        end
    end
end