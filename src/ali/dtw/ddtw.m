function ali = ddtw(Xs, aliT, parDtw)
% Derivative Dynamic Time Warping (DDTW). 
%
% Reference
%   Derivative Dynamic Time Warping, SDM, 2001
%
% Input
%   Xs      -  original sequences, 1 x 2 (cell)
%   aliT    -  ground-truth alignment (can be [])
%   parDtw  -  parameter, see function dtw for more details
%
% Output
%   ali     -  alignment
%     Ys    -  new sequences (derivative), 1 x 2 (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-16-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-12-2013

% derivative
Ys = cell(1, 2);
for i = 1 : 2
    Ys{i} = gradient(Xs{i});
%     Z = Xs{i} * lapl(size(Xs{i}, 2), 'gradient');
%     equal('Z', Z, Ys{i});
end

% dynamic time warping
ali = dtw(Ys, aliT, parDtw);

% store
ali.alg = 'ddtw';
ali.Ys = Ys;
