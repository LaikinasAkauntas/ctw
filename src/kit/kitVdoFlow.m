function wsFlow = kitVdoFlow(src, par, varargin)
% Obtain the flow data from Kitchen video.
%
% Input
%   src     -  kit source
%   par     -  flow parameter
%   varargin
%     save option
%
% Output
%   wsFlow
%     PtCs  -  contour points, 1 x nF (cell)
%     MBs   -  binary box, 1 x nF (cell)
%     MEs   -  Euclidean distance transform, 1 x nF (cell)
%     MPs   -  Possion distance transform, 1 x nF (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

prIn(1);

% save option
[svL, path] = psSv(varargin, 'subx', 'flow', ...
                             'fold', 'kit/vdo', ...
                             'prex', src.nm);

% load
if svL == 2 && exist(path, 'file')
    pr('old kit vdo flow: %s', src.nm);
    wsFlow = matFld(path, 'wsFlow');
    prIn(0);
    return;
end
pr('new kit vdo flow: %s', src.nm);

% path
[~, ~, avipath] = kitPaths(src);

% open avi
hr = vReader(avipath, 'cl', 'gray', 'comp', 'img', 'form', 'double');
hr.nF = ps(varargin, 'nF', hr.nF);

% flow
[areas, VHs, VIs, VJs] = vdoFlow(hr, par);

% store
wsFlow.areas = areas;
wsFlow.VHs = VHs;
wsFlow.VIs = VIs;
wsFlow.VJs = VJs;

% save
if svL > 0
    save(path, 'wsFlow');
end

prIn(0);
