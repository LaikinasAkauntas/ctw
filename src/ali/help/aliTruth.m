function P = aliTruth(q1, q2)
% Obtain the ground truth alignment.
%
% Input
%   q1      -  1st warping path vector, n1 x 1
%   q2      -  2nd warping path vector, n2 x 2
%
% Output
%   P       -  ground-truth warping, t x 2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-17-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

n1 = length(q1);
n2 = length(q2);
t = max(q1);

if t ~= max(q2)
    error('n0 must be equal');
end

i1 = 1; i2 = 1;
head = [1 1];
P = head;
while i1 <= n1 && i2 <= n2
    if q1(i1) == q2(i2)
        tmp = unif(head, [i1, i2]);
        if size(tmp.P, 1) > 1
            P = [P; tmp.P(2 : end, :)];
        end
        
        head = [i1, i2];
        i1 = i1 + 1;
        i2 = i2 + 1;

    elseif q1(i1) > q2(i2)
        i2 = i2 + 1;
    else
        i1 = i1 + 1;
    end
end

figure(1); clf;
subplot(2, 2, 1);
plot(1 : n1, q1, '-or');
axis equal;
axis([1 n1 1 t]);
subplot(2, 2, 2);
plot(1 : size(P, 1), P(:, 1), '-or');
axis equal;
axis([1 size(P, 1) 1 P(end, 1)]);

subplot(2, 2, 3);
plot(1 : n2, q2, '-or');
axis equal;
axis([1 n2 1 t]);
subplot(2, 2, 4);
plot(1 : size(P, 1), P(:, 2), '-or');
axis equal;
axis([1 size(P, 1) 1 P(end, 2)]);

size(P)
