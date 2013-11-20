function wsMoc = kitMocOld(src, varargin)
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
                             'subx', 'moc_old', ...
                             'fold', 'kit/moc');

% load
if svL == 2 && exist(path, 'file')
    prInOut('kitMocOld', 'old, src %s', src.nm);
    wsMoc = matFld(path, 'wsMoc');
    return;
end
prIn('kitMocOld', 'new, src %s', src.nm);

% path
[amcpath, asfpath] = kitPath(src);

% skel
skel = asf2skelOld(asfpath);

% dof
[Dof, join] = amc2dofOld(amcpath);

% coordinate
chan = dof2chanOld(skel, Dof, join);
[cord, conn] = chan2cordOld(skel, chan);

chan = permute(chan, [2 1]);
cord = permute(cord, [3 2 1]);
conn = permute(conn, [2 1]);

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
