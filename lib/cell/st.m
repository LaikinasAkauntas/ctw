function a = st(varargin)
% Create a struct.
%
% Example
%   input      -  a.name = 'feng';
%                 a.age = 25;
%                 a.gender = 'male'.
%   call       -  [name, age, gender] = stFld(a, 'name', 'age', 'gender')
%   output     -  name = 'feng';
%                 age = 25;
%                 gender = 'male'
%
% Input
%   varargin   -  field name list, 1 x m (cell)
%
% Output
%   a          -  struct
%
% History
%   create     -  Feng Zhou (zhfe99@gmail.com), 11-19-2010
%   modify     -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

for i = 1 : 2 : nargin
    a.(varargin{i}) = varargin{i + 1};
end
