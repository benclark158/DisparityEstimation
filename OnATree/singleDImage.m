function [ singleDim ] = singleDImage(imgRGB)
%SINGLEDIMAGE Converts image into 1D array

    Iimg = rgb2gray(imgRGB);
    [height, width, xS] = size(Iimg);
    
    singleDim = zeros(height * width, xS);
    
    for x = 1:width
        for y = 1:height
            index = (y-1) * width + (x-1) + 1;
            singleDim(index, :) = Iimg(y, x, :);
        end
    end

end

