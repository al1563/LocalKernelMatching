classdef PointSet
    %POINTSET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        coords
        nPts
        xmin
        xmax
        ymin
        ymax
        centerOfGravity
    end
    
    methods
        function ptset = PointSet(A)
            if size(A, 2) ~= 2
                % A is a binary image
                [ptset.coords(:, 1), ptset.coords(:, 2)] = find(A);
            else
                % A is an Nx2 matrix of (x,y) point coordinates
                ptset.coords = A;
            end
            ptset.nPts = size(ptset.coords, 1);
            ptset.xmin = min(ptset.coords(:, 1));
            ptset.ymin = min(ptset.coords(:, 2));
            ptset.xmax = max(ptset.coords(:, 1));
            ptset.ymax = max(ptset.coords(:, 2));
            ptset.centerOfGravity = mean(ptset.coords);
        end
        
        function P = randomSample(ptset, N)
            R = randperm(ptset.nPts);
            P = PointSet(ptset.coords(R(1:N), :));
        end
        
        function show(ptset, ptspec)
            plot(ptset.coords(:, 1), ptset.coords(:, 2), ptspec)
        end
        
        function P = centerAtOrigin(ptset)
            P = PointSet(ptset.coords - repmat(ptset.centerOfGravity, ptset.nPts, 1));
        end
        
%         function P = centerAtCenter(ptset)
%             P = PointSet(ptset.coords + repmat(ptset.centerOfGravity, ptset.nPts, 1));
%         end
    end
    
end

