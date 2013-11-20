function [X0s, Xs] = cmuAliDataX(wsData, idx, types)
% Obtain mocap data for alignment.
%
% Input
%   wsSrc   -  moc src
%   varargin
%     save option
%
% Output
%   wsData
%     pFss  -  frame index, 1 x m (cell), 1 x nF
%     Xs    -  feature matrix, 1 x m (cell), dim x nF
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-22-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% feature
[X0s, Xs] = cellss(1, 2);
for i = 1 : 2
    X0s{i} = wsData.XQs{idx(i)};

    if strcmp(types{i}, 'XQ')
        Xs{i} = wsData.XQs{idx(i)};
    else
        Xs{i} = wsData.XPs{idx(i)};
    end
    
end
