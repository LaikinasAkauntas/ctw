function R = ang2mat(ang, order)
% Convert Euler angles to a rotation matrix.
%
% Input
%   ang     -  angle vector that contains x y z components (in degree), 3 x 1
%   order   -  rotating order (optional), {'zyx'}
%
% Output
%   R       -  rotation matrix, 3 x 3
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-17-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% default order
if nargin == 1
    order = 'zyx';
end

ang = ang / 180 * pi;

% x angle
cX = cos(ang(1));
sX = sin(ang(1));

% y angle
cY = cos(ang(2));
sY = sin(ang(2));

% z angle
cZ = cos(ang(3));
sZ = sin(ang(3));

% matrix
R = eye(3);
for i = 1 : length(order)
    if order(i) == 'x'
        Ri = [1   0   0; ...
              0  cX  sX; ...
              0 -sX  cX];

    elseif order(i) == 'y'
        Ri = [cY  0 -sY; ...
               0  1   0; ...
              sY  0  cY];

    elseif order(i) == 'z'
        Ri = [cZ  sZ  0; ...
             -sZ  cZ  0; ...
               0   0  1];
    else
        error('unknown order %s', order(i));
    end

    R = Ri * R;
end
