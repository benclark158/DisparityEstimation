function [energy] = energyFunction(D, leftI, rightI, parent)
%ENERGYFUNCTION Summary of this function goes here
%   Detailed explanation goes here

data = 0;
smooth = 0;

lambda = 1;

numNodes = size(D, 1);

m =@(p, dr)min(abs( leftI(p) - rightI(p + dr) ), 100);

for i = 1:numNodes
    data = data + m(i, D(i));
end

for i = 1:size(parent, 2)
    smooth = smooth + smoothing(d(i), d(parent(i)));
end

energy = data + (lambda * smooth);

end

