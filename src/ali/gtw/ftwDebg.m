function wsDebg = ftwDebg(Xs, bas, A0, par, varargin)
% Debug ftw.
% 
% Input
%   Xs      -  sequences, 1 x m (cell), dim x ni
%   bas     -  basis, 1 x m (cell)
%   A0      -  initial weight, k x nRep
%   par     -  ftw parameter
%   varargin
%     save option
%
% Output
%   wsDebg
%     objs    -  objective value, nRep x 1
%     A0      -  initial weigths, k x nRep
%     AD      -  change of weight, k x nRep
%     aliOpt  -  optimum ali
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-19-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

prIn(1);

% save option
[svL, path] = psSv(varargin, 'subx', 'ftw_debg');

% load
if svL == 2 && exist(path, 'file')
    pr('old ftw obj debg');
    wsDebg = matFld(path, 'wsDebg');
    prIn(0);
    return;
end
pr('new ftw obj debg');

% dimension
[k, nRep] = size(A0);

% parameter
par.nItMa = 2; par.debg = 'n';

% exhaustively computing
objs = Inf(1, nRep);
AD = zeross(k, nRep);
prIn(1);
for iRep = 1 : nRep
    prCo(iRep, nRep, .1);

    % ftw
    ali0.a = A0(:, iRep);
    ali = ftw(Xs, bas, ali0, [], par);

    % store
    objs(iRep) = ali.objs(1);
    AD(:, iRep) = ali.aD;
end
prIn(0);

% optimum
[objOpt, idx] = min(objs);
aliOpt.alg = 'exhaustive';
aliOpt.obj = objOpt;
aliOpt.a = A0(:, idx);
aliOpt.P = baTemCmb(bas, aliOpt.a);

% store
wsDebg.objs = objs;
wsDebg.A0 = A0;
wsDebg.AD = AD;
wsDebg.aliOpt = aliOpt;

% save
if svL > 0
    save(path, 'wsDebg');
end

prIn(0);
