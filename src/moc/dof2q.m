function [Q, R] = dof2q(Dof)
% Convert degree of freedom (DOF) into quaternion.
%
% Input
%   Dof     -  DOF matrix, (k x 3) x n
%
% Output
%   Q       -  quaternion matrix, (k x 4) x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
[k, n] = size(Dof);
k = round(k / 3);

% dof -> rotation matrix
R = zeros(3, 3, n, k);
for c = 1 : k
    for i = 1 : n
        dof = Dof((c - 1) * 3 + 1 : c * 3, i);
        R(:, :, i, c) = ang2mat(dof);
    end
end

% rotation matrix -> quaternion
Q = zeros(k * 4, n);
for c = 1 : k
    Q((c - 1) * 4 + 1 : c * 4, :) = mat2q(R(:, :, :, c));
end
