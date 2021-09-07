% Applies a color mask on the specified rgb image based on the specified
% color.
% Input: An rgb image and the mask's color.
% Output: A black-white image containing the areas filtered or kept by the
% mask. Also, the masked rgb image.

function [BW,masked_rgb_image] = colorMask(color, rgb_image)

% Based on the specified color, apply individual color masks.
switch(color)
    case Color.Red
        [BW, masked_rgb_image] = redMask(rgb_image);
    case Color.Yellow
        [BW, masked_rgb_image] = yellowMask(rgb_image);
    case Color.Unknown
        return;
end

end