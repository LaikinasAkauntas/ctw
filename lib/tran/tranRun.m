function Pt = tranRun(Pt0, tran)
% Transform a point set.
%
% Input
%   Pt0     -  original point set, 2 x n
%   tran    -  transformation
%     algT  -  transformation name, 'sim' | 'aff' | 'non'
%
% Output
%   Pt      -  new point set, 2 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-11-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 03-20-2012

% transformation name
algT = tran.algT;

% dimension
n = size(Pt0, 2);

% similarity transform
if strcmp(algT, 'sim')
    % parameter
    [R, s, t] = stFld(tran, 'R', 's', 't');
    
    % rotate
    Pt = s * R * Pt0 + repmat(t, 1, n);

% affine transform
elseif strcmp(algT, 'aff')
    % parameter
    [V, t] = stFld(tran, 'V', 't');
    
    % project
    Pt = V * Pt0 + repmat(t, 1, n);
    
% non-rigid transform
elseif strcmp(algT, 'non')
    % parameter
    [W, K] = stFld(tran, 'W', 'K');
    
    % shift
    Pt = Pt0 + W * Kw;
    
% TPS (need to be improved)
elseif strcmp(algT, 'tps')
    % parameter
    [c_tps, d_tps] = stFld(tran, 'c_tps', 'd_tps');
    
    % compute the kernel
    K = ctps_gen(Pt0', Pt0');

    % warp pts --> pts1
    [n, dim] = size(Pt0');
    pts = [ones(n, 1), Pt0'];
    pts1 = pts * d_tps + K * c_tps;
    Pt = pts1(:, 2 : dim + 1)';

else
    error('unknown transformation name: %s', algT);
end
