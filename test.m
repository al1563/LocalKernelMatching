load 10a.mat a_frangi b_frangi

k = 20;
N = 100;

[aPts(:, 1), aPts(:, 2)] = find(a_frangi);
[bPts(:, 1), bPts(:, 2)] = find(b_frangi);
R1 = randperm(length(aPts));
R2 = randperm(length(bPts));
aPts_sample = aPts(R1(1:N), :);
bPts_sample = bPts(R2(1:N), :);

T = LKMReg(aPts_sample, bPts_sample, k);