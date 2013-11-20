function [Trass, Ptss, As] = traInp(Tra0ss, Pt0ss, A0s, P)
% Do interp1 in trajectory.
%
% Input
%   Tra0ss  -  original trajectory position, 1 x m (cell), 1 x ki (cell), d x nF
%   Pt0ss   -  original graph node set, 1 x m (cell), 1 x nF (cell), d x k_{t_i}^i
%   A0s     -  original trajectory status, 1 x m (cell), ki x nF
%   P       -  warping path, l x m
%
% Output
%   Trass   -  new trajectory position, 1 x m (cell), 1 x ki (cell), d x nF
%   Ptss    -  new graph node set, 1 x m (cell), 1 x nF (cell), d x k_{t_i}^i
%   As      -  new trajectory status, 1 x m (cell), ki x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 10-06-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
m = size(P, 2);

% per trajectory
[Trass, Ptss, As] = cellss(1, m);
for i = 1 : m
    % original data
    X0 = mcvTraA2X(Tra0ss{i}, A0s{i});
    
    [d, k, nF] = size(X0);
    X0 = reshape(X0, [], nF);
    
    % time warping
    X = X0(:, P(:, i));
    As{i} = A0s{i}(:, P(:, i));
    
    X = reshape(X, d, k, []);
    
    % re-convert
    Trass{i} = mcvXA2Tra(X, As{i});
    Ptss{i} = mcvXA2Pt(X, As{i});
end
