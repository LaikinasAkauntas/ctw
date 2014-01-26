function angle = dominant_orientation(img, nMaxOri)

if size(img, 3) > 1
    img = rgb2gray(img);
end

if isinteger(img)
    img = double(img) ./ 255;
end

if nargin < 2
    nMaxOri = 1;
end

n_suppress = 2;
[imgMag, imgDir] = gradmag(img, 1);
bin_nb = 90;
his = zeros(1, bin_nb);
imgDir = floor((bin_nb - 1) * (imgDir + pi) / (2 * pi)) + 1;
[h, w] = size(img);
radius = size(img, 1) / 5;
r2 = radius ^ 2;
half = floor(h / 2);
for y = 1 : h
    for x = 1 : w
        mag = imgMag(y, x);
        ori = imgDir(y, x);
        if (x - half) ^ 2 + (y - half) ^ 2 < r2
            his(ori) = his(ori) + mag;
        end
    end
end

%figure(3);stem(4*[1:bin_nb],his);

% non-maximal suppression around max

[maxValue, in] = max(his);
bin(1) = in;

if nMaxOri > 1
    his(in) = 0;
    
    round_bin = [ 1:bin_nb 1:bin_nb];
    left = round_bin( (bin_nb + in - n_suppress):(bin_nb + in - 1) );
    right = round_bin( (in + 1):(in + n_suppress) );
    his(left) = 0;  his(right) = 0;

    for iter = 2 : nMaxOri
        [m, in] = max(his);
        if m > maxValue * 0.8
            bin(iter) = in;
            his(in) = 0;
            left = round_bin((bin_nb + in - n_suppress) : (bin_nb + in - 1));
            right = round_bin((in + 1) : (in + n_suppress));
            his(left) = 0;
            his(right) = 0;
        end
    end
end

angle = (2 * pi * bin) / bin_nb;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [imgMag, imgDir] = gradmag(img, sigma)

% convolution kernel
x = [floor(-3.0 * sigma + 0.5) : floor(3.0 * sigma + 0.5)];
G = exp(-x .^ 2 / (2 * sigma ^ 2));
G = G / sum(sum(G));
D = -2 * (x .* exp(-x .^ 2 / (2 * sigma ^ 2))) / (sqrt(2 * pi) * sigma ^ 3);

img1 = conv2(img, D, 'same');
imgDx = conv2(img1, G', 'same');
img2 = conv2(img, D', 'same');
imgDy = conv2(img2, G, 'same');

imgMag = sqrt((imgDx .^ 2) + (imgDy .^ 2));
imgDir = atan2(imgDy, imgDx);

