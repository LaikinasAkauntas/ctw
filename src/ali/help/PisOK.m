function isOK(P)

l = size(P, 1);
for i = 2 : l
    d = P(i, :) - P(i - 1, :);
    if d(1) == 1 && d(1) == 1
        continue;
    end
    
    if d(1) == 1 && d(1) == 0
        continue;
    end
    
    if d(1) == 0 && d(1) == 1
        continue;
    end
    
    i
    d
    error('incorrect step');
end