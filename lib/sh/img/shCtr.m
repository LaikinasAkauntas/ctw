function ha = shCtr(C, varargin)
% Plot contour in 2-D.
%
% Input
%   C        -  contour matrix, 2 x n
%   varargin
%     show option
%     lnWid  -  line width, {1}
%     mi     -  corner of the box, {[]}
%
% Output
%   ha
%     haBox  -  handle
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 07-10-2012
%   modify   -  Feng Zhou (zhfe99@gmail.com), 07-10-2012

% show option
psSh(varargin);

% function option
lnWid = ps(varargin, 'lnWid', 1);
lnCl = ps(varargin, 'lnCl', 'r');
mi = ps(varargin, 'mi', []);

% parse
n = size(C, 2);
i = 1;
k = 1;
Lns = cell(1, n);
vs = zeros(1, n);
while i <= n
    % store
    vs(k) = C(1, i);
    ms(k) = C(2, i);
    Lns{k} = C(:, i + 1 : i + ms(k));
    
    if ~isempty(mi)
        Lns{k} = Lns{k} - 1 + repmat(mi, 1, ms(k));
    end
    
    i = i + ms(k) + 1;
    k = k + 1;
end
k = k - 1;
Lns(k + 1 : end) = [];
vs(k + 1 : end) = [];

% plot
hold on;
haCtrs = cell(1, k);
for c = 1 : k
    xs = Lns{c}(1, :);
    ys = Lns{c}(2, :);    
    haCtrs{c} = plot(xs, ys, '-', 'linewidth', lnWid, 'color', lnCl);
end

% store
ha.haCtrs = haCtrs;
