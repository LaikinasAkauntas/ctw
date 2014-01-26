function shAliCmpOne(Xs, X0s, alis, aliT, parCca, parDtw)
% Show alignments.
% 
% Input
%   Xs      -  used by GTW
%   X0s     -  used by other method
%   alis
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-19-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-05-2013

% parameter
parPca = st('d', 3, 'homo', 'y');
parPca0 = st('d', 3, 'homo', 'n');
parMk = st('mkSiz', 1, 'lnWid', 1, 'ln', '-');
parChan = st('nms', {'x', 'y', 'z'}, 'gapWid', 1, 'all', 'y');
parAx = st('mar', .1, 'ang', [30 80], 'tick', 'n');

m = length(alis);
rows = 2; cols = m + 2;
axs = iniAx(2, rows, cols, [100 * rows, 250 * cols], 'hGap', .4);
set(axs{1, 3}, 'Visible', 'off');
set(axs{2, 3}, 'Visible', 'off');
set(axs{2, 1}, 'Visible', 'off');
set(axs{2, 2}, 'Visible', 'off');

% ori
XX0s = pcas(X0s, parPca0);
% shs(XX0s, parMk, parAx, 'ax', axs{1, 1}); title('original sequence');

% marginfy the original signial
XX0s{1} = XX0s{1}(1, :) * 40 * 8;
XX0s{2} = XX0s{2}(1, :) * 15 * 2;
XX0s{3} = XX0s{3}(1, :);
shChans(XX0s, parMk, parChan, 'ax', axs{1, 1});

% legend('binary', 'Euclidean', 'Poisson');
h = legend('Motion capture', 'Video', 'Accelerometer');
set(h, 'Orientation', 'horizontal', 'FontSize', 10);

algs = cellFld(alis, 'cell', 'alg');
for i = 1 : m
    col = i + 1;
    ali = alis{i};
    alg = algs{i};

    % truth
    if strcmp(alg, 'truth')
        Ys = gtwTra(homoX(Xs), ali, parCca, parDtw);
        YYs = pcas(Ys, parPca);
        shs(YYs, parMk, parAx, 'ax', axs{1, col}); title(alg);
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % uni
    elseif strcmp(alg, 'utw')
        shs(XX0s, parMk, parAx, 'ax', axs{1, col}); title(alg);
        shChans(XX0s, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});
        
    % dtw    
    elseif strcmp(alg, 'dtw')
        shs(XX0s, parMk, parAx, 'ax', axs{1, col}); title(alg);
        shChans(XX0s, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % ddtw
    elseif strcmp(alg, 'ddtw')
        YYs = pcas(ali.Ys, parPca0);
        shs(YYs, parMk, parAx, 'ax', axs{1, col}); title(alg);
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % pdtw
    elseif strcmp(alg, 'pdtw')
        shs(XX0s, parMk, parAx, 'ax', axs{1, col}); title(alg);
        shChans(XX0s, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % pddtw
    elseif strcmp(alg, 'pddtw')
        YYs = pcas(ali.Ys, parPca0);
        shs(YYs, parMk, parAx, 'ax', axs{1, col}); title(alg);
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});
        
    % pimw
    elseif strcmp(alg, 'pimw')
        Ys = pimwTra(X0s, ali);
        YYs = pcas(Ys, parPca0);
        shs(YYs, parMk, parAx, 'ax', axs{1, col}); title(alg);
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % ctw
    elseif strcmp(alg, 'ctw')
        Ys = gtwTra(homoX(Xs), ali, parCca, parDtw);
        YYs = pcas(Ys, parPca);
        shs(YYs, parMk, parAx, 'ax', axs{1, col}); title(alg);
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % hctw
    elseif strcmp(alg, 'hctw')
        Ys = gtwTra(homoX(Xs), ali, parCca, parDtw);
        YYs = pcas(Ys, parPca);
        shs(YYs, parMk, parAx, 'ax', axs{1, col}); title(alg);
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % ftw    
    elseif strcmp(alg, 'ftw')
        shs(XX0s, parMk, parAx, 'ax', axs{1, col}); title(alg);
        shChans(XX0s, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});

    % hftw
    elseif strcmp(alg, 'hftw')
        shs(XX0s, parMk, parAx, 'ax', axs{1, col}); title(alg);
        shChans(XX0s, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{2, col});
    
    % gtw
    elseif strcmp(alg, 'gtw')
        Ys = gtwTra(homoX(Xs), ali, parCca, parDtw);
        YYs = pcas(Ys, parPca);
%         shs(YYs, parMk, parAx, 'ax', axs{1, col}); title(alg);
        YYs{1} = YYs{1}(1, :);
        YYs{2} = YYs{2}(1, :);
        YYs{3} = YYs{3}(1, :);
        shChans(YYs, parMk, stAdd(parChan, 'P', ali.P), 'ax', axs{1, col});
%         h = legend('distance transform', '3-d joint', 'shape context');
%         set(h, 'Orientation', 'horizontal');

    else
        error('unknown algorithm: %s', alg);
    end
end
