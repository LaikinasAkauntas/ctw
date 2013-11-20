function bas = baTems(l, ns, varargin)
% Generate a set of temporal basis with same setting.
%
% Input
%   l       -  #destined samples
%   ns      -  #orginial samples, 1 x m
%   varargin
%
% Output
%   bas     -  basis set, 1 x m (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-18-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
m = length(ns);

bas = cell(1, m);
for i = 1 : m
    bas{i} = baTem(l, ns(i), varargin{:});
end
