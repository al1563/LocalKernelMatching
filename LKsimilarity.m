function similarity = LKsimilarity(aPts, bPts, aKernels, bKernels)
    %{
        compute the similarity of point clouds aPts and bPts,
        using precomputed kernels
    %}

    % compute the distance from each point in b to its nearest neighbor in
    % a
    [nearestNeighbors, nnDist] = knnsearch(aPts, bPts);
    
    % pair up the kernels of nearest neighbors
    % note some aKernels will be paired with the same bKernel
    kernels = [aKernels bKernels(nearestNeighbors, :) nnDist];

    % apply machine learning model to 'kernels'

    % placeholder
    similarity = 1;

end

