load testdata

% Train the model

ims{1}.A = A;
ims{1}.B = B;
ims{1}.groundtruth = groundtruth;

k = 50;
N = 500;

mlModel = LKM.trainModel(ims, k, N);

% use twice the points for registration as were used for training
N = N * 2;

% perform registration
T = LKM.register(A, B, k, mlModel, true);