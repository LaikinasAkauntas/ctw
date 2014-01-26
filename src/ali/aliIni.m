function ali0 = aliIni(Xs, Ks, ini, varargin)
% Initialize the alignment. 
%
% Input
%   Xs      -  sequence, 1 x 2 (cell), di x ni (i = 1 or 2)
%   Ks      -  frame similarity (for kdtw), 1 x 2 (cell), ni x ni (i = 1 or 2)
%   ini     -  initialization algorithm, 'dtw' | 'unif'
%   varargin
%     save option
%
% Output
%   ali0    -  alignment
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-16-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% save option
[svL, path] = psSv(varargin, 'subx', 'ini');

% load
if svL == 2 && exist(path, 'file')
    ali0 = matFld(path, 'ali0');
    prom('m', 'old ini ali (%s)\n', ini);
    return;
end
prom('m', 'new ini ali (%s)\n', ini);

% dynamic time warping
if strcmp(ini, 'dtw')
%     X1 = X1 - repmat(mean(X1, 2), 1, size(X1, 2));
%     X2 = X2 - repmat(mean(X2, 2), 1, size(X2, 2));
    ali0 = aliDtw(Xs);

% uniform alignment
else
    ali0 = aliUnif([size(Xs{1}, 2); size(Xs{2}, 2)]);
    ali0.C = ali0;
end

% store
if svL > 0
    save(path, 'ali0');
end
