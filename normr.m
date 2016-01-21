function y = normr(x) 

% normalize each row of x to have unit length.
% ripoff of normr from the MATLAB neural network toolbox

y = double(size(x));
cols = size(x,2);
n = 1 ./ sqrt(sum(x.*x,2));
y = x .* n(:,ones(1,cols));

end