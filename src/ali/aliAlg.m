function [ali, Ys] = aliAlg(alg, Xs, Ks, ali0, aliT, par, varargin)
% Align two sequences with specific algorithm.
%
% Input
%   alg     -  algorithm name, 'dtw' | 'ddtw' | 'ctw' | 'kctw' | 'imw' | 'ftw' | 'pdtw'
%   Xs      -  original sequences, 1 x m (cell), di x ni (i = 1 : m)
%   Ks      -  frame similarities (for kctw), 1 x m (cell), ni x ni (i = 1 : m)
%   ali0    -  initial alignment
%   aliT    -  ground-truth alignment, can by empty
%   par     -  alignment parameter
%   varargin
%     save option
%     Ps    -  bases, only used when alg == 'ftw'
%
% Output
%   ali     -  alignment
%   Ys      -  new sequences, 1 x 2 (cell), bi x ni (i = 1 or 2)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-16-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 12-02-2011

% save option
[svL, path] = psSv(varargin, 'subx', alg);
if svL == 2 && exist(path, 'file')
    prom('m', 'old alignment (%s)\n', alg);
    [ali, Ys] = matFld(path, 'ali', 'Ys');
    return;
end

% algorithm
prom('m', 'new alignment (%s)\n', alg);
if strcmp(alg, 'dtw')
    ali = dtw(Xs);
    Ys = Xs;

elseif strcmp(alg, 'ddtw')
    [ali, Ys] = ddtw(Xs);

elseif strcmp(alg, 'imw')
    [ali, Ys] = imw(Xs, par);

elseif strcmp(alg, 'ctw')
    par.knl = 'n';
    [ali, Ys] = ctw(Xs, ali0, par);

elseif strcmp(alg, 'lctw')
    [ali, Ys] = lctw(Xs, ali0, par);

elseif strcmp(alg, 'kctw')
    par.knl = 'y';
    [ali, Ys] = ctw(Ks, ali0, par);

elseif strcmp(alg, 'pdtw')
    [ali, objs] = pdtw(Xs, ali0, par);
    Ys = objs;

elseif strcmp(alg, 'ftw')
    Ps = ps(varargin, 'Ps', []);
    [ali, as, A, objs] = ftw(Xs, Ps, ali0, par);
    Ys = objs;

else
    error(['unknown align algorithm: ', alg]);
end

% differnece rate
if ~isempty(aliT)
    ali.dif = aliDif(ali, aliT);
end

% save
if svL > 0
    save(path, 'ali', 'Ys');
end
