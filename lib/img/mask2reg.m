function [reg, G] = mask2reg(Ma)
% Obtained the connected region, given pixel label.
%
% Input
%   Ma      -  given mask, h x w
%
% Output
%   reg     -  regions array, 1 x nR (cell)
%   G
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-20-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
[h, w] = size(Ma);
reg = cell(1, h * w);
nR = 0;

% status
vis = zeros(h, w);
queue = zeros(2, h * w);
dire = [-1,  1,  0,  0, -1, -1, 1,  1; ...
         0,  0,  1, -1, -1,  1, 1, -1];
nD = size(dire, 2);     

for i = 1 : h
    for j = 1 : w
        if vis(i, j) == 1
            continue;
        end

        % starting point
        c = Ma(i, j);
        queue(:, 1) = [i; j];
        head = 1; tail = 2;

        % breath-first search
        while head < tail
            pos = queue(:, head);
            head = head + 1;
            vis(pos(1), pos(2)) = 1;

            for k = 1 : nD
                pos1 = pos + dire(:, k);

                if pos1(1) >= 1 && pos1(1) <= h && pos1(2) >= 1 && pos1(2) <= w && vis(pos1(1), pos1(2)) == 0 && Ma(pos1(1), pos1(2)) == c
                    vis(pos1(1), pos1(2)) = 1;
                    queue(:, tail) = pos1;
                    tail = tail + 1;
                end
            end
        end

        % One connected region
        nR = nR + 1;
        reg{nR} = queue(:, 1 : tail - 1);
    end
end
reg(nR + 1 : end) = [];

G = zeros(h, w);
for iR = 1 : nR
    idx = sub2ind([h w], reg{iR}(1, :), reg{iR}(2, :));
    G(idx) = iR;
    reg{iR} = idx;
end
