function areas = areaDiv(Siz)
% Divide the area into blocks.
%
% Input
%   Siz     -  size, 2 x (nH + 1)
%
% Output
%   areas   -  area position, 1 x nH (cell)
%     iHs   -  1 x Siz(1, iH)
%     iTs   -  1 x Siz(1, iH)
%     iH0s  -  1 x Siz(1, iH)
%     iT0s  -  1 x Siz(1, iH)
%     jHs   -  1 x Siz(2, iH)
%     jTs   -  1 x Siz(2, iH)
%     jH0s  -  1 x Siz(2, iH)
%     jT0s  -  1 x Siz(2, iH)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
nH = size(Siz, 2) - 1;

areas = cell(1, nH);
for c = 1 : nH
    % position in the next level
    ave = floor(Siz(:, c + 1) ./ Siz(:, c));
    [iHs, iTs] = zeross(1, Siz(1, c));
    [jHs, jTs] = zeross(1, Siz(2, c));
    for i = 1 : Siz(1, c)
        iHs(i) = ave(1) * (i - 1) + 1;
        iTs(i) = select(i == Siz(1, c), Siz(1, c + 1), ave(1) * i);
    end
    for j = 1 : Siz(2, c)
        jHs(j) = ave(2) * (j - 1) + 1;
        jTs(j) = select(j == Siz(2, c), Siz(2, c + 1), ave(2) * j);
    end

    % position in the bottom level
    ave0 = floor(Siz(:, nH + 1) ./ Siz(:, c));
    [iH0s, iT0s] = zeross(1, Siz(1, c));
    [jH0s, jT0s] = zeross(1, Siz(2, c));
    for i = 1 : Siz(1, c)
        iH0s(i) = ave0(1) * (i - 1) + 1;
        iT0s(i) = select(i == Siz(1, c), Siz(1, nH + 1), ave0(1) * i);
    end
    for j = 1 : Siz(2, c)
        jH0s(j) = ave0(2) * (j - 1) + 1;
        jT0s(j) = select(j == Siz(2, c), Siz(2, nH + 1), ave0(2) * j);
    end

    % store
    areas{c} = struct('iHs', iHs, 'iTs', iTs, 'jHs', jHs, 'jTs', jTs, ... 
                      'iH0s', iH0s, 'iT0s', iT0s, 'jH0s', jH0s, 'jT0s', jT0s);
end
