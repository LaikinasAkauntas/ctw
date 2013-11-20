function List = kitList(act, varargin)
% Obtain list of kitchen sequences.
%
% Input
%   act     -  act name, 'open_cabinet'
%   varargin
%     ran   -  flag of using range, {'y'} | 'n'
%
% Output
%   List    -  list of sequences, n x 4
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 09-02-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

% function option
isRan = psY(varargin, 'ran', 'y');

% open cabinet (upper)
if strcmp(act, 'cabinet')
    List = {1, 'brownies', 'normal', [468 1246]; ...
            3, 'brownies', 'normal', [442 1272]};

else
    error(['unknown act: ' act]);
end

% remove range
if ~isRan
    for i = 1 : size(List, 1)
        List{i, 4} = [];
    end
end
