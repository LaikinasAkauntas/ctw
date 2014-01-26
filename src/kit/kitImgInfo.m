function kitImgInfo(src, idx)
% Write image for each frame in video.
%
% Input
%   vdopath  -  video path
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% vdo
vdopath = kitPaths(src);
hr = vReader(vdopath, 'comp', 'vdo');
[siz, fps] = stFld(hr, 'siz', 'fps');

% fold
foldpath = vdopath(1 : end - 4);
if ~isdir(foldpath)
    mkdir(foldpath);
end

% image
nF = length(idx);

% form
pathform = '%s/%.6d.jpeg';

% save info
infopath = sprintf('%s/info.mat', foldpath);
save(infopath, 'nF', 'siz', 'fps', 'pathform', 'idx');
