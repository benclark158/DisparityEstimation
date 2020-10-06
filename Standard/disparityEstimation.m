function [ disparity ] = disparityEstimation( left, right )
%disparityEstimation Estimates disparity using dynamic programming, given 
% by the left and right images provided.

    [height, width, ~] = size(left);
    
    leftInt = (left);
    rightInt = (right);
    
    disp = ones(height, width) * -1;
    
    occlusionConstant = 20;
    
    for y = 1:height
        
        comps = sum(abs(double(leftInt(y, :)) - double(transpose(rightInt(y, :)))));
        C = zeros(size(comps));
        [ycs, xcs] = size(comps);
        
        for j = 2:xcs
            for i = 2:ycs
                c1 = C(i-1, j-1) + comps(i, j);
                c2 = C(i-1, j) + occlusionConstant;
                c3 = C(i, j-1) + occlusionConstant;
                C(i, j) = min(min(c1, c2), c3);
            end           
        end
        
        cx = size(comps, 1);
        cy = size(comps, 2);

        while cx ~= 1 && cy ~= 1
            c1 = C(cy-1, cx-1) + comps(cy, cx);
            c2 = C(cy-1, cx) + occlusionConstant;
            c3 = C(cy, cx-1) + occlusionConstant;
            [~, index] = min([c1, c2, c3] - C(cy, cx));
            
            if(index == 1)
                cy = cy - 1;
                cx = cx - 1;
            elseif(index == 2)
                cy = cy - 1;
            elseif(index ==3)
                cx = cx - 1;
            end
            
            if(disp(y, cx) < 0)
                disp(y, cx) = abs(cx - cy);
            end
        end
    end
    img = disp / max(disp(:));
    
    if(min(img) < 0)
        img = img + abs(min(img(:)));
    end
    disparity = img;
end

