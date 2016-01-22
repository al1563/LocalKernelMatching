load testdata

% Train the model

ims{1}.A = patient2A;
ims{1}.B = patient2B;
ims{1}.groundtruth = patient2groundtruth;

k = 50;
N = 500;

mlModel = LKM.trainModel(ims, k, N);

% perform registration
T = LKM.register(patient1A, patient1B, k, N, mlModel, true);