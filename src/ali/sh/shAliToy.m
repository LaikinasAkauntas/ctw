function shAliToy(wsSrc, alis, bas, parDtw, parCca)
% Show alignments for toy data.
% 
% Input
%   Xs      -  used by GTW
%   X0s     -  used by other method
%   alis
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-19-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% parameter
parPca = st('d', 3, 'homo', 'y');
parPca0 = st('d', 3, 'homo', 'n');
parMk = st('mkSiz', 1, 'lnWid', 1, 'ln', '-');
parChan = st('nms', {'x', 'y', 'z'}, 'gapWid', 1, 'all', 'y');
parAx = st('mar', .1, 'ang', [30 80], 'tick', 'n', 'label', 'n');

% ax
m = length(alis);
rows = 2; cols = m + 2;
axs = iniAx(3, rows, cols, [250 * rows, 250 * cols]);

% src
[X0, Xs, XSTs, aliT] = stFld(wsSrc, 'X0', 'Xs', 'XSTs', 'aliT');
X0s = Xs;
XX0s = pcas(X0s, parPca0);

% dimension
l = size(bas{1}.P, 1);

% ori
shs(XSTs, parMk, parAx, 'ax', axs{1, 1});
xlabel('x'); ylabel('y');

title('original sequence');
shChans(XSTs, parMk, parChan, 'ax', axs{2, 1});

algs = cellFld(alis, 'cell', 'alg');
for i = 1 : m
    col = i + 1;
    ali = alis{i};
    alg = algs{i};

    % truth
    if strcmp(alg, 'truth')
        Ys = gtwTra(homoX(Xs), ali, parCca, parDtw);
        YYs = pcas(Ys, parPca);
        shs(YYs, parMk, parAx, 'ax', axs{1, col});
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % uni
    elseif strcmp(alg, 'utw')
        shs(XX0s, parMk, parAx, 'ax', axs{1, col});  
        shChans(XX0s, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});
        
    % dtw    
    elseif strcmp(alg, 'dtw')
        shs(XX0s, parMk, parAx, 'ax', axs{1, col});  
        shChans(XX0s, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % ddtw
    elseif strcmp(alg, 'ddtw')
        YYs = pcas(ali.Ys, parPca0);
        shs(YYs, parMk, parAx, 'ax', axs{1, col});  
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % pdtw
    elseif strcmp(alg, 'pdtw')
        shs(XX0s, parMk, parAx, 'ax', axs{1, col});  
        shChans(XX0s, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % pddtw
    elseif strcmp(alg, 'pddtw')
        YYs = pcas(ali.Ys, parPca0);
        shs(YYs, parMk, parAx, 'ax', axs{1, col});  
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});
        
    % pimw
    elseif strcmp(alg, 'pimw')
        Ys = pimwTra(Xs, ali);
        YYs = pcas(Ys, parPca0);
        shs(YYs, parMk, parAx, 'ax', axs{1, col});  
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % ctw
    elseif strcmp(alg, 'ctw')
        Ys = gtwTra(homoX(Xs), ali, parCca, parDtw);
        YYs = pcas(Ys, parPca);
        shs(YYs, parMk, parAx, 'ax', axs{1, col});  
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % hctw
    elseif strcmp(alg, 'hctw')
        Ys = gtwTra(homoX(Xs), ali, parCca, parDtw);
        YYs = pcas(Ys, parPca);
        shs(YYs, parMk, parAx, 'ax', axs{1, col});  
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % ftw    
    elseif strcmp(alg, 'ftw')
        shs(XX0s, parMk, parAx, 'ax', axs{1, col});  
        shChans(XX0s, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % hftw
    elseif strcmp(alg, 'hftw')
        shs(XX0s, parMk, parAx, 'ax', axs{1, col});  
        shChans(XX0s, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});
    
    % gtw
    elseif strcmp(alg, 'gtw')
        Ys = gtwTra(homoX(Xs), ali, parCca, parDtw);
        YYs = pcas(Ys, parPca);
        shs(YYs, parMk, parAx, 'ax', axs{1, col});
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    else
        error('unknown algorithm: %s', alg);
    end
    
    set(gcf, 'CurrentAxes', axs{1, col});
    title(sprintf('%s, error %.1f', alg, alis{i}.dif));
    xlabel('x'); ylabel('y'); zlabel('z');
end

% all
ali2s = cellCat({aliT}, alis);
shAlis(ali2s, 'ax', axs{1, m + 2}, 'leg', 'y', 'ang', [-55, 60]);
grid on;
title('alignment path');

[~, cls] = genMkCl;
shP(bas{1}.P, 'ax', axs{2, m + 2}, 'lnWid', 1, 'mkSiz', 0, 'cl', cls, 'G', eye(size(bas{1}.P, 2)));
set(gca, 'XTick', [], 'YTick', []);
title('basis for gtw');
