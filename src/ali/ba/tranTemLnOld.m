function T = tranTempo(n0, hy)
% Generate parameter of temporal transformation.
%
% Input
%   n0      -  #samples
%   hy      -  hyper-parameter
%     Ran   -  range of scaling, 2 x m
%     lens  -  lengths after scaling, 1 x m
%     wins  -  window length for smoothing, 1 x m
%
% Output
%   T       -  matrix of temporal transformation, n0 x n
%   fT      -  function of temporal transformation, n0 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-05-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% parameter
[m, Ran, lens, wins] = stFld(hy, 'm', 'Ran', 'lens', 'wins');

m = size(Ran, 2);
Ts = cell(1, m * 2 + 1);
p0 = 0;
for i = 1 : m
    len = lens(i); win = wins(i);

    % position
    p1 = round(Ran(1, i) * n0);
    p2 = round(Ran(2, i) * n0);

    % length
    len = round(len * n0);
    win = round(win * n0);
    win2 = round((win - 1) / 2);

    % unchanged part
    T = zeros(n0, p1 - p0 - 1);
    T(p0 + 1 : p1 - 1, 1 : end) = eye(p1 - p0 - 1);
    Ts{i * 2 - 1} = T;

    % changed part
    T = zeros(n0, len);

    % sampling
    pos = linspace(p1, p2, len);
    dpos = -win2 : win2; dpos = dpos';
    for j = 1 : len
        me = round(pos(j));
        x = dpos + me;

        % removing unaccessible parts
        x(x <= 0) = [];
        x(x > n0) = [];

        % discrete gaussian kernel
        y = gaussDis(x, pos(j));
        T(x(1) : x(end), j) = y;
    end
    Ts{i * 2} = T;

    p0 = p2;
end

% last unchanged part
p1 = n0;
T = zeros(n0, p1 - p0 - 1);
T(p0 + 1 : p1 - 1, 1 : end) = eye(p1 - p0 - 1);
Ts{m * 2 + 1} = T;

T = cat(2, Ts{:});

% new sequence


