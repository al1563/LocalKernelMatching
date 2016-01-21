function T = LKMReg(aPts, bPts, k, mlModel, display)

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
        subplot(1, 2, 1)
        displayPoints(aPts,bPts)
        set(gca,'FontSize',16)
        title('Initial position')
        drawnow
        subplot(1, 2, 2)
    end
    
    %%%%%%%%%%
    % center images at origin
    %%%%%%%%%%
    
    center = mean(aPts);
    aPts = aPts - repmat(center, length(aPts), 1);
    bPts = bPts - repmat(center, length(bPts), 1);

    %%%%%%%%%%
    % compute kernels
    %%%%%%%%%%
    
    aKernels = computeKernels(aPts, k);
    bKernels = computeKernels(bPts, k);
    
    %%%%%%%%%%
    % initialize transform
    %%%%%%%%%%
    
    T0 = [1 0 0; 0 1 0];
        
    %%%%%%%%%%
    % optimize transform with respect to local kernel matching
    %%%%%%%%%%
    
    % using anonymous function LKsim in order to use multiple parameters in
    % fminsearch
    LKsim = @(t) LKsimilarity(affineTransform(t, aPts), bPts, aKernels, bKernels, mlModel, display);
    
    % maybe a numerical gradient descent would be faster than fminsearch
    T = fminsearch(LKsim, T0);
    
    %%%%%%%%%%
    % wrap transform with centering at origin and then moving back
    %%%%%%%%%%
    
    centerAtOrigin = [1 0, -center(1); 0 1, -center(2); 0 0 1];
    moveBack = [1 0 center(1); 0 1 center(2); 0 0 1];
    T = moveBack * [T; 0 0 1] * centerAtOrigin;
    T = T(1:2, :);
     
end