function [ disparityMap ] = dp(nodes, imgLeft, imgRight)
%DP Summary of this function goes here
%   Detailed explanation goes here

    %% Prerequisits
    global OCCLUSION_CONST;
    global G1;
    global G2;
    
    OCCLUSION_CONST = 50;
    G1 = 1;
    G2 = 5;
    
    matching =@(Li, Ri, p, dv)min(abs( Li(p) - Ri(p + dv) ), OCCLUSION_CONST);

    numNodes = size(nodes.nName, 2);
    maxDepth = max(nodes.nDepth);
    depths = nodes.nDepth;

    leftI = singleDImage(imgLeft);
    rightI = singleDImage(imgRight);

    [height, width, ~] = size(imgLeft);

    rootNode = find(depths==0);

    eMap = ones(height * width, width) * 10000;
    dMap = ones(height * width, 1) * -1;

    searchSize = width; %floor(width / 4);
    
    %% Calculate energy for all nodes - except root node
    for i = maxDepth:-1:1
        indexs = find(depths==i);

        for x = 1:size(indexs, 2)
            node = indexs(x);

            children = nodes.nChildren(node, :);
            children(children == 0) = [];

            parent = nodes.nParent(node);

            xParent = mod(parent - 1, width) + 1;       
            dParent = -xParent + 1:1:width - xParent;
           
            e = energyAtNode(node, leftI, rightI, dParent, matching, children, width, searchSize, eMap);
            eMap(node, :) = e;
        end
    end
    
    %% Get Optimum disparity for root node
    children = nodes.nChildren(rootNode, :);
    children(children == 0) = [];

    xCurr = mod(rootNode - 1, width) + 1;       
    disps = -xCurr + 1:1:width - xCurr;
    di = 1:width;
                    
    energyOfChildren = 0;
    for c = 1:size(children, 2)
    	e = eMap(children(c), di);
    	energyOfChildren = energyOfChildren + e;
    end

    e1 = transpose(transpose(matching(leftI, rightI, rootNode, disps)) + energyOfChildren);
    e1(abs(disps)>200) = 10000000;
    [value, dispInd] = min(e1);
    dMap(rootNode) = disps(dispInd);
    
    
    %% Estimates the disparity at each node - going down the tree
    for i = 1:1:maxDepth
        indexs = find(depths==i);

        for x = 1:size(indexs, 2)
            node = indexs(x);

            children = nodes.nChildren(node, :);
            children(children == 0) = [];

            parent = nodes.nParent(node);
            dParent = dMap(parent);
            
            e = disparityAtNode(node, leftI, rightI, dParent, matching, children, searchSize, eMap);
            dMap(node) = e;
        end
    end
    
    disparityMap = single2img(abs(dMap), width, height);
end