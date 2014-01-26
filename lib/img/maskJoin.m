function Ma = maskJoin(Ln, LnT)

Ml = [tmp, LnT];
n = size(Ml, 2);
mi = min(Ml(1 : 2, :), [], 2);
Ml(1 : 2, :) = Ml(1 : 2, :) - repmat(mi, 1, n) + 1;
Ma = maskL2M(Ml);

tmp(1 : 2, :) = tmp(1 : 2, :) - repmat(mi, 1, size(tmp, 2)) + 1;
MaTmp = maskL2M(tmp);
for i = 1 : size(MaTmp, 1)
    for j = 1 : size(MaTmp, 2)
        if MaTmp(i, j) > 0
            Ma(i, j) = 2;
        end
    end
end