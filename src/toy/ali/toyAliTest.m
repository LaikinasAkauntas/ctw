function wsTest = toyAliTest(tag, parTest, parDtw, parCtw, parCca, varargin)
% Test alignment algorithm.
%
% Input
%   tag     -  shape of latent sequence
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

prIn(1);

% save option
[svL, path] = psSv(varargin, 'subx', 'test', ...
                             'fold', 'toy/ali');

% load
if svL == 2 && exist(path, 'file')
    wsTest = matFld(path, 'wsTest');
    if equal('parTest', wsTest.parTest, parTest, 'prom', 'n') && ...
       equal('parDtw', wsTest.parDtw, parDtw, 'prom', 'n') && ...
       equal('parCtw', wsTest.parCtw, parCtw, 'prom', 'n') && ...
       equal('parCca', wsTest.parCca, parCca, 'prom', 'n')
        pr('old toy ali test: tag %d', tag);
        prIn(0);
        return;
    end
end
pr('new toy ali test: tag %d', tag);

% function parameter
nRep = ps(parTest, 'nRep', 10);

% src
[X0s, Xss, aliTs, aliUtws, aliDtws, aliDdtws, aliCtws, aliHctws] = cellss(1, nRep);
for iRep = 1 : nRep
    prCo(iRep, nRep, .1);
    
    wsSrc = toyAliSrc(tag, 200, 2, 'svL', 0);
    [X0s{iRep}, Xs, aliT] = stFld(wsSrc, 'X0', 'XNs', 'aliT');
    Xss{iRep} = Xs;
    aliTs{iRep} = aliT;

    % utw
    aliUtw = utw(Xs, [], aliT);
    aliUtws{iRep} = aliUtw;

    % dtw
    aliDtws{iRep} = dtw(Xs, aliT, parDtw);

    % ddtw
    aliDdtws{iRep} = ddtw(Xs, aliT, parDtw);

    % imw
    % aliImw = imw(Xs, aliT, parImw);

    % ctw
    aliCtws{iRep} = ctw(Xs, aliUtw, aliT, parCtw, parCca, parDtw);

    % hctw
    Xss0 = seqPyr(Xs, 3, []);
    aliHctws0 = hctw(Xss0, aliUtw, aliT, parCtw, parCca, parDtw);
    aliHctws{iRep} = aliHctws0{end};
end

% store
wsTest.parTest = parTest;
wsTest.parDtw = parDtw;
wsTest.parCtw = parCtw;
wsTest.parCca = parCca;
wsTest.X0s = X0s;
wsTest.Xss = Xss;
wsTest.aliTs = aliTs;
wsTest.aliUtws = aliUtws;
wsTest.aliDtws = aliDtws;
wsTest.aliDdtws = aliDdtws;
wsTest.aliCtws = aliCtws;
wsTest.aliHctws = aliHctws;

% save
if svL > 0
    save(path, 'wsTest');
end

prIn(0);
