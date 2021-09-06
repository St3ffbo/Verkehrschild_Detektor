function [vertex_number_array, fft_arrays] = vertexCounter(distances_to_outlines)
number_images = size(distances_to_outlines, 2);

vertex_number_array = cell(1, number_images);
fft_arrays = cell(1, number_images);

for image_index = 1:number_images
    
    
    
    % Compute FFT of outline distances of each given relevant area.
    y = abs(fft(distances_to_outlines{image_index}));
    fft_arrays{image_index} = y(2:10);
    
    %variance_max = (std(fft_arrays{image_index}) / max(fft_arrays{image_index})) *100.0
    
    % Compute some stats to be able to say something about the number of
    % vertices.
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
    elseif indices(1) == 8
        vertex_number_array{image_index} = 8;
    else
        vertex_number_array{image_index} = 0;
    end   
end
end

