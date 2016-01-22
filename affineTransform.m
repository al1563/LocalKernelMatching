classdef affineTransform
    
    properties(Constant)
        % in order to search a normalize affine transform space,
        % normalize the transform parameters by these weights
        
        % xshift, yshift, xscale, yscale, rotate
        weights = [1 1 1 1 1];
    end
    
    properties
        params
    end
    
    methods
        function T = affineTransform(params)
            if all(size(params) == [1 5])
                % params is a paramter vector:
                % xshift, yshift, xscale, yscale, rotate
                T.params = params;
            else
                % T is a transformation matrix. extract the parameters.
                % this explains the method for extracting.
                % http://math.stackexchange.com/questions/612006/decomposing-an-affine-transformation
                A = params(1, 1);
                B = params(2, 1);
                C = params(1, 2);
                D = params(2, 2);
                E = params(1, 3);
                F = params(2, 3);
                
                xshift = E;
                yshift = F;
                yscale = (B ^ 2 + D ^ 2 ) ^ .5;
                rotate = asin(B / yscale);
                xscale = A / cos(rotate);
                
                T.params = [xshift yshift xscale yscale rotate];
            end
        end
        
        % generate a transformation matrix from the parameters
        function matrix = toMatrix(T)
            weightedParams = T.params .* T.weights;
            
            shift = [1 0 weightedParams(1); ...
                     0 1 weightedParams(2); ...
                     0 0 1];
            scale = [weightedParams(3) 0 0; ...
                     0 weightedParams(4) 0; ...
                     0 0 1];
            rotation = [cos(weightedParams(5)), -sin(weightedParams(5)) 0; ...
                        sin(weightedParams(5)) cos(weightedParams(5))   0; ...
                        0 0 1];
            matrix = shift * scale * rotation;
            matrix = matrix(1:2, :);
        end
        
        function ptsT = transform(T, ptset)
            pts = ptset.coords;
            % pad with ones, to multiply by a 2x3 matrix
            pts = [pts'; ones(1, size(pts, 1))];
            % perform transformation
            pts = (T.toMatrix() * pts)';
            ptsT = PointSet(pts);
        end
    end
    
end

