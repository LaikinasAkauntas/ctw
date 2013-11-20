function [me, va] = seqMA(x, w, varargin)
% Compute the moving average of a sequence.
%
% Input
%   x       -  sequence, 1 x n
%   w       -  window size
%   varargin
%     shp   -  window shape, {'unif'} | 'unif2' | 'gauss'
%
% Output
%   me      -  mean, 1 x n
%   va      -  variance, 1 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 07-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
shp = ps(varargin, 'shp', 'unif');

n = length(x);
[me, va] = zeross(1, n);

if strcmp(shp, 'unif')
    for i = 1 : n
        [me(i), va(i)] = unif(x, i, w);
    end

elseif strcmp(shp, 'unif2')
    for i = 1 : n
        [me(i), va(i)] = unif2(x, i, w);
    end

elseif strcmp(shp, 'gauss')
    for i = 1 : n
        me(i) = gauss(x, i, w);
    end

else
    error('unknown kernel shape: %s', shp);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [me, va] = unif(x, i, w)
% Uniform convolution.

w1 = floor(w / 2);
w2 = w - 1 - w1;
head = max(1, i - w1);
tail = min(length(x), i + w2);
y = x(head : tail);
me = mean(y);
va = var(y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [me, va] = unif2(x, i, w)
% Uniform convolution.

head = max(1, i - w);
tail = min(length(x), i);
y = x(head : tail);
me = mean(y);
va = var(y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = gauss(x, i, w)
% Gaussian convolution.

n = length(x);
weis = exp(-((1 : n) - i) .^ 2 / (2 * ((w / 4) ^ 2)));
weis = weis / sum(weis);
a = x * weis';
