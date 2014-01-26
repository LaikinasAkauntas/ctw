function [amcpath, asfpath, txtpath] = cmuPath(src)
% Obtain file paths for the given CMU mocap source.
%
% Input
%   src      -  cmu source
%
% Output
%   amcpath  -  the path of amc file
%   asfpath  -  the path of asf file
%   txtpath  -  the path of txt file
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

subNm = src.subNm;
trlNm = src.trlNm;

global footpath; % specified in addPath.m

path = sprintf('%s/data/cmu/%s/%s', footpath, subNm, subNm);
amcpath = [path '_' trlNm '.amc'];
asfpath = [path '.asf'];
txtpath = [path '_' trlNm '.txt'];
