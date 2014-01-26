function wsRun = weiAliRuns(act, wsSub, feats, parCca, parPdtw, parPimw, parPctw, parGN, parGtw, varargin)
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
prex = wsSub.prex;
[svL, path] = psSv(varargin, ...
                   'prex', prex, ...
                   'subx', 'runs', ...
                   'fold', 'wei/ali');

% load
if svL == 2 && exist(path, 'file')
    prInOut('weiAliRuns', 'old, %s', prex);
    wsRun = matFld(path, 'wsRun');
    return;
end
prIn('weiAliRuns', 'new, %s', prex);

% basis parameter
parStp = []; parPol = [5 .5]; parTan = [5 1 1];

% subjects
subIdxs = stFld(wsSub, 'subIdxs');
nRep = length(subIdxs);

% rep
[X0s, Xss, aliTs] = cellss(1, nRep);
Dif = zeros(5, nRep);
prCIn('rep', nRep, .1);
for iRep = 1 : nRep
    prC(iRep);

    % src
    wsSrc = weiAliSrc(act, subIdxs{iRep}, 'y', 'svL', 2);
    
    % data
    wsData = weiAliData(wsSrc, 'svL', 2);
    X0s = weiAliDataX(wsData, feats, st('d', .999));
    Xs = pcas(X0s, st('d', min(cellDim(X0s, 1)), 'cat', 'n'));
    XTs = pcas(wsData.XEs, st('d', .9, 'cat', 'y'));
    Xss{iRep} = Xs;

    % basis
    ns = cellDim(Xs, 2);
    l = round(max(ns) * 1.1);
    bas = baTems(l, ns, 'stp', parStp, 'pol', parPol, 'tan', parTan);

    % utw (initialization)
    aliUtw = utw(Xs, bas, []);

    % truth
    aliT = pdtw(XTs, aliUtw, [], parPdtw);
    aliTs{iRep} = aliT;

    % pdtw
    aliPdtw = pdtw(Xs, aliUtw, aliT, parPdtw);
    Dif(1, iRep) = aliPdtw.dif;

    % pddtw
    aliPddtw = pddtw(Xs, aliUtw, aliT, parPdtw);
    Dif(2, iRep) = aliPddtw.dif;

    % pimw
    aliPimw = pimw(Xs, aliUtw, aliT, parPimw, parPdtw);
    Dif(3, iRep) = aliPimw.dif;
    
    % pctw
    aliPctw = pctw(Xs, aliUtw, aliT, parPctw, parCca, parPdtw);
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
