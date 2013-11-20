function [P, sig] = baTemAlg(alg, t, n, par)
% Generating temporal basis.
%
% Input
%   alg     -  algorithm, 'stp' | 'pol' | 'exp' | 'log' | 'tan' | 'spl' | 'tra'
%   t       -  #latent samples
%   n       -  #observed samples
%   par     -  parameter
%              par(1): #basis
%                      relative position for tra basis
%              par(2): only used in tan and spline basis
%
% Output
%   P       -  basis, t x k
%   sig     -  sign of basis, 1 x k
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-26-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% step basis
if strcmp(alg, 'stp')
    P = baTemStp(t, n, par);
    sig = ones(1, size(P, 2));

% poly basis
elseif strcmp(alg, 'pol')
    P = baTemPol(t, n, par(1), par(2));
    sig = ones(1, size(P, 2));

% exp basis
elseif strcmp(alg, 'exp')
    P = baTemExp(t, n, par);
    sig = ones(1, size(P, 2));

% log basis
elseif strcmp(alg, 'log')
    P = baTemLog(t, n, par);
    sig = ones(1, size(P, 2));

% tanh basis
elseif strcmp(alg, 'tan')
    P = baTemTan(t, n, par(1), par(2), par(3));
    sig = ones(1, size(P, 2));

% spline basis
elseif strcmp(alg, 'spl')
    P = baTemSpl(t, n, par(1), par(2));
    sig = ones(1, size(P, 2));

% translation basis
elseif strcmp(alg, 'tra')
    P = ones(t, 1) * par(1);
    sig = 0;

else
    error(['unknown algorithm: ' alg]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function P = baTemStp(t, n, k)
% Genernate temporal transformation basis (step function).
%
% Input
%   t  -  #latent samples
%   n  -  #observed samples
%   k  -  #basis
%
% Output
%   P  -  basis, n0 x k

P0 = tril(ones(t, t - 1), -1) * n;

idx = linspace(1, t - 1, k);
P = P0(:, round(idx));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [P, weis, x] = baTemPol(t, n, k, k2)
% Genernate temporal transformation basis (polynominal-based).
%
% Input
%   t  -  #latent samples
%   n  -  #observed samples
%   k  -  #basis
%
% Output
%   P  -  basis, n0 x k

x = ((1 : t) - 1) / (t - 1);
x = x';

if k == 1
    weis = 1;
else
    weis = logspace(-k2, k2, k);
end

P = zeros(t, k);
for i = 1 : k
    P(:, i) = x .^ weis(i);
end

x = x * (t - 1) + 1;
P = P * (n - 1) + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [P, weis] = baTemExp(n0, n, k)
% Genernate temporal transformation basis (expontinal-based).
%
% Input
%   n0      -  #samples (orginial)
%   n       -  #samples (destined)
%   k       -  #basis
%
% Output
%   P       -  basis, n0 x b

x = ((1 : n0) - 1) / (n0 - 1);
x = x';

% weis = linspace(0, 2, k);
weis = logspace(-1, 1, k);

P = zeros(n0, k);
for i = 1 : k
    P(:, i) = exp(weis(i) * x);
end

P = P * (n - 1) + 1;

for c = 1 : size(P, 2)
    mi = min(P(:, c));
    ma = max(P(:, c));
    P(:, c) = (P(:, c) - mi) / (ma - mi) * (n - 1) + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function P = baTemLog(n0, n, k)
% Genernate temporal transformation basis (logarithm-based).
%
% Input
%   t  -  #latent samples
%   n  -  #observed samples
%   k  -  #basis
%
% Output
%   P  -  basis, t x k

weis = logspace(.1, 10, k);

P = zeros(n0, k);
for i = 1 : k
    x = ((1 : n0) - 1) / (n0 - 1) * (weis(i) - 1) + 1;
    x = x';
    P(:, i) = log(x) / log(weis(i));
end

P = P * (n - 1) + 1;

for c = 1 : size(P, 2)
    mi = min(P(:, c));
    ma = max(P(:, c));
    P(:, c) = (P(:, c) - mi) / (ma - mi) * (n - 1) + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function P = baTemTan(t, n, k, a, b)
% Genernate temporal transformation basis (tanh-based).
%
% Input
%   t  -  #latent samples
%   n  -  #observed samples
%   k  -  #basis
%   a  -  parameter a
%   b  -  parameter b
%
% Output
%   P  -  basis, t x k

x = linspace(-3, 3, t);
bs = linspace(-b, b, k);

P = zeros(t, k);
for c = 1 : k
    P(:, c) = tanh((a * (x - bs(c))));
end

for c = 1 : size(P, 2)
    mi = min(P(:, c));
    ma = max(P(:, c));
    P(:, c) = (P(:, c) - mi) / (ma - mi) * (n - 1) + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function P = baTemSpl(n0, n, b, k)
% Genernate temporal transformation basis (spline-based).
%
% Input
%   n0      -  #samples (orginial)
%   n       -  #samples (destined)
%   b       -  #basis
%   k       -  order of spline
%
% Output
%   P       -  basis, n0 x b

x = ((1 : n0) - 1) / (n0 - 1);
x = x';
x(end) = x(end) - 10e-6;

knots = linspace(0, 1, b + 2);
knots([1 end]) = [];

P = ispl(x, knots, k);

P = P * (n - 1) + 1;

