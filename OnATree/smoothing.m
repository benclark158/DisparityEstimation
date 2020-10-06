function [ s ] = smoothing(a, b)
%SMOOTHING Summary of this function goes here
%   Detailed explanation goes here

    global G1;
    global G2;
    
    %b = transpose(b);
    diff = abs(a - b);
    s = zeros(size(diff));
    s(diff <= 5 & diff > 0) = G1;
    s(diff > 5) = G2;
end