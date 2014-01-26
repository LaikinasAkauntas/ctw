function [Det, Des] = imgFeatSiftF(F, Det0, parF)
% Extract SIFT feature at the specified positions.
%
% Input
%   F        -  image
%   Det0     -  specified position, 4 x n
%                 Det0(1 : 2, :): point position
%                 Det0(3, :)    : scale
%                 Det0(4, :)    : orientation
%   parF     -  feature parameter
%     ori    -  flag of using specified orientation (ie, Det0(4, :)), {'y'} | 'n'
%     dstMi  -  minimum distance threshold, {eps}
%                 At each position, there might be more than one dominated
%                 orientations. In order to keep only one of them, we can 
%                 use this parameter.
%     deb    -  flag of debugging, 'y' | {'n'}
%            
% Output
%   Det      -  detector, 4 x n
%   Des      -  descriptor, 128 x n (single)
%
% History    
%   create   -  Feng Zhou (zhfe99@gmail.com), 06-01-2012
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-16-2012

% function parameter
isOri = psY(parF, 'ori', 'y');
dstMi = ps(parF, 'dstMi', eps);
isDeb = psY(parF, 'deb', 'n');
prIn('imgFeatSiftF', 'ori %d, disMi %e', isOri, dstMi);

% rgb -> gray (single)
if size(F, 3) > 1
    F1 = rgb2gray(F);
else
    F1 = F;
end
F1 = single(F1);

% dimension
n = size(Det0, 2);

% detect SIFT at the specified orientation
if isOri
    [Det1, Des1] = vl_sift(F1, 'frames', Det0);

% detect SIFT at the optimal orientation
else
    [Det1, Des1] = vl_sift(F1, 'frames', Det0, 'orientations');
    Det1 = zeros(4, n);
    Des1 = zeros(128, n, 'uint8');
    for i = 1 : size(Det0, 2)
        [det, des] = vl_sift(F1, 'frames', Det0(:, i), 'orientations');

        % remove redudnant point
        if size(det, 2) > 1
            det = det(:, 1);
            des = des(:, 1);
        elseif size(det, 2) == 0
            fprintf('error %d\n', i);
        end

        % store
        Det1(:, i) = det;
        Des1(:, i) = des;
    end
end

% using the specified orientation
if isOri
    Det = Det1;
    Des = Des1;

% using the optimal orientation
else
    Det = Det1;
    Des = Des1;
    % remove redundant points
%     [vis, is, js, D] = rmRundPt(Det1(1 : 2, :), dstMi);
%     n1 = length(vis);
%     k = length(find(vis));
%     Det = Det1(:, ~vis);
%     Des = Des1(:, ~vis);
%     n = size(Det, 2);
%    pr('find %d SIFT points, remove %d points, finally %d', n1, k, n);
end

% debug
if isDeb
    rows = 1; cols = 5;
    Ax = iniAx(102, rows, cols, [400 * rows, 400 * cols]);
    shImg(F, 'ax', Ax{1});
    hold on;
    plot(Det0(1, :), Det0(2, :), 'ro');
    
    shImg(F, 'ax', Ax{2});
    hold on;
    plot(Det1(1, :), Det1(2, :), 'ro');
    plot(Det1(1, vis), Det1(2, vis), 'bs');

    shImg(F, 'ax', Ax{3});
    hold on;
    plot(Det1(1, :), Det1(2, :), 'ro');
    
    shImg(F, 'ax', Ax{4});
    hold on;
    vl_plotframe(Det);  
    
    shImg(F, 'ax', Ax{5});
    hold on;
    h3 = vl_plotsiftdescriptor(Des, Det);  
    set(h3, 'color', 'g');
end

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [vis, is, js, D] = rmRundPt(Det, dstMi)
% Remove points that are too close to its neighbors.
%
% Input
%   Det    -  point position, 4 x n
%   dstMi  -  minimum distance threshold
%
% Output
%   vis    -  binary indicator, 1 x n

% dimension
n = size(Det, 2);

% pairwise distance
Pt = Det(1 : 2, :);
D = conDst(Pt, Pt);
D = real(sqrt(D));
D = D + eye(n);

% index
idx = find(D(:) < dstMi);
[is, js] = ind2sub([n n], idx);
m = length(idx);

vis = zeros(1, n);
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
vis = vis == 1;
