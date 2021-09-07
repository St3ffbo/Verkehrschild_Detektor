% Computes a number of vertices for a given distance outline vector using 
% the FFT.
% Input: The distance outline vector of a shape.
% Output: A vector containing the numbers of vertices for each given shape
% and their corresponding FFT.

function [vertex_number_array, fft_arrays] = vertexCounter(distances_to_outlines)

% Determine the number of specified images.
number_images = size(distances_to_outlines, 2);

% Create cell arrays to store the vertex numbers and FFTs in.
vertex_number_array = cell(1, number_images);
fft_arrays = cell(1, number_images);

% Iterate over each given image.
for image_index = 1:number_images        
    
    % Compute FFT of outline distances of each given relevant area.
    y = abs(fft(distances_to_outlines{image_index}));
    fft_arrays{image_index} = y(2:10);
    
    % Based on the maxima at different indices, determine the most likely
    % number of vertices.
    [sorted, indices] = sort(fft_arrays{image_index}, 'descend');
    if indices(1) == 2
        if indices(2) == 4
            vertex_number_array{image_index} = 4;
        elseif indices(2) == 8
            vertex_number_array{image_index} = 8;
        elseif indices(2) == 3  %??!?!?!
            vertex_number_array{image_index} = 3;
        else
            vertex_number_array{image_index} = 2;
        end
    elseif indices(1) == 3
        vertex_number_array{image_index} = 3;
    elseif indices(1) == 4
        vertex_number_array{image_index} = 4;
    elseif indices(1) == 8
        vertex_number_array{image_index} = 8;
    else
        vertex_number_array{image_index} = 0;
    end   
    
end

end

