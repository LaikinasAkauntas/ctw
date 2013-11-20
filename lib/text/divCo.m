function idxs = divCo(n, m)
% Access the count number which has been stored in the specified path.
%
% Input
%   n       -  #total number
%   m       -  #parts
%
% Output
%   idx     -  index, 1 x m (cell), 1 x ni
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-21-2012

% divide
ni = floor(n / m);
idxs = cell(1, m);
for i = 1 : m
    if i < m
        idxs{i} = (i - 1) * ni + 1 : i * ni;
    else
        idxs{i} = (i - 1) * ni + 1 : n;
    end
end
