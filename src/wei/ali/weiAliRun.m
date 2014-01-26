function wsRun = weiAliRun(act, wsSub, feats, parCca, parDtw, parImw, parCtw, parGN, parGtw, varargin)
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
prex = wsSub.prex;
[svL, path] = psSv(varargin, ...
                   'prex', prex, ...
                   'subx', 'run', ...
                   'fold', 'wei/ali');

% load
if svL == 2 && exist(path, 'file')
    prInOut('weiAliRun', 'old, %s', prex);
    wsRun = matFld(path, 'wsRun');
    return;
end
prIn('weiAliRun', 'new, %s', prex);

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
    Xs{1} = double(Xs{1});
    Xs{2} = double(Xs{2});

    XTs = pcas(wsData.XEs, st('d', .9, 'cat', 'y'));
    Xss{iRep} = Xs;

    % basis
    ns = cellDim(Xs, 2);
    l = round(max(ns) * 1.1);
    bas = baTems(l, ns, 'stp', parStp, 'pol', parPol, 'tan', parTan);

    % utw (initialization)
    aliUtw = utw(Xs, bas, []);

    % truth
    aliT = dtw(XTs, [], parDtw);
    aliTs{iRep} = aliT;

    % dtw
    aliDtw = dtw(Xs, aliT, parDtw);
    aliDtws{iRep} = aliDtw;
    Dif(1, iRep) = aliDtw.dif;

    % ddtw
    aliDdtw = ddtw(Xs, aliT, parDtw);
    aliDdtws{iRep} = aliDdtw;
    Dif(2, iRep) = aliDdtw.dif;

    % imw
    aliImw = pimw(Xs, aliUtw, aliT, parImw, parDtw);
    aliImws{iRep} = aliImw;
    Dif(3, iRep) = aliImw.dif;
    
    % ctw
    aliCtw = ctw(Xs, aliUtw, aliT, parCtw, parCca, parDtw);
    aliCtws{iRep} = aliCtw;
    Dif(4, iRep) = aliCtw.dif;
    
    % gtw
    aliGtw = gtw(Xs, bas, aliUtw, aliT, parGtw, parCca, parGN);
    aliGtws{iRep} = aliGtw;
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
