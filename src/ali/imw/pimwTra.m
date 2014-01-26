function [Ys, Zs] = pimwTra(Xs, ali)
% Transformation of sequence.
%
% Input
%   Xs      -  sequence, 1 x m (cell), di x ni
%   ali     -  alignment
%     Vs    -  projection, 1 x m (cell), di x d
%     P     -  warping path, l x m
%   parV    -  parameter for spatial transformation
%     lams  -  lambda for regularization, {[]}, See function mcca for more details
%   parP    -  parameter for temporal warping, See function seqInp for more details
%
% Output
%   Ys      -  sequence, 1 x m (cell), d x ni
%   Zs      -  sequence, 1 x m (cell), d x l
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 09-06-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
m = length(Xs);

% spatial transformation
if isfield(ali, 'As') && ~isempty(ali.As)
    Ys = cell(1, m);
    for i = 1 : m
        Ys{i} = Xs{i} .* ali.As{i} + ali.Bs{i};
    end
else
    Ys = Xs;
end

% temporal warping
if isfield(ali, 'P') && ~isempty(ali.P)
    Zs = seqInp(Ys, ali.P, st('inp', 'exact'));
else
    Zs = Ys;
end
