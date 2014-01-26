function [Z, A, R, T] = mkprocrust(ipts, opts)
% Find similarity transformation from ipts to opts.
%
% Input
%   pts     -  tracking points, dim x 1
%   ptsref  -  reference tracking points, dim x 1
%
% Output
%   Z       -  aligned points, dim x 1
%   A       -  transformation matrix, 3 x 3
%   R       -  rotation matrix
%   T       -  translation matrix
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-10-2012

% construct input matrix
A = zeros(size(ipts, 1) * 2, 4);
A(1 : 2 : end, 1) = ipts(:, 1);      % x for ax
A(2 : 2 : end, 1) = ipts(:, 2);      % y for ay
A(1 : 2 : end, 2) = -ipts(:, 2);     % -y for -by
A(2 : 2 : end, 2) = ipts(:,1);       % x  for bx
A(1 : 2 : end, 3) = 1;               %    for tx
A(2 : 2 : end, 4) = 1;               %    for ty

% output matrix
B = zeros(size(ipts, 1) * 2, 1);
B(1 : 2 : end) = opts(:, 1);         % x'
B(2 : 2 : end) = opts(:, 2);         % y'

% solve for similarity
X = A \ B;
T = X';
a = T(1);
b = T(2);
tx = T(3);
ty = T(4);
T = [a b; -b a];

tpts = ipts * T;
A = zeros(3,3);
A(1 : 2, 1 : 2) = T';
A(1 : 2, 3) = [tx ty].';
A(3, 3) = 1;

R = T;
T = [tx ty];

% Apply translation
tpts(:, 1) = tpts(:, 1) + tx;
tpts(:, 2) = tpts(:, 2) + ty;

Z = tpts;
