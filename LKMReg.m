function T = LKMReg(aPts, bPts, k, display)

    %{
        aPts and bPts are nx2 and mx2 matrictes representing point clouds to be registered
        k is the number of nearest-neighbor points to use in each kernel

        T is a 2x3 matrix representing an affine transform which optimally
        maps aPts to bPts
    %}

    %%%%%%%%%%
    % set up display
    %%%%%%%%%%
    
    if display
        subplot(1,2,1)
        displayPoints(aPts,bPts)
        set(gca,'FontSize',16)
        title('Initial position')
        drawnow
    end

    %%%%%%%%%%
    % compute kernels
    %%%%%%%%%%
    
    % the first nearest neighbor to any point will be itself, so get one
    % extra nearest neighbor and then remove the first one
    [~, aKernels] = knnsearch(aPts, aPts, 'k', k + 1);
    [~, bKernels] = knnsearch(bPts, bPts, 'k', k + 1);
    aKernels(:, 1) = [];
    bKernels(:, 1) = [];
    
    % normalize kernel rows, making kernels invariant to scaling
    aKernels = normr(aKernels);
    bKernels = normr(bKernels);
    
    %%%%%%%%%%
    % initialize transform
    %%%%%%%%%%
    
    T0 = [1 0 0; 0 1 0];
    transform = @(t, pts) round((t * [pts'; ones(1, size(pts, 1))])');
        
    %%%%%%%%%%
    % optimize transform with respect to local kernel matching
    %%%%%%%%%%
    
    % using anonymous function LKsim in order to use multiple parameters in
    % fminsearch
    LKsim = @(t) LKsimilarity(transform(t, aPts), bPts, aKernels, bKernels, display);
    
    % maybe a numerical gradient descent would be better than fminsearch
    T = fminsearch(LKsim, T0);
     
end