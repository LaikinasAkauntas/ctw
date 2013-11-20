function P = dtwBdMerg(Ps, ns, dire) 
% Merge the several band into a single band.
%
% Input
%   S       -  step matrix, n1 x n2
%
% Output
%   PBds    -  path boundary, 1 x 2 (cell), l x 2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-17-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
ls = cellDim(Ps, 1);

if dire == 1
    % extract line
    Ln = zeros(2, ns(1), 2);
    for c = 1 : 2
        t = 1;
        ii = 0;
        
        while t <= ls(c)
%             if t == ls(c)
%                 disp('here');
%             end
            
            i = Ps{c}(t, 1);
            j = Ps{c}(t, 2);
            
            if ii == 0
                ii = i;
                head = j;
                tail = j;
                
            elseif ii == i
                tail = j;
                
            else
                Ln(:, ii, c) = [head; tail];
                
                ii = i;
                head = j;
                tail = j;
            end
            
            t = t + 1;
        end
        Ln(:, ii, c) = [head; tail];
    end

    Bd = max(Ln, [], 3);
    P = zeros(ns(1) + ns(2), 2);
    m = 0;
    for i = 1 : ns(1)
        js = Bd(1, i) : Bd(2, i);
        li = length(js);
        
        P(m + 1 : m + li, 1) = i;
        P(m + 1 : m + li, 2) = js';
        m = m + li;
    end
    P(m + 1 : end, :) = [];
    
elseif dire == 2
    % extract line
    Ln = zeros(2, ns(1), 2);
    for c = 1 : 2
        t = 1;
        jj = 0;
        
        while t <= ls(c)
            i = Ps{c}(t, 1);
            j = Ps{c}(t, 2);
            
            if jj == 0
                jj = j;
                head = i;
                tail = i;
            elseif jj == j
                tail = i;
                
            else
                Ln(:, jj, c) = [head; tail];
                
                jj = j;
                head = i;
                tail = i;
            end
            
            t = t + 1;
        end
        Ln(:, jj, c) = [head; tail];
    end

    Bd = max(Ln, [], 3);
    P = zeros(ns(1) + ns(2), 2);
    m = 0;
    for j = 1 : ns(2)
        is = Bd(1, j) : Bd(2, j);
        lj = length(is);
        
        P(m + 1 : m + lj, 1) = is';
        P(m + 1 : m + lj, 2) = j;
        m = m + lj;
    end
    P(m + 1 : end, :) = [];
    
else
    error('unknown direction: %d', dire);
end
