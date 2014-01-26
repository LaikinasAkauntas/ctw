function wsFeat = cmuMocFeat(src, wsMoc, parF, varargin)
% Obtain feature from the CMU mocap source.
%
% Input
%   src      -  CMU src
%   wsMoc    -  mocap data
%   parF     -  feature parameter
%     setNm  -  joint set name, 'barbic' | 'leg' | 'hand' | ...
%               see function joinSet for more details
%   varargin
%     save option
%
% Output
%   wsFeat
%     setNm  -  joint set name
%     nmFs   -  all selected joint names, 1 x nJF (cell)
%     XQ     -  joint's quaternion, dimQ x nF
%     XP     -  joint's coordinate, dimP x nF
%     CordF  -  coordinate after filtering, 3 x nJF x nF
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

% feature parameter
setNm = parF.setNm;

% save option
prex = sprintf('%s_%s', src.nm, setNm);
[svL, path] = psSv(varargin, ...
                   'prex', prex, ...
                   'subx', 'feat', ...
                   'fold', 'cmu/feat');

% load
if svL == 2 && exist(path, 'file')
    prInOut('cmuMocFeat', 'old, src %s, setNm %s', src.nm, setNm);
    wsFeat = matFld(path, 'wsFeat');
    return;
end
prIn('cmuMocFeat', 'new, src %s, setNm %s', src.nm, setNm);

% joint set
nmFs = joinSet(setNm);
nJF = length(nmFs);

% obtain the DOF for the selected joints
DofF = dofFilt(wsMoc.Dof, wsMoc.join, nmFs);

% logarithm map of quaternion
XQ = logq(dof2q(DofF));

% obtain the coordinate for the selected joints
CordF = cordFilt(wsMoc.cord, wsMoc.skel, nmFs);

% relative to the root
CordF2 = CordF - repmat(wsMoc.cord(:, 1, :), [1, nJF, 1]);
XP = reshape(CordF2, [], size(CordF2, 3));

% store
wsFeat.setNm = setNm;
wsFeat.nmFs = nmFs;
wsFeat.XQ = XQ;
wsFeat.CordF = CordF;
wsFeat.XP = XP;

% save
if svL > 0
    save(path, 'wsFeat');
end

prOut;
