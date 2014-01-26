function wsAce = hsaAce(src, varargin)
% Obtain accelerometer data of HSA source.
%
% Input
%   src      -  hsa source
%   varargin
%     save option
%
% Output
%   wsAce
%     Ln0s   -  mask points (original), 1 x nF (cell)
%     Lns    -  mask points (normalized), 1 x nF (cell)
%     siz    -  mask size (normalized), 1 x 2
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-17-2013

% save option
[svL, path] = psSv(varargin, 'subx', 'ace', ...
                             'fold', 'hsa/ace', ...
                             'prex', src.nm);

% load
if svL == 2 && exist(path, 'file')
    prInOut('old kit ace: %s', src.nm);
    wsAce = matFld(path, 'wsAce');
    return;
end
prIn('new kit ace: %s', src.nm);

% path
wsPath = hsaPaths(src);

% read
data = matFld(wsPath.ace, 'data');
X0 = data(:, 2 : 4)';

% synchronization
if strcmp(src.nm, 'feng_01')
    idxV = 1 : 1341;
    idxX = idxV;

elseif strcmp(src.nm, 'feng_02')
    idxV = 1 : 2514;
    idxX = round(idxV * 1.3333 + 900.1098);

else
    error('unknown src: %s', src.nm);
end

% store
wsAce.X0 = X0;
wsAce.X = X0(:, idxX);

% save
if svL > 0
    save(path, 'wsAce');
end

prOut;
