function X = areaAve(X0, area)
% Obtain the average value in each block.
%
% Input
%   X0      -  old matrix, h0 x w0
%   area    -  area position
%     iHs   -  1 x h
%     iTs   -  1 x h
%     jHs   -  1 x w
%     jTs   -  1 x w
%
% Output
%   X       -  new matrix, h x w
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
[iHs, iTs, jHs, jTs] = stFld(area, 'iHs', 'iTs', 'jHs', 'jTs');
h = length(iHs);
w = length(jHs);

% average
X = zeros(h, w);
for i = 1 : h
    for j = 1 : w      
        X0ij = X0(iHs(i) : iTs(i), jHs(j) : jTs(j));
        X(i, j) = mean(X0ij(:));
    end
end
