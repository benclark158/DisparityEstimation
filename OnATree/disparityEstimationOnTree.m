function [ disp ] = disparityEstimationOnTree( imgLeft, imgRight )
%disparityEstimationOnTree Performs dynamic programming on a tree structure
% this file is for reference only as quoted in the report

%create the tree structure
[treeLeft, G] = generateTree(imgLeft);

%format the tree structure appropiately
nodesLeft = formatNodes(treeLeft, imgLeft);

%perform dynamic programming
disp = dp(nodesLeft, imgLeft, imgRight);
figure; 
imshow(disp);

end