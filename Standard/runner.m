
%% looper

images = ["sawtooth", "cones", "teddy", "venus"];

for i = 1:size(images, 2)
    name = images(i);
    left = imread(name + 'Left.png');
    right = imread(name + 'Right.png');
    groundTruth = imread(name + 'DispLeft.png');

    tic;
    disp = disparityEstimation(left, right);
    time = toc;

    [ mse, rmse, sim ] = compare(disp, groundTruth);

    figure;
    imshow(disp);

    printData(name, mse, rmse, sim, time);
end