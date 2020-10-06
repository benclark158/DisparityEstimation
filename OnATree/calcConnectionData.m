function [data] = calcConnectionData(intensity, xSize, ySize)
%CREATETREE Summary of this function goes here
%   Detailed explanation goes here

    data = ones(xSize, ySize, 2) * 1000;

    for x = 1:(xSize)
        for y = 1:(ySize)
            if(x ~= xSize),data(x, y, 1) = intensity(x, y) - intensity(x + 1, y);end
            if(y ~= ySize),data(x, y, 2) = intensity(x, y) - intensity(x, y + 1);end
        end
    end
    data = abs(data);
end
