function [Det, Des] = imgFeatSift(F0, parF)
% Obtain SIFT feature.
%
% Input
%   F0       -  original image
%   parF     -  feature parameter
%     pk     -  peak threshold, {3}
%     eg     -  edge threshold, {10}
%     dstMi  -  minimum distance threshold, {3}
%               At each position, there might be more than one dominated
%               orientations. In order to keep only one of them, we can 
%               use this parameter.
%     deb    -  flag of debugging, 'y' | {'n'}
%            
% Output     
%   Reg      -  detector, dR (= 5) x n
%   Des      -  descriptor, dF (= 128) x n
%
% History    
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-30-2011
%   modify   -  Feng Zhou (zhfe99@gmail.com), 01-18-2012

% function parameter
pk = ps(parF, 'pk', 3);
eg = ps(parF, 'eg', 10);
dstMi = ps(parF, 'dstMi', 3);
isDeb = psY(parF, 'deb', 'n');
prIn('imgFeatSift', 'pk %.0f, eg %.0f, disMi %d', pk, eg, dstMi);

% rgb -> gray (single)
if size(F0, 3) > 1
    F1 = rgb2gray(F0);
else
    F1 = F0;
end
F2 = single(F1);

% run sift
[Det0, Des0] = vl_sift(F2, 'PeakThresh', pk, 'EdgeThresh', eg);
Des0 = double(Des0);

% remove redundant points
n0 = size(Det0, 2);
Pt0 = Det0(1 : 2, :);
D = conDst(Pt0, Pt0);
D = real(sqrt(D));
idx = find(D(:) < dstMi);
[is, js] = ind2sub([n0 n0], idx);
m = length(idx);

vis = zeros(1, n0);
for c = 1 : m
    i = is(c);
    j = js(c);
    
    if i >= j
        continue;
    end
    
    if vis(i)
        continue;
    end
    
    if vis(j)
        %error('unknown poisition');
        continue;
    end
    
    vis(j) = 1;
end
k = length(find(vis));
vis = vis == 1;

Det = Det0(:, ~vis);
Des = Des0(:, ~vis);
n = size(Det, 2);
pr('find %d SIFT points, remove %d points, finally %d', n0, k, n);

% debug
if isDeb
    rows = 1; cols = 2;
    Ax = iniAx(102, rows, cols, [400 * rows, 400 * cols]);
    shImg(F0, 'ax', Ax{1});
    hold on;
    plot(Det0(1, :), Det0(2, :), 'ro');
    plot(Det0(1, vis), Det0(2, vis), 'bs');

    shImg(F0, 'ax', Ax{2});
    hold on;
    plot(Det(1, :), Det(2, :), 'ro');
end

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%
