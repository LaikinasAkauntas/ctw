function wsMoc = kitMoc(src, varargin)
% Obtain motion capture data for Kitchen source.
%
% Input
%   src     -  kit src
%   varargin
%     save option
%
% Output
%   wsMoc
%     Dof   -  Dof Matrix, dim x nF
%     join  -  joints related to DOFs
%     skel  -  skel struct for animation
%     cord  -  cordinates for animation, 3 x nJ x nF
%     conn  -  connection of joints
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

% save option
[svL, path] = psSv(varargin, 'prex', src.nm, ...
                             'subx', 'moc', ...
                             'fold', 'kit/moc');

% load
if svL == 2 && exist(path, 'file')
    prInOut('kitMoc', 'old, src %s', src.nm);
    wsMoc = matFld(path, 'wsMoc');
    return;
end
prIn('kitMoc', 'new, src %s', src.nm);

% path
[amcpath, asfpath] = kitPath(src);

% skel
skel = asf2skel(asfpath);

% dof
[Dof, join] = amc2dof(amcpath);

% coordinate
chan = dof2chan(skel, Dof, join);
[cord, conn] = chan2cord(skel, chan);

% store
wsMoc = st('Dof', Dof, ...
           'join', join, ...
           'skel', skel, ...
           'cord', cord, ...
           'conn', conn, ...
           'chan', chan);
% save
if svL > 0
    save(path, 'wsMoc');
end

prOut;
