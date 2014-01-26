function XN = cordNoi(cord, nN)
% Generate 3-D noise point.
%
% Input
%   cord    -  cordinates, 3 x kJ x nF
%   nN      -  #noise points
%
% Output
%   XN      -  3-d noise, 3 x nN x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-27-2013

% function parameter
rad = 0.01; % random radius for sampling random point

% dimension
nF = size(cord, 3);

% boundary
box = cordBox(cord, []);
box([2 3], :) = box([3 2], :);
Mi = repmat(box(:, 1), 1, nN);
Ma = repmat(box(:, 2), 1, nN);

% generate 3-D noise
XN = zeros(3, nN, nF);
for iF = 1 : nF
    
    % 1st frame
    if iF == 1
        XNi = rand(3, nN);
        XNi = (Ma - Mi) .* XNi + Mi;
        
    % frame two ...
    else
        % random shift from previous frame
        XD0 = randn(3, nN) * rad;
        XD = (Ma - Mi) .* XD0;
        
        XNi = XN(:, :, iF - 1) + XD;
        
        % make sure random point is in the boundary
        for c = 1 : 3
            vis = XNi(c, :) < box(c, 1);
            XNi(c, vis) = box(c, 1);
   
            vis = XNi(c, vis) > box(c, 2);
            XNi(c, vis) = box(c, 2);
        end
    end
    
    % store
    XN(:, :, iF) = XNi;
end
