function Sh = maskMatch(Pts, PtT, varargin)
% Search for the optimum shift of mask.
%
% Input
%   Pts      -  mask, 1 x nF (cell), (2 + nChan) x nPt
%   PtT      -  template mask
%   varargin
%     ran    -  seaching range, {[.2; .2]}
%
% Output
%   Sh       -  optimum shift of Ln around LnT, 2 x nF
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
ran = ps(varargin, 'ran', [.2; .2]);

% dimension
nF = length(Pts);

% set last column to one
for iF = 1 : nF
    nPt = size(Pts{iF}, 2);
    Pts{iF} = [Pts{iF}([1 2], :); ones(1, nPt)];
end

% search
Sh = zeros(2, nF);
for iF = 1 : nF
    Sh(:, iF) = maskMatchSearch(Pts{iF}, PtT, ran);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sh = maskMatchSearch(Pt, PtT, ran)
% Search for the optimum match of two masks.
%
% Input
%   Pt   -  mask, 3 x nPt
%   PtT  -  mask template, 3 x nPtT
%   ran  -  seaching range, 2 x 1
%
% Output
%   sh   -  optimum shift of Ln around LnT, 2 x 1

% size of template mask
boxT = maskBox({PtT});
sizT = boxT(:, 2) - boxT(:, 1) + 1;

% shifting area
nShs = round(sizT .* ran)';
sh1s = -nShs(1) : nShs(1);
sh2s = -nShs(2) : nShs(2);
nShs = nShs * 2 + 1;

% searching around the template
V = zeros(nShs);
nPt = size(Pt, 2);
for i1 = 1 : nShs(1)
    for i2 = 1 : nShs(2)
        Pti = Pt + repmat([sh1s(i1); sh2s(i2); 0], 1, nPt);
        V(i1, i2) = maskOver(Pti, PtT);
    end
end

% optimum shift
[~, idx] = max(V(:));
[i1, i2] = ind2sub(nShs, idx);
sh = [sh1s(i1); sh2s(i2)];
