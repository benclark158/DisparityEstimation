function [ energy ] = energyAtNode(node, L, R, parentDisp, m, children, width, searchSize, eMap)
%ENERGYATNODE gets energy at a node
   
    global OCCLUSION_CONST;

    %all possible disparities
    xCurr = mod(node - 1, width) + 1;       
    disps = -xCurr + 1:1:width - xCurr;
    di = 1:width;
    
    %get total enery matrix for children
    energyOfChildren = 0;
    for c = 1:size(children, 2)
    	energyOfChildren = energyOfChildren + eMap(children(c), di);
    end
        energyOfChildren = 0;
        
    %calculate energy matrix of node
    try
        %Occlusions
        mConst = m(L, R, node, disps);

        energy = (transpose(mConst) + energyOfChildren);
        energy = energy + smoothing(disps, (parentDisp));
        energy = min(energy);
       
    catch me
        disps;
    end
%end

