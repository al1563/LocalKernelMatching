load testdata

k = 20; % kernel size
N = 100; % point sample size

% take random sample of points
[aPts(:, 1), aPts(:, 2)] = find(A);
[bPts(:, 1), bPts(:, 2)] = find(B);
R1 = randperm(length(aPts));
R2 = randperm(length(bPts));
aPts_sample = aPts(R1(1:N), :);
bPts_sample = bPts(R2(1:N), :);

% perform registration
T = LKMReg(aPts_sample, bPts_sample, k);