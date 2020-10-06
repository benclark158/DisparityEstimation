function [ disparity ] = disparityAtNode(node, L, R, parentDisp, m, children, width, eMap)
%ENERGYATNODE gets disparity at node
   
    %all possible disparities
    xCurr = mod(node - 1, width) + 1;       
    disps = -xCurr + 1:1:width - xCurr;
    di = 1:width;
    
    %disps = padarray(disps, [0, width - size(disps, 2)], 0, 'pre');
    
    energyOfChildren = 0;
    for c = 1:size(children, 2)
    	e = eMap(children(c), di);
    	energyOfChildren = energyOfChildren + e;
    end

    e1 = transpose(m(L, R, node, disps)) + energyOfChildren + smoothing(disps, parentDisp);
    %e1(abs(disps)>100) = 10000000;
    [value, dispInd] = min(transpose(e1));
    disparity = disps(dispInd);
end

