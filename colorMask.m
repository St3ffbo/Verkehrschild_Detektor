function [BW,masked_rgb_image] = colorMask(color, rgb_image)
switch(color)
    case Color.Red
        [BW, masked_rgb_image] = redMask(rgb_image);
    case Color.Yellow
        [BW, masked_rgb_image] = yellowMask(rgb_image);
    case Color.White
        [BW, masked_rgb_image] = whiteMask(rgb_image);
    case Color.Unknown
        return;
end