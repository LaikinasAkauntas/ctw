function tran = tranIni(algT, d, n, varargin)
% Initialize a transformation.
%
% Input
%   algT    -  transformation name, 'sim' | 'aff' | 'non'
%   d       -  dimension
%   n       -  #points (used only if algT == 'non')
%   varargin
%     rand  -  flag of randomly generating, 'y' | {'n'}
%
% Output
%   tran    -  transformation
%     algT  -  transformation name, 'sim' | 'aff' | 'non'
%     ** similarity **
%     R     -  rotation matrix, 2 x 2 | 3 x 3
%     s     -  scaling factor
%     t     -  translation vector, 2 x 1 | 3 x 1
%     ** affine **
%     V     -  projection matrix, 2 x 2 | 3 x 3
%     t     -  translation vector, 2 x 1 | 3 x 1
%     ** non **
%     W     -  weight matrix, 2 x n | 3 x n
%     K     -  kernel, n x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-16-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 03-19-2012

% function option
isRand = psY(varargin, 'rand', 'n');

% similarity transform
if strcmp(algT, 'sim')
    if isRand
        if d == 2
            R = cpd_R(rand(1));
            s = rand(1) * 4 + 1;
        else
            R = cpd_R(rand(1), rand(1), rand(1));
            s = rand(1) * 4 + 1;
        end
        t = zeros(d, 1);
    else
        R = eye(d);
        s = 1;
        t = zeros(d, 1);
    end

    tran = st('algT', algT, 'R', R, 's', s, 't', t);

% affine transform
elseif strcmp(algT, 'aff')
    if isRand
        if d == 2
            V = eye(2) + 0.5 * abs(randn(2, 2));
            t = zeros(d, 1) + .1;
        else
            V = cpd_R(rand(1), rand(1), rand(1)) + abs(0.1 * randn(3, 3));
            V = V * .1;
            t = zeros(d, 1) + .1;
        end
    else
        V = eye(d);
        t = zeros(d, 1);
    end

    tran = st('algT', algT, 'V', V, 't', t);

% non-rigid transform
elseif strcmp(algT, 'aff')
    if isRand
        K = eye(n);
        W = rand(2, n);
        
    else
        K = eye(n);
        W = zeros(2, n);
    end

    tran = st('algT', algT, 'K', K, 'W', W);
    
else
    error('unknown transformation name: %s', algT);
end
