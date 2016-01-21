load testdata

% Train the model

ims{1}.A = A;
ims{1}.B = B;
ims{1}.groundtruth = groundtruth;

k = 50;
N = 500;

mlModel = LKMTrain(ims, k, N);

% use twice the points for registration as were used for training
N = N * 2;

% take random sample of points
[aPts(:, 1), aPts(:, 2)] = find(A);
[bPts(:, 1), bPts(:, 2)] = find(B);
R1 = randperm(length(aPts));
R2 = randperm(length(bPts));
aPts_sample = aPts(R1(1:N), :);
bPts_sample = bPts(R2(1:N), :);

% perform registration
T = LKMReg(aPts_sample, bPts_sample, k, mlModel, true);