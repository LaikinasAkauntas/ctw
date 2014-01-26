function [Det, Des] = imgFeat(wsPath, parF)
% Get image feature detector and descriptor.
%
% Input
%   wsPath
%     img   -  path of image file
%   parF    -  parameter
%     alg   -  {'sift'} | 'mser' | 'mbp'
%    
% Output    
%   Det     -  detector, dDet x n
%   Des     -  descriptor, dDes x n
%           
% History   
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-30-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 01-16-2012

% function parameter
alg = ps(parF, 'alg', 'sift');
prIn('imgFeat', 'alg %s', alg);

if strcmp(alg, 'sift')
    [Det, Des] = imgFeatSift(wsPath, parF);
    
elseif strcmp(alg, 'mser')
    [Det, Des] = imgFeatMser(wsPath, parF);
    
elseif strcmp(alg, 'mbp')
    [Det, Des] = imgFeatMbp(wsPath, parF);
    
else
    error('unknown image feature: %s', alg);
end

prOut;