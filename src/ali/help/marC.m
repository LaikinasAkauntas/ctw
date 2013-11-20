function C = marC(C0, varargin)
% Transform the symmetric alignment to the asymmetric alignment.
%
% Input
%   C0      -  original alignment, 2 x nC0
%   varargin
%     aprx  -  approximation method, {'mid'} | 'fst' | 'lst'
%
% Output
%   C       -  new alignment, 2 x nC
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-16-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
aprx = ps(varargin, 'aprx', 'mid');

n1 = C0(1, end);
C = zeros(2, n1);
C(1, :) = 1 : n1;

for i = 1 : n1
    p = find(C0(1, :) == i);

    % approximation method
    if strcmp(aprx, 'mid')
        t = ceil(length(p) / 2);
    elseif strcmp(aprx, 'fst')
        t = p(1);
    elseif strcmp(aprx, 'fst')
        t = p(end);
    else
        error(['unknown approximation method: ' aprx]);
    end

    C(2, i) = C0(2, p(t));
end
