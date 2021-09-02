function corner_number_array = cornerCounter(distances_to_outlines)
number_images = size(distances_to_outlines, 2);
corner_number_array = cell(1, number_images);

for image_index = 1:number_images
    
    y = abs(fft(distances_to_outlines{image_index}));
    y = y(2:10);
    f = (2:10)-1;
    figure('Name', 'fft of outline distances');
    avg = mean(y);
    plot(3,avg);
    hold on;
    stem(f,y)
    hold on;
end
end

