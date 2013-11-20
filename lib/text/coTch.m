function [iCo, nCo, idx] = coTch(path, n, w, varargin)
% Access the count number which has been stored in the specified path.
%
% Input
%   path    -  count path
%   n       -  #total number
%   w       -  width
%   varargin
%     ord   -  order type, {'a'} | 'd' | 'r' | 'm'
%              'a': ascend
%              'd': descend
%              'r': random
%              'm': manually specified
%     idx0  -  only used when ord == 'm'
%
% Output
%   iCo     -  count index
%   nCo     -  #total count
%   idx     -  index, 1 x w
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

if ~exist(path, 'file')
    % function option
    ord = ps(varargin, 'ord', 'a');

    % all index
    if strcmp(ord, 'a')
        idx0 = 1 : n;
    elseif strcmp(ord, 'd')
        idx0 = n : -1 : 1;
    elseif strcmp(ord, 'r')
        idx0 = randperm(n);
    elseif strcmp(ord, 'm')
        idx0 = ps(varargin, 'idx0', []);
    else
        error(['unknown order: ' ord]);
    end
    
    % divide
    nCo = ceil(n / w);
    idxs = cell(1, nCo);
    for iCo = 1 : nCo
        p = w * (iCo - 1);
        wid = select(iCo == nCo, n - w * (iCo - 1), w);
        idxs{iCo} = idx0(p + 1 : p + wid);
    end
    iCo = 0;

else
    % load
    [iCo, nCo, idx0, idxs] = matFld(path, 'iCo', 'nCo', 'idx0', 'idxs');
end

% ++
iCo = iCo + 1;
if iCo > nCo
    idx = [];
    pr('done');
    return;
else
    idx = idxs{iCo};
end
   
% save
pr('co: %d/%d', iCo, nCo);
save(path, 'iCo', 'nCo', 'idx0', 'idxs');
