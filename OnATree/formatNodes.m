function [nodes] = formatNodes(tree0, img0)
%FORMATNODES formates the nodes in the tree so that they can be interpretted correctly by dynamic programming

%%inits
numNodes = size(tree0.Nodes, 1);
[xSize, ySize, ~] = size(img0);

nRGB(numNodes, :) = [0, 0, 0];


%% remove weights from struct
weightsTmp = tree0.Edges.Weight;
tree0.Edges.Weight = ones(size(weightsTmp, 1), 1);

%% re organise tree structure
% its not correct parent->child in matlab representation

% set "optimum" root node
rootTmps = [1, ...
    ceil(numNodes / 2), ...
    ceil(numNodes / 2) + ceil(numNodes / 4), ...
    ceil(numNodes / 2) - ceil(numNodes / 4), ...
    randperm(numNodes,50)];
	
distsTmp = distances(tree0, rootTmps);

[~, index] = min(max(transpose(distsTmp)));
dists = distsTmp(index, :);
rootNode = rootTmps(index);

% init variables
connectionsML = tree0.Edges.EndNodes;
parentChild = zeros(size(connectionsML, 1), 2);

numIn = 1;
inTree(numNodes) = false;
p = 0;
connectsArray = zeros(size(connectionsML, 1) + 1, 4);
numConnects = ones(size(connectionsML, 1) + 1, 1);

% create list of connections
for i = 1:size(connectionsML, 1)
    val1 = connectionsML(i, 1);
    val2 = connectionsML(i, 2);
    connectsArray(val1, numConnects(val1)) = val2;
    numConnects(val1) = numConnects(val1) + 1;
    
    connectsArray(val2, numConnects(val2)) = val1;
    numConnects(val2) = numConnects(val2) + 1;
end

%iterate over added nodes (starting at root) to add parent->child connections
while numIn ~= numNodes && p <= size(connectsArray, 1) && p <= numIn
    if(p ~= 0)
        searchVal = parentChild(p, 2);
    else
        searchVal = rootNode;
    end
    
    connections = connectsArray(searchVal, :);
    
    for i = size(connections, 2):-1:1
        conn = connections(i);
        if(conn ~= 0 && not(inTree(conn)))
            parentChild(numIn, :) = [searchVal, conn];
            numIn = numIn + 1;
        end
    end
    inTree(searchVal) = true;
    p = p + 1;
end

endNodes = parentChild;

%% get list of parent nodes
parentNodes(numNodes) = false;
parentNodes(:) = not(parentNodes(:));
parentNodes(endNodes(:, 1)) = false;

%% get parents of nodes
parents(endNodes(:, 2)) = endNodes(:, 1);

%% get list of child nodes for each parent node
childNodes = connectsArray;
childNodes(childNodes==transpose(parents)) = 0;

%% get all data for nodes
reshapedImg = reshape(img0, [xSize*ySize 3]);
intensity = rgb2gray(img0);

nRGB(:) = reshapedImg(:);
nRGB(:, 4) = intensity(:);

%% re add weights
tree0.Edges.Weight = weightsTmp;

nodes = struct('rootNode', rootNode, 'nName', 1:numNodes, 'nEdge', parentNodes, 'nDepth', dists, 'nRGB', nRGB, 'nChildren', childNodes, 'nParent', parents);

end

