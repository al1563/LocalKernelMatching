load testdata

ims{1}.A = A;
ims{1}.B = B;
ims{1}.groundtruth = groundtruth;

k = 20;
N = 1000;

model = LKMTrain(ims, k, N);