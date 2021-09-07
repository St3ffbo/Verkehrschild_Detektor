% Defines an object that represents the inner content of a possible traffic sign.

classdef InnerContent
    properties
        number_inner_areas
        ratio
    end
    methods
        function obj = InnerContent(number_inner_areas, ratio)
                obj.number_inner_areas = number_inner_areas;
                obj.ratio = ratio;
        end
    end
end