function Fs = hsaFrs(src, varargin)
% Obtain frames from Humansensing Accelerometer source.
%
% Input
%   src     -  hsa src
%   varargin
%     save option
%
% Output
%   Fs      -  frame matrix, h x w x 3 x nF (uint8)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 11-27-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-04-2013

prIn(1);

% save option
[svL, path] = psSv(varargin, 'fold', 'hsa/frs', ...
                             'prex', src.nm, ...
                             'subx', 'frs');

% load
if svL == 2 && exist(path, 'file')
    pr('old hsa frs: src %s', src.nm);
    Fs = matFld(path, 'Fs');
    prIn(0);
    return;
end
pr('new hsa frs: src %s', src.nm);

% avipath
wsPath = hsaPaths(src);

% read avi
Fs = vdoFAll(wsPath.avi, src);

% flip
if strcmp(src.dire, 'l')
    Fs(:, :, :, :) = Fs(:, end : -1 : 1, :, :);
end

% save
if svL > 0
    save(path, 'Fs');
end
