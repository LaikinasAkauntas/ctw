function wsPath = hsaPaths(src)
% Obtain the avi/mat file path with the given components of the path.
%
% Input
%   src     -  hsa src
%
% Output
%   wsPath
%     vdo   -  path of vdo file
%     ace   -  path of ace file
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

global footpath; % specified in addPath.m
subNm = src.subNm;
trlNm = src.trlNm;

% data folder
foldpath = sprintf('%s/data/hsa', footpath);

% video
wsPath.vdo = sprintf('%s/%s/%s_%s', foldpath, subNm, subNm, trlNm);

% ace
wsPath.ace = sprintf('%s/%s/%s_%s.mat', foldpath, subNm, subNm, trlNm);
