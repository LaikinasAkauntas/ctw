function QL = logq(Q)
% Calculate the logarithm map of quaternion.
%
% Input
%   Q       -  quaternion matrix, (k x 4) x n
%
% Output
%   QL      -  logarithm map, (k x 3) x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
[k, n] = size(Q);
k = round(k / 4);
QL = zeros(3 * k, n);

for i = 1 : n
    for c = 1 : k
        q = Q((c - 1) * 4 + 1 : c * 4, i);
        alpha = acos(q(4));

        % sin(0) / 0 = 1
        if abs(alpha) < eps
            tmp = 1;
        else
            tmp = sin(alpha) / alpha;
        end

        qL = q(1 : 3) / tmp;       
        QL((c - 1) * 3 + 1 : c * 3, i) = qL;
    end
end
