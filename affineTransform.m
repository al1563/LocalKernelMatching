function transformedPts = affineTransform(t, pts)
    paddedPts = [pts'; ones(1, size(pts, 1))];
    transformedPts = round(t * paddedPts)';
end

