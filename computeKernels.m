function kernels = computeKernels(pts, k)
    %{
        the kernel of a point is the vector of distances from the point to
        its k nearest neighbors.
        kernels are normalized to unit vectors to make them invariant to 
        image scaling
    %}

    % the first nearest neighbor to any point will be itself, so get one
    % extra nearest neighbor and then remove the first one
    [~, kernels] = knnsearch(pts, pts, 'k', k + 1);
    kernels(:, 1) = [];
    
    kernels = normr(kernels);    
end

