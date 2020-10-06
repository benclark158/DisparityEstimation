function [tree, G] = generateTree(img0)
%CREATETREE creates tree structure from image

intensity = rgb2gray(img0);
[xSize, ySize] = size(intensity);

% gets all the image connections - 4 connected grid
data = calcConnectionData(intensity, xSize, ySize);

connectionSize = (xSize*ySize) - 1;

% creates graph of connections 
start = (ones(connectionSize, 1) * connectionSize * -1);
target = (ones(connectionSize, 1) * connectionSize * -1);
weight = ones(connectionSize, 1) * 100000;

index = 0;
idMap = zeros(xSize, ySize);

for z = 1:2
    for x = 1:xSize
        for y = 1:ySize
            if(data(x, y, z) > 999), continue; end
            
            index = index + 1;
            weight(index) = data(x, y, z);
            start(index) = (x-1) * ySize + (y-1) + 1;
            idMap(x, y) = start(index);

            if(z == 1),target(index) = (x) * ySize + (y-1) + 1;
            elseif(z == 2),target(index) = (x-1) * ySize + (y) + 1;end
        end
    end
end

G = graph(start, target, weight);

%creats min spanning tree from graph
[tree, ~] = minspantree(G);

end





