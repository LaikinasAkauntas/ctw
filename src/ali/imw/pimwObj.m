function [obj, Xs] = pimwObj(Xs, ali, parPimw)
% Computing the objective of pIMW.
%
% Input
%   Xs       -  sequence, 1 x m (cell), d x ni
%   ali      -  alignment
%     X      -  mean sequence, d x l
%     As     -  weight, 1 x m (cell), d x ni
%     Bs     -  weight, 1 x m (cell), d x ni
%     P      -  warping path, l x m
%   parPimw  -  parameter for pIMW
%
% Output
%   obj      -  objective
%   Xs       -  sequence, 1 x m (cell), d x t
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 09-06-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
m = length(Xs);
ns = cellDim(Xs, 2);

% spatial transformation
if isfield(ali, 'As') && ~isempty(ali.As)
    for i = 1 : m
        Xs{i} = Xs{i} .* ali.As{i} + ali.Bs{i};
    end
end

% temporal warping
if isfield(ali, 'P') && ~isempty(ali.P)
    Xs = seqInp(Xs, ali.P, st('inp', 'exact'));
end

% distance between mean sequence
obj = 0;
for i = 1 : m
    tmp = (Xs{i} - ali.X) .^ 2;
    obj = obj + sum(tmp(:));
end

% regularization
obj2 = 0;
if isfield(ali, 'As') && ~isempty(ali.As)
    
    for i = 1 : m
        FA = mgrad(ns(i)) * parPimw.lA;
        tmpA = (ali.As{i} * FA') .^ 2;

        FB = mgrad(ns(i)) * parPimw.lB;
        tmpB = (ali.Bs{i} * FB') .^ 2;

        obj2 = obj2 + sum(tmpA(:)) + sum(tmpB(:));
    end
end
obj = obj + obj2;
