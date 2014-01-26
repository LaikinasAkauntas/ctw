function M = maskP2M(siz, Pt, varargin)
% Convert points of mask to matrix.
%
% Input
%   siz     -  image size ([h, w]), 1 x 2
%   Pt      -  mask points, (2 + nChan) x nPt
%   varargin
%     PtT   -  mask that does not include the torso, {[]}
%     bkCl  -  {[0 0 0]}
%
% Output
%   M       -  mask matrix, h x w x nChan
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
PtT = ps(varargin, 'PtT', []);
bkCl = ps(varargin, 'bkCl', [0 0 0]);

% dimension
if isempty(siz)
    siz = max(Pt([1 2], :), [], 2);
end
[nChan, nPt] = size(Pt);
nChan = nChan - 2;

% matrix
if nChan == 0
    M = zeros(siz(1), siz(2));
    idx = sub2ind([siz(1), siz(2)], Pt(1, :), Pt(2, :), zeros(1, nPt) + 1);
    M(idx) = 1;

else
    M = zeros(siz(1), siz(2), nChan);
    for iChan = 1 : nChan
        M(:, :, iChan) = bkCl(iChan);
        idx = sub2ind([siz(1), siz(2), nChan], Pt(1, :), Pt(2, :), zeros(1, nPt) + iChan);
        M(idx) = Pt(2 + iChan, :);
    end
end

% torso
if ~isempty(PtT)
    MT = maskP2M(PtT);
    M(M ~= MT) = 2;
end
