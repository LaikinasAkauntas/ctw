function wsVdo = weiVdo(src, varargin)
% Obtain video sequence of Weizmann source.
%
% Input
%   src     -  wei src
%   varargin
%     save option
%     pFs   -  frame index of sub-sequence, {[]} | 1 x nF
%
% Output
%   wsVdo
%     Fs    -  frame matrix, 1 x nF (cell)
%     siz   -  size of image, 1 x 2
%     nF    -  #frames
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% save option
[svL, path] = psSv(varargin, 'fold', 'wei/vdo', ...
                             'prex', src.nm, ...
                             'subx', 'vdo');

% load
if svL == 2 && exist(path, 'file')
    prInOut('weiVdo', 'old, %s', src.nm);
    wsVdo = matFld(path, 'wsVdo');
    return;
end
prIn('weiVdo', 'new, %s', src.nm);

% path
wsPath = weiPath(src);

% video
Fs = vdoFAll(wsPath.vdo, 'comp', 'vdo');

% size
nF = length(Fs);
siz = imgInfo(Fs{1});

% flip image
if strcmp(src.dire, 'l')
    for iF = 1 : nF
        Fs{iF} = Fs{iF}(:, end : -1 : 1, :);
    end
end

% store
wsVdo.Fs = Fs;
wsVdo.nF = nF;
wsVdo.siz = siz;
wsVdo.form = 'uint8';
wsVdo.cl = 'rgb';
wsVdo.comp = 'mat';

% save
if svL > 0
    save(path, 'wsVdo');
end
 
prOut;
      
