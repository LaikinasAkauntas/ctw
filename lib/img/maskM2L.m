function Ln = maskM2L(M)
% Convert the mask matrix to the lines.
%
% Input
%   M       -  mask matrix, h x w
%
% Output
%   Ln      -  vertical lines of mask, 3 x nL (uint8)
%              Each column stores the coordiantes of the first point as well as the length of the line.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

[h, w] = size(M);
Ln = zeros(3, h * w);
nL = 0;

for j = 1 : w
    iHead = 1;
    while iHead <= h
        % move down until encountering a 1 or end of the row
        while iHead <= h && M(iHead, j) == 0
            iHead = iHead + 1;
        end
        if iHead > h
            break;
        end

        % move down until encountering a 0 or end of the row
        iTail = iHead;
        while iTail <= h && M(iTail, j) == 1
            iTail = iTail + 1;
        end

        % add
        nL = nL + 1;
        Ln(1, nL) = iHead; Ln(2, nL) = j; Ln(3, nL) = iTail - iHead;

        iHead = iTail;
    end
end
Ln(:, nL + 1 : end) = [];
