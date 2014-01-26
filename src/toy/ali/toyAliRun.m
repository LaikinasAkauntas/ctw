function wsRun = toyAliRun(tag, nRep, parDtw, parImw, parCtw, parCca, parGN, parGtw, varargin)
% Test alignment algorithm on aligning two time series.
%
% Input
%   tag     -  shape of latent sequence
%   nRep    -  #repeation
%   varargin
%     save option
%
% Output
%   wsRun
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-17-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-23-2013

% save option
prex = cellStr('toy', 'tag', tag, 'nRep', nRep);
[svL, path] = psSv(varargin, ...
                   'prex', prex, ...
                   'subx', 'run', ...
                   'fold', 'toy/ali');

% load
if svL == 2 && exist(path, 'file')
    prInOut('toyAliRun', 'old, %s', prex);
    wsRun = matFld(path, 'wsRun');
    return;
end
prIn('toyAliRun', 'new, tag %d, nRep %d', tag, nRep);

% parameter
l = 300;
m = 2;

% rep
[X0s, Xss, aliTs] = cellss(1, nRep);
Dif = zeros(5, nRep);
prCIn('rep', nRep, .1);
for iRep = 1 : nRep
    prC(iRep);

    % src
    wsSrc = toyAliSrc(tag, l, m);
    [X0s{iRep}, Xs, aliT] = stFld(wsSrc, 'X0', 'Xs', 'aliT');
    Xss{iRep} = Xs;
    aliTs{iRep} = aliT;
    
    % kernel
%     Ks = cell(1, 2);
%     for i = 1 : 2
%         Ks{i} = Xs{i}' * Xs{i};
%         Ks{i} = cenK(Ks{i});
%     D = conDst(Xs{i}, Xs{i});
%     Ks{i} = conKnl(D, 'knl', 'g', 'nei', .5);
%     end
    
    % basis
    ns = cellDim(Xs, 2);
    bas = baTems(l, ns, 'pol', [3 .4], 'tan', [3 .6 1]);

    % utw
    aliUtw = utw(Xs, bas, aliT);

    % dtw
    aliDtw = dtw(Xs, aliT, parDtw);
    Dif(1, iRep) = aliDtw.dif;

    % ddtw
    aliDdtw = ddtw(Xs, aliT, parDtw);
    Dif(2, iRep) = aliDdtw.dif;

    % imw
    aliImw = pimw(Xs, aliUtw, aliT, parImw, parDtw);
    Dif(3, iRep) = aliImw.dif;

    % ctw
    aliCtw = ctw(Xs, aliUtw, aliT, parCtw, parCca, parDtw);
    Dif(4, iRep) = aliCtw.dif;
    
    % gtw
    aliGtw = gtw(Xs, bas, aliUtw, aliT, parGtw, parCca, parGN);
    Dif(5, iRep) = aliGtw.dif;

    % kctw
%     parKcca = stAdd(parCca, 'd', .9, 'cen', 'n');
%     aliKctw = ctw(Ks, aliUtw, aliT, parCtw, parKcca, parDtw);
%     Dif(5, iRep) = aliKctw.dif;

end
prCOut(nRep);

% store
wsRun.X0s = X0s;
wsRun.Xss = Xss;
wsRun.aliTs = aliTs;
wsRun.Dif = Dif;

% save
if svL > 0
    save(path, 'wsRun');
end

prOut;
