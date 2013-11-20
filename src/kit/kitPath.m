function [amcpath, asfpath, avipath] = kitPath(src)
% Obtain the file paths for the given kitchen source.
%
% Input
%   src      -  kitchen source
%
% Output
%   amcpath  -  the path of amc file
%   asfpath  -  the path of asf file
%   avipath  -  the path of avi file
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

subNm = src.subNm;
trlNm = src.trlNm;
sen = src.sen;

global footpath; % specified in addPath.m
foldpath = sprintf('%s/data/kit/%s', footpath, subNm);
asfpath = sprintf('%s/%s.asf', foldpath, subNm);
amcpath = sprintf('%s/%s_%s.amc', foldpath, subNm, trlNm);
avipath = sprintf('%s/%s_%s_%s.avi', foldpath, subNm, trlNm, sen);
