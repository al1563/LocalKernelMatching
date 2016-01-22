load testdata

% Train the model

k = 50;
N = 500;

mlModel = LKM.trainModel(training, k, N);

% perform registration
T = LKM.register(testing{1}.A, testing{1}.B, k, N, mlModel, true);