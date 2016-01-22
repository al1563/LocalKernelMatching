load testdata

% Train the model

ims{1}.A = A;
ims{1}.B = B;
ims{1}.groundtruth = groundtruth;

k = 50;
N = 500;

mlModel = LKM.trainModel(ims, k, N);

% perform registration
T = LKM.register(A, B, k, N, mlModel, true);