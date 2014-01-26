function wsRun = toyAliRuns(tag, nRep, parDtw, parPimw, parGN, parGtw, parCca, varargin)
% Test alignment algorithm on aligning multiple time series.
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
                   'subx', 'runs', ...
                   'fold', 'toy/ali');

% load
if svL == 2 && exist(path, 'file')
    prInOut('toyAliRuns', 'old, %s', prex);
    wsRun = matFld(path, 'wsRun');
    return;
end
prIn('toyAliRuns', 'new, tag %d, nRep %d', tag, nRep);

% parameter
l = 300;
m = 3;

parPctw = st('nItMa', 50, 'th', 0, 'debg', 'n');

% rep
[X0s, Xss, aliTs] = cellss(1, nRep);
Dif = zeros(5, nRep);
prCIn('rep', nRep, .1);
for iRep = 1 : nRep
    prC(iRep);

    % src
    wsSrc = toyAliSrc(tag, l, m);
    [X0, Xs, aliT] = stFld(wsSrc, 'X0', 'Xs', 'aliT');
    
    % store
    X0s{iRep} = X0;
    Xss{iRep} = Xs;
    aliTs{iRep} = aliT;

    % basis
    ns = cellDim(Xs, 2);
    bas = baTems(l, ns, 'pol', [3 .4], 'tan', [3 .6 1]);

    % utw (initialization)
    aliUtw = utw(Xs, bas, aliT);

    % pdtw
    aliPdtw = pdtw(Xs, aliUtw, aliT, parDtw);
    Dif(1, iRep) = aliPdtw.dif;

    % pddtw
    aliPddtw = pddtw(Xs, aliUtw, aliT, parDtw);
    Dif(2, iRep) = aliPddtw.dif;

    % pimw
    aliPimw = pimw(Xs, aliUtw, aliT, parPimw, parDtw);
    Dif(3, iRep) = aliPimw.dif;
    
    % pctw
    aliPctw = pctw(Xs, aliUtw, aliT, parPctw, parCca, parDtw);
    Dif(4, iRep) = aliPctw.dif;    

    % gtw
    aliGtw = gtw(Xs, bas, aliUtw, aliT, parGtw, parCca, parGN);
    Dif(5, iRep) = aliGtw.dif;
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
