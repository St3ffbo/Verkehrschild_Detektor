function vertex_number_array = vertexCounter(distances_to_outlines, should_plot_fft)
number_images = size(distances_to_outlines, 2);
vertex_number_array = cell(1, number_images);

% Create a figure if FFTs should be plotted.
if should_plot_fft
    figure('Name', 'FFTs of outline distances');
end

for image_index = 1:number_images
    
    % Compute FFT of outline distances of each given relevant area.
    y = abs(fft(distances_to_outlines{image_index}));
    y = y(2:10);
    
    % Compute some stats to be able to say something about the number of
    % vertices.
    [M,I] = max(y);
    amp_ratios = y./M
    amp_ratio_mean = mean(amp_ratios);
    avg = mean(y);;
    %plot(3,avg);
    
    % Plot FFT of outline distances if desired in one subplot.
    if should_plot_fft
        subplot(number_images, 1, image_index);           
        f = (2:10)-1;        
        stem(f,y)            
        title(strcat('FFT of distance plot of relevant area no. ', num2str(image_index)));
    end    
    
end
end

