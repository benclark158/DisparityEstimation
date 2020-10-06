function [ img ] = single2img(single, width, height)
%SINGLE2IMG converts a one dimention array into image of width and height

    if(max(single) > 1)
        single = double(single) / double(max(single));
    end

    img = zeros(height, width);
    
    for i = 1:size(single, 1)
        x = mod(i - 1, width) + 1;
        y = floor((i - 1) / width) + 1;
        
        img(y, x) = single(i);
        
    end
end

