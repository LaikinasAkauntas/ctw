function sift = gensiftdesc(ptch, S)
% GENSIFTDESC - Generate the sift descriptors on patches
%
% desc = GENSIFTDESC(P,S) generates a n x d feature vector
%    S is a 2 elements vector: S is the horizontal and vertical number of
%    subpatches. Sift is simply the histogram of the angles in these subpatches
%
% example (with image toolbox)
% -------
% load clown
% imshow(X);
% L=50;
% a=imcrop(X);a=imresize(a,[L L]);
% clf;imshow(a);s=gensiftdesc(a);siftplot(s*5,[1 1 L-1 L-1])
%
% example (without image toolbox)
% -------
% load clown
% imshow2(X)
% L = 50;
% [x, y] = ginput(1); a = imcrop2(X,[x-L/2 y-L/2 L L]);
% clf;imshow(a);s=gensiftdesc(a);siftplot(s*5,[1 1 L-1 L-1])

if nargin < 2
    S = 4;
end

if isinteger(ptch)
    ptch = double(ptch) ./ 255;
end

if size(ptch, 3) > 1
    ptch = rgb2gray(ptch);
end

sz = size(ptch);
if sz(1) ~= sz(2)
    error('patches must be square')
end

width = sz(1) - 2;
sigma2 = 3 * width / 16; % so that the sum of the weights is a smoothed 2D function

delta = width / (S + 1);
[cy, cx] = meshgrid((1 : S) * delta, (1 : S) * delta);
%wc = exp(-.5/... %weightind the centers
[xp, yp] = meshgrid(1 : width, 1 : width);
np = length(xp(:));

e2 = ones(1, S .^ 2);
e1 = ones(np, 1);
w = exp(-.5 / sigma2 * ((xp(:) * e2 - e1 * cx(:)') .^ 2 +(yp(:) * e2 -e1 * cy(:)') .^ 2));

n = size(ptch,max(3,length(sz)));
ip = reshape(ptch,[sz(1),sz(2)*n]);

diffy = [1 1 1; 0 0 0; -1 -1 -1]; % approxiamtion of the derivative
Ix = reshape(conv2(ip, diffy', 'same'), [sz, n]);
Iy = reshape(conv2(ip, diffy, 'same'), [sz, n]);
Ix = Ix(2 : end - 1, 2 : end - 1, :);
Iy = Iy(2 : end - 1, 2 : end - 1, :);

nbins = 8;
sh = 0;
cossin = [cos(2 * pi / nbins * ((nbins : -1 : 1) + sh)') sin(2 * pi / nbins * ((nbins : -1 : 1) + sh)')];
B = reshape([Ix(:) Iy(:)] * cossin', n * np, nbins);
sift = reshape(w' * max(B, 0), S .^ 2, nbins, n);
sift = reshape(permute(sift,[2 1 3]),S.^2*nbins,n);

%sift = sift/sum(sift);
sift = sift / sqrt(sum(sift.^2)); % modified by Minsu Cho
