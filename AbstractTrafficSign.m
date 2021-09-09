% Defines an object that represents a possible traffic sign.

classdef AbstractTrafficSign
    properties
        color
        vertex_indices
        bounding_box
        inner_content
    end
    methods
        function obj = AbstractTrafficSign(color, vertex_indices, bounding_box, inner_content)
                obj.color = color;
                obj.vertex_indices = vertex_indices;
                obj.bounding_box = bounding_box;
                obj.inner_content = inner_content;
        end
    end
end