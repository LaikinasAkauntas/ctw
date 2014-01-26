function v = multTr(varargin)
% Trace of multiplication of several matrix. 
%
% Input
%   varargin  -  input matrix, 1 x n (cell)
%
% Output
%   v         -  value
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 03-10-2011
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

A = varargin{1};
for i = 2 : nargin
    A = A .* varargin{i};
end
v = sum(A(:));
