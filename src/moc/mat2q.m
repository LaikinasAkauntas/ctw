function Q = mat2q(R)
% Convert rotation matrix to unit quaternion.
%
% Math
%   The resultant quaternion(s) will perform the equivalent vector transformation as:
%      qconj(q) * v * q = R * v
%   where R is the rotation matrix
%      v is a vector (a quaterion with a scalar element of zero)
%      q is the quaternion
%
% Input
%   R       -  rotation matrix, 3 x 3 x n
%
% Output
%   Q       -  quaternion matrix, 4 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension 
n = size(R, 3);

Q = zeros(4, n);
Q(1, :) = .5 * sqrt(1 + R(1, 1, :) - R(2, 2, :) - R(3, 3, :)) .* sgn(R(2, 3, :) - R(3, 2, :));
Q(2, :) = .5 * sqrt(1 - R(1, 1, :) + R(2, 2, :) - R(3, 3, :)) .* sgn(R(3, 1, :) - R(1, 3, :));
Q(3, :) = .5 * sqrt(1 - R(1, 1, :) - R(2, 2, :) + R(3, 3, :)) .* sgn(R(1, 2, :) - R(2, 1, :));
Q(4, :) = .5 * sqrt(1 + R(1, 1, :) + R(2, 2, :) + R(3, 3, :));
Q = real(Q);

%%%%%%%%%%%%%%%%%%%
function s = sgn(x)
% Sign of x.
% Note that sign(x) returns a vector composed by elements {-1, 0, 1}, while sgn(x) is only composed by {-1, 1}.
%
% Input
%   x  -  data, n x 1
%
% Output
%   s  -  sign, {1, -1} ^ n

s = sign(x);
s = s + (s == 0);
