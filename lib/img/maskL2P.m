function Pt = maskL2P(siz, Ln)
% Convert the lines of one mask to its matrix form.
%
% Input
%   siz     -  image size ([h, w]), 1 x 2
%   Ln      -  vertical lines of mask, 3 x nL.
%              For each line, the relavant column store the coordiantes of the first point
%              with the length of the lines.
%
% Output
%   Pt      -  mask matrix, 2 x nP
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

nL = size(Ln, 2);
if isempty(siz)
    w = max(Ln(2, :));
    h = max(Ln(1, :) + Ln(3, :) - 1);
else
    h = siz(1); 
    w = siz(2);
end

M = zeros(h, w);
for i = 1 : nL
    x = Ln(1, i);
    y = Ln(2, i);
    len = Ln(3, i);
    M(x : x + len - 1, y) = 1;
end
