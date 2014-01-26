function [cleanFeat, nCleanFeat] = purifyFeat(dupFeat, nDupFeat)
% Purifies duplicated features to clean features by removing
% redundancy.
%
% Input
%   dupFeat
%   nDupFeat
%
% Output
%   cleanFeat
%   nCleanFeat
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-30-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 12-30-2011

lastFeat = zeros(1, size(dupFeat, 2));
nCleanFeat = 0;

for i = 1 : nDupFeat
    curFeat = dupFeat(i, :);
    if all(lastFeat == curFeat)
        continue;
    end
    
    nCleanFeat = nCleanFeat + 1;
    cleanFeat(nCleanFeat, :) = curFeat;
    lastFeat = curFeat;
end