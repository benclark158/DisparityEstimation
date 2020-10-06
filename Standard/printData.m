function [] = printData(name, mse, rmse, sim, time)
%PRINTDATA Summary of this function goes here
%   Detailed explanation goes here
fprintf("\n\n" + name + "\n\n");
fprintf("MSE\t\t\t\tRMSE\t\t\tSSIM\t\t\tTime\n");
fprintf("----------------------------------------------------------\n")
fprintf("%f\t\t%f\t\t%f\t\t%f\n", mse, rmse, sim, time);
end

