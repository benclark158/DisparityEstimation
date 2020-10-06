function [ mse, rmse, sim ] = compare( disp, groundTruth )
%COMPARE Summary of this function goes here
%   Detailed explanation goes here

    disp = double(disp);
    groundTruth = double(groundTruth);
    groundTruth = groundTruth / max(groundTruth(:));    
    
    
    mse = immse(disp, groundTruth);
    rmse = sqrt(mse);
    sim = ssim(disp, groundTruth);
end

