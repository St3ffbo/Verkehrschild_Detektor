% Returns the edge images from the given images.
% Input: Gray/rgb images and the method with which the edge images should be
% computed.
% Output: Edge image of each given image.

function edge_images = findEdges(images, method)
% Create array that holds the edge images. 
number_images = size(images, 2);
edge_images = cell(1, number_images);

% Get edge image of each image.
for image_index = 1:number_images
    edge_images{image_index} = edge(rgb2gray(images{image_index}), method);
end
end