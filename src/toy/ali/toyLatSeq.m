function X = toyLatSeq(shp, n)
% Generate latent sequence.
%
% Input
%   shp     -  sequence shape
%              1: sin
%              2: circle
%              3: spiral
%              4: random curve
%   n       -  #frames
%
% Output
%   X       -  sequence, 2 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-17-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-03-2012

% sin
if shp == 1
    x = linspace(0, 10, n);
    y = sin(x);

% circle
elseif shp == 2
    ang = linspace(0, 2 * pi, n);
    x = cos(ang);
    y = sin(ang);

% spiral
elseif shp == 3
% old
%     t = 4 * pi * (1 : n) / n;
%     t = 4 * pi * (1 : n) / n;
%     a = ((1 : n) - 1) / (n - 1) * (exp(1) - 1) + 1;
%     b = log(a) * (n - 1) + 1;

    a = ((1 : n) - 1) / (n - 1);
    b = a .^ (1 / 2) * (n - 1) + 1;
    t = 4 * pi * b / n;

    x = t .* cos(t);
    y = t .* sin(t);

% spiral 2
elseif shp == 5
% old
%     t = 4 * pi * (1 : n) / n;
%     t = 4 * pi * (1 : n) / n;
%     a = ((1 : n) - 1) / (n - 1) * (exp(1) - 1) + 1;
%     b = log(a) * (n - 1) + 1;

    a = ((1 : n) - 1) / (n - 1);
    b = a .^ (1 / 2) * (n - 1) + 1;
    t = 4 * pi * b / n;

    x = .8 * t .* cos(1.5 * t);
    y = .8 * t .* sin(1.5 * t);

% spiral 3
elseif shp == 6
% old
%     t = 4 * pi * (1 : n) / n;
%     t = 4 * pi * (1 : n) / n;
%     a = ((1 : n) - 1) / (n - 1) * (exp(1) - 1) + 1;
%     b = log(a) * (n - 1) + 1;

    a = ((1 : n) - 1) / (n - 1);
    b = a .^ (1 / 2) * (n - 1) + 1;
    t = 2 * pi * b / n;

    x = .8 * t .* cos(t);
    y = .8 * t .* sin(t);

% random curve
elseif shp == 4
    wei = .7;
    DX = randn(2, n);

    X = zeros(2, n);
    dx0 = [0; 0];
    for i = 2 : n
        X(:, i) = X(:, i - 1) + dx0 * wei + (1 - wei) * DX(:, i);
        dx0 = X(:, i) - X(:, i - 1);
    end
    x = X(1, :);
    y = X(2, :);

% random curve
elseif shp == 8

    % knot
    m = 8;
    ts = linspace(0, 10, m);
    xs = rand(1, m) * 2 - 1; xs(1) = 0; xs(end) = 0;
    ys = rand(1, m) * 2 - 1; ys(1) = 0; ys(end) = 0;
    
    % spline
    t = linspace(0, 10, n);
    x = spline(ts, xs, t);
    y = spline(ts, ys, t);

    X = [x; y];

else
    error('unknown shape: %d', shp);
end

X = [x; y];
