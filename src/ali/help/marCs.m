function Cs = marCs(C0s, varargin)
% Transform the symmetric alignment to the asymmetric alignment.
%
% Input
%   C0s     -  set of original alignment, m1 x m2 (cell), 2 x nC0
%
% Output
%   Cs      -  set of new alignment, m1 x m2 (cell), 2 x nC
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-22-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

[m1, m2] = size(C0s);
Cs = cell(m1, m2);

for i1 = 1 : m1
    for i2 = 1 : m2
        Cs{i1, i2} = marC(C0s{i1, i2}, varargin{:});
    end
end
