% Computes a number of vertices for a given distance outline vector using 
% the FFT.
% Input: The distance outline vector of a shape.
% Output: A vector containing the numbers of vertices for each given shape
% and their corresponding FFT.

function [sorted_indices, fft_arrays] = vertexCounter(distances_to_outlines)

% Determine the number of specified images.
number_images = size(distances_to_outlines, 2);

% Create cell arrays to store the vertex numbers and FFTs in.
sorted_indices = cell(1, number_images);
fft_arrays = cell(1, number_images);

% Iterate over each given image.
for image_index = 1:number_images        
    
    % Compute FFT of outline distances of each given relevant area.
    y = abs(fft(distances_to_outlines{image_index}));
    fft_arrays{image_index} = y(2:10);
    
    % Sort values and their indices.
    [sorted, indices] = sort(fft_arrays{image_index}, 'descend');
    sorted_indices{image_index} = indices;      
    
end

end

