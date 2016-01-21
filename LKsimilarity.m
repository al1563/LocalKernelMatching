function similarity = LKsimilarity(aPts, bPts, aKernels, bKernels, mlModel, display)
    %{
        compute the similarity of point clouds aPts and bPts,
        using precomputed kernels
    %}

    % compute the distance from each point in b to its nearest neighbor in
    % a
    [nearestNeighbors, nnDist] = knnsearch(aPts, bPts);
    
    % pair up the kernels of nearest neighbors
    % note some bKernels will be paired with the same aKernel
    kernels = [aKernels(nearestNeighbors, :) bKernels nnDist];

    % apply machine learning model to 'kernels'
    Ktest = constructKernel(mlModel.training, kernels, mlModel.opts);
    Yhat = Ktest * mlModel.eigvector;

    similarity = sum(Yhat);
    
    if display
        displayPoints(aPts,bPts)
        set(gca,'FontSize',16)
        drawnow
    end
end

