function wsPath = weiPath(src)
% Obtain the avi/mat file path for Weizmann source.
%
% Input
%   src     -  wei src
%
% Output
%   wsPath
%     vdo   -  path of vdo file
%     meSg  -  path of global mean shape
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% specified in addPath.m
global footpath; 
subNm = src.subNm;
trlNm = src.trlNm;

% data folder
foldpath = sprintf('%s/data/wei', footpath);

% global mean shape
wsPath.meSG = sprintf('%s/mean.mat', foldpath);

% avi
wsPath.vdo = sprintf('%s/%s/%s_%s.avi', foldpath, trlNm, subNm, trlNm);
