classdef LKM
    %LKM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function kernels = computeKernels(ptset, k)
            [~, kernels] = knnsearch(ptset.coords, ptset.coords, 'k', k + 1);
            kernels(:, 1) = [];
            kernels = normr(kernels); 
        end
        
        function sim = similarity(aPts, bPts, aKernels, bKernels, mlModel)
            % compute the similarity of point clouds aPts and bPts,
            % using precomputed kernels

            % compute the distance from each point in b to its nearest neighbor in
            % a
            [nearestNeighbors, nnDist] = knnsearch(aPts.coords, bPts.coords);

            % pair up the kernels of nearest neighbors
            % note some bKernels will be paired with the same aKernel
            kernels = [aKernels(nearestNeighbors, :) bKernels nnDist];

            % apply machine learning model to 'kernels'
            Ktest = constructKernel(kernels, mlModel.training, mlModel.opts);
            Yhat = Ktest * mlModel.eigvector;

            sim = -sum(Yhat);
        end
        
        function mlModel = trainModel(ims, k, N)

            % k: kernel size
            % N: size of point sample
            % ims is a cell array with fields A, B, and groundtruth.
            % A, B: binary images
            % groundtruth: 2x3 matrix representing optimal affine transform btwn
            % A and B

            training = [];
            labels = [];

            for i = 1:length(ims)
                % get point coordinates
                aPts = PointSet(ims{i}.A).randomSample(N);
                bPts = PointSet(ims{i}.B).randomSample(N);

                % compute kernels for each image
                aKernels = LKM.computeKernels(aPts, k);
                bKernels = LKM.computeKernels(bPts, k);

                % transform A images by their groundtruths
                gt = affineTransform(ims{i}.groundtruth);
                aPts_t = gt.transform(aPts);

                % create training set of pairs of matching points.
                % determine matching points by finding single nearest neighbor.
                [nearestNeighbors, distances] = knnsearch(aPts_t.coords, bPts.coords);
                matching = [aKernels(nearestNeighbors, :) bKernels distances];

                % create training set of pairs non-matching points.
                % determine pairs by pairing points at random from A and B.
                aPtsRand = aPts.randomSample(N);
                bPtsRand = bPts.randomSample(N);
                distances = sum((aPtsRand.coords - bPtsRand.coords) .^ 2, 2) .^ 0.5;
                nonmatching = [...
                    LKM.computeKernels(aPtsRand, k), ...
                    LKM.computeKernels(bPtsRand, k), ...
                    distances];

                training = [training; matching; nonmatching];
                labels = [labels; ones(N, 1); zeros(N, 1)];

            end

            % perform machine learning on the training set
            opts            = [];
            opts.ReguAlpha  = 0.01;  % [0.0001, 0.1]
            opts.ReguType   = 'Ridge';
            opts.gnd        = labels;   % groundtruth (flair vector length)
            opts.KernelType = 'Gaussian';
            opts.t          = 6;    % [4, 10]  

            K = constructKernel(training, training, opts);
            [mlModel.eigvector, ~] = KSR(opts, labels, K);
            mlModel.opts = opts;
            mlModel.training = training;
        end

        function T = register(A, B, k, N, mlModel, display)

            % aPts and bPts are nx2 and mx2 matrictes representing point clouds to be registered
            % k is the number of nearest-neighbor points to use in each kernel
            % 
            % T is a 2x3 matrix representing an affine transform which optimally
            % maps aPts to bPts

            aPts = PointSet(A).randomSample(N);
            bPts = PointSet(B).randomSample(N);
            aPts.centerAtOrigin();
            bPts.centerAtOrigin();

            %%%%%%%%%%
            % set up display
            %%%%%%%%%%

            if display
                subplot(1, 2, 1)
                displayPoints(aPts,bPts)
                set(gca,'FontSize',16)
                title('Initial position')
                drawnow
                subplot(1, 2, 2)
                set(gca,'FontSize',16)
            end

            %%%%%%%%%%
            % compute kernels
            %%%%%%%%%%

            aKernels = LKM.computeKernels(aPts, k);
            bKernels = LKM.computeKernels(bPts, k);

            %%%%%%%%%%
            % initialize transform
            %%%%%%%%%%

            % xshift, yshift, xscale, yscale, rotate
            affineParams = [0 0 1 1 0];

            %%%%%%%%%%
            % optimize transform with respect to local kernel matching
            %%%%%%%%%%

            % using anonymous function LKsim in order to use multiple parameters in
            % fminsearch
            curly = @(x, varargin) x{varargin{:}};

            similarity = @(t) LKM.similarity(affineTransform(t).transform(aPts), ...
                bPts, aKernels, bKernels, mlModel);
            show = @(t) displayPoints(affineTransform(t).transform(aPts), bPts);
            
            if display
                LKsim = @(t) curly({similarity(t), show(t)}, 1);
            else
                LKsim = similarity;
            end

            % maybe a numerical gradient descent would be faster than fminsearch
            T = fminsearch(LKsim, affineParams);

            %%%%%%%%%%
            % wrap transform with centering at origin and then moving back,
            % to preserve rotation about center of gravity
            %%%%%%%%%%

            center = aPts.centerOfGravity;
            centerAtOrigin = [1 0, -center(1); 0 1, -center(2); 0 0 1];
            moveBack = [1 0 center(1); 0 1 center(2); 0 0 1];
            T = affineTransform(T).toMatrix();
            T = moveBack * [T; 0 0 1] * centerAtOrigin;
            T = T(1:2, :);

        end


    end
    
end

