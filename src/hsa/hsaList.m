function List = hsaList(act, varargin)
% Obtain list of Humansensing Accelerometer sequences.
%
% Input
%   act     -  act name, 'wave'
%   varargin
%     ran   -  flag of using range, {'y'} | 'n'
%
% Output
%   List    -  list of sequences, n x 4
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-10-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-05-2013

% function option
isRan = psY(varargin, 'ran', 'y');

% walk
if strcmp(act, 'wave')
%     List = {'feng', '01', 'normal', [856 1222]};
    List = {'feng', '02', 'normal', [858 934]; ... % 1-cycle
            'feng', '02', 'normal', [1075 1201]};  % 2-cycle

else
    error('unknown act: %s', act);
end

% remove range
if ~isRan
    for i = 1 : size(List, 1)
        List{i, 4} = [];
    end
end
