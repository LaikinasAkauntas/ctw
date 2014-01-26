function F = mask2img(M, cls)
% Show mask.
%
% Input
%   M       -  mask matrix, h x w
%   cls     -  color list, 1 x k (cell)
%
% Output
%   F       -  image, h x w x 3 (uint8)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

[h, w] = size(M);
[F1, F2, F3] = zeross(h, w);
for c = 2 : 3
    idx = find(M == c - 1);
    
    % color
    cl = cls{c};
    if length(cl) > 1
        v = c;
    elseif cl == 'b'
        v = [0 0 0];
    elseif cl == 'w'
        v = [255 255 255];
    elseif cl == 'r'
        v = [255 0 0];
    elseif cl == 'y'
        v = [255 255 0];
    else
       error('unknown color: cl %s', cl);
    end

    F1(idx) = v(1);
    F2(idx) = v(2);
    F3(idx) = v(3);
end
F = zeros(h, w, 3);
F(:, :, 1) = F1;
F(:, :, 2) = F2;
F(:, :, 3) = F3;
F = uint8(F);
