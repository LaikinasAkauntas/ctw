function P = aliInv(Qs)
% Obtain the inverse alignment.
%
% Input
%   Qs      -  original warping path vector, 1 x m (cell), ni x 1
%
% Output
%   P       -  inverse warping path, l x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 09-13-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-02-2012

% dimension
m = length(Qs);
ns = cellDim(Qs, 1);

% check t
t = Qs{1}(end);
for i = 2 : m
    if t ~= Qs{i}(end)
        error('t must be the same');
    end
end

% compute
P = zeros(t, m);
for j = 1 : m
    q = round(Qs{j});
    n = ns(j);

    P(1, j) = 1;
    P(q, j) = 1 : n;
    
    vis = real(P(:, j) ~= 0);
    
    head = vis(2 : end) - vis(1 : end - 1);
    head = find(head < 0) + 1;

    tail = vis(2 : end) - vis(1 : end - 1);
    tail = find(tail > 0);
    
    for ii = 1 : length(head)
        h = head(ii) - 1;
        t = tail(ii) + 1;
        P(h : t, j) = round(linspace(P(h, j), P(t, j), t - h + 1));
    end
end
