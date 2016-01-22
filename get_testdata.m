load verified_groundtruths

for i = 1:10
    load(nametags_verified{i})
    training{i}.A = a_frangi;
    training{i}.B = b_frangi;
    training{i}.groundtruth = T.tdata.T(:, 1:2)';
end

load(nametags_verified{11})
testing{1}.A = a_frangi;
testing{1}.B = b_frangi;
testing{1}.groundtruth = T.tdata.T(:, 1:2)';

save testdata training testing

%% verify groundtruths

for i = 1:10
    groundtruth = training{i}.groundtruth;
    A = PointSet(training{i}.A).randomSample(500);
    B = PointSet(training{i}.B).randomSample(500);
    aPtsT = affineTransform(groundtruth).transform(A);
    displayPoints(aPtsT, B);
    figure
end
