function v = maskPOverSlow(Pt1, Pt2)
% Calculate the overlap area of two binary images.
%
% Input
%   Pt1     -  1st vertical lines of mask, 3 x nPt1
%   Pt2     -  2nd vertical lines of mask, 3 x nPt2 
%
% Output
%   v       -  overall matching score
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
nPt1 = size(Pt1, 2);
nPt2 = size(Pt2, 2);

p1 = 1; p2 = 1; v = 0;
while p1 <= nPt1 && p2 <= nPt2;
    i1 = Pt1(1, p1);
    j1 = Pt1(2, p1);
    i2 = Pt2(1, p2);
    j2 = Pt2(2, p2);
    
    if i1 == i2 && j1 == j2
        v = v + Pt1(3, p1) * Pt2(3, p2);
        p1 = p1 + 1;
        p2 = p2 + 1;
    elseif j1 < j2 || (j1 == j2 && i1 < i2)
        p1 = p1 + 1;
    else
        p2 = p2 + 1;
    end
end
