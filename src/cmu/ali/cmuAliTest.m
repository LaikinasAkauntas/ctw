function wsTest = cmuAliTest(act, subIdx, rann, parTest, parDtw, parCtw, parCca, varargin)
% Test alignment algorithm for CMU mocap database.
%
% Input
%   tag     -  src type
%   parTest
%   parDtw
%   varargin
%     save option
%
% Output
%   wsTest
%     X0    -  latent sequence, 2 x t
%     XTs   -  sequences after temporal transformation, 1 x m (cell)
%     XGs   -  sequences after global spatial transformation, 1 x m (cell)
%     XLs   -  sequences after local  spatial transformation, 1 x m (cell)
%     XGNs  -  sequences after global spatial transformation + noise in 3rd dimension, 1 x m (cell)
%     XLNs  -  sequences after local  spatial transformation + noise in 3rd dimension, 1 x m (cell)
%     aliT  -  ground truth alignment
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-17-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% save option
[svL, path] = psSv(varargin, 'subx', 'test', ...
                             'fold', 'cmu/ali');

% load
if svL == 2 && exist(path, 'file')
    wsTest = matFld(path, 'wsTest');
    if equal('parTest', wsTest.parTest, parTest, 'prom', 'n') && ...
       equal('parDtw', wsTest.parDtw, parDtw, 'prom', 'n') && ...
       equal('parCtw', wsTest.parCtw, parCtw, 'prom', 'n') && ...
       equal('parCca', wsTest.parCca, parCca, 'prom', 'n')
        prom('m', 'old cmu ali test: %s\n', cellStr(act, subIdx, rann));
        return;
    end
end
prom('m', 'new cmu ali test: %s\n', cellStr(act, subIdx, rann));
setPromL('t');

m = length(subIdx);

% all combinations
Idx = zeros(2, m * m);
Feat = cell(2, m * m);
nRep = 0;
for i = 1 : m
    for j = 1 : m
        nRep = nRep + 1;
        Idx(:, nRep) = [i; j];
        Feat{1, nRep} = 'XQ';
        Feat{2, nRep} = 'XP';
    end
end

[aliTs, ali0s, aliDtws, aliDdtws, aliCtws, aliHctws] = cellss(1, nRep);
for iRep = 1 : nRep
    promCo('t', iRep, nRep, .1);
    idx = Idx(:, iRep);
    feats = Feat(:, iRep);
    subIdxi = subIdx(idx);
    tag = cellStr(act, subIdxi, rann);

    % src
    wsSrc = cmuAliSrc(act, subIdxi, rann, 'svL', 2, 'prex', tag);

    % data
    wsData = cmuAliData(wsSrc, 'svL', 2, 'prex', tag);
    [X0s, Xs, Ys] = cmuAliDataX(wsData, feats, struct('d', .95));

    % truth (dtw)
    aliT = dtw(X0s, [], parDtw);
    aliT.Vs = mcca(seqInp(Xs, aliT.P, parDtw), stAdd(parCca, 'homo', 'n'));
    aliTs{iRep} = aliT;

    % ini
    ali0 = uni(cellDim(Xs, 2), aliT);
    ali0s{iRep} = ali0;

    % dtw
    aliDtws{iRep} = dtw(Ys, aliT, parDtw);

    % ddtw
    aliDdtws{iRep} = ddtw(Ys, aliT, parDtw);

    % ctw
    aliCtws{iRep} = ctw(Xs, ali0, aliT, parCtw, parCca, parDtw);

    % hctw
    Xss = seqPyr(Xs, 3, []);
    aliHctws0 = hctw(Xss, ali0, aliT, parCtw, parCca, parDtw);
    aliHctws{iRep} = aliHctws0{end};
end

% store
wsTest.parTest = parTest;
wsTest.parDtw = parDtw;
wsTest.parCtw = parCtw;
wsTest.parCca = parCca;
wsTest.aliTs = aliTs;
wsTest.ali0s = ali0s;
wsTest.aliDtws = aliDtws;
wsTest.aliDdtws = aliDdtws;
wsTest.aliCtws = aliCtws;
wsTest.aliHctws = aliHctws;
wsTest.Idx = Idx;
wsTest.Feat = Feat;

% save
if svL > 0
    save(path, 'wsTest');
end
setPromL('m');
