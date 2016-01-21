function mlModel = LKMTrain(ims, k, N)

    %{
        k: kernel size
        N: size of point sample
        ims is a cell array with fields A, B, and groundtruth.
        A, B: binary images
        groundtruth: 2x3 matrix representing optimal affine transform btwn
            A and B
    %}

    training = [];
    labels = [];

    for i = 1:length(ims)
        % get point coordinates
        aPts = [];
        bPts = [];
        [aPts(:, 1), aPts(:, 2)] = find(ims{i}.A);
        [bPts(:, 1), bPts(:, 2)] = find(ims{i}.B);
        
        % sample random subset of points
        R1 = randperm(length(aPts));
        R2 = randperm(length(bPts));
        aPts = aPts(R1(1:N), :);
        bPts = bPts(R2(1:N), :);
        
        % compute kernels for each image
        aKernels = computeKernels(aPts, k);
        bKernels = computeKernels(bPts, k);
        
        % transform A images by their groundtruths
        aPts_t = affineTransform(ims{i}.groundtruth, aPts);
        
        % create training set of pairs of matching points.
        % determine matching points by finding single nearest neighbor.
        [nearestNeighbors, distances] = knnsearch(aPts_t, bPts);
        matching = [aKernels(nearestNeighbors, :) bKernels distances];
        
        % create training set of pairs non-matching points.
        % determine pairs by pairing points at random from A and B.
        R1 = randperm(N);
        R2 = randperm(N);
        aPtsRand = aPts(R1, :);
        bPtsRand = bPts(R2, :);
        distances = sum((aPtsRand - bPtsRand) .^ 2, 2) .^ 0.5;
        nonmatching = [aKernels(R1, :) bKernels(R2, :) distances];
        
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

