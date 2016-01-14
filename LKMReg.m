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
    LKsim = @(t) LKsimilarity(affineTransform(t, aPts), bPts, aKernels, bKernels, display);
    
    % maybe a numerical gradient descent would be better than fminsearch
    T = fminsearch(LKsim, T0);
     
end