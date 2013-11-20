function ali = dtw(Xs, aliT, par)
% Dynamic Time Warping (DTW).
%
% Input
%   Xs      -  sequences, 1 x 2 (cell), dim x ni
%   aliT    -  ground-truth alignment (can be [])
%   par     -  parameter
%     dp    -  implementation for dynamic programming, 'matlab' | {'c'}
%     cons  -  constraint name, 'none' | 'sc' | 'ip'
%              'none'  -  no constraint
%              'sc'    -  Sakoe-Chiba window constraint
%              'ip'    -  Itakura Parallelogram window constraint
%     win   -  parameter value for the case when cons == 'sc'
%     sca   -  parameter value for the case when cons == 'ip'
%
% Output
%   ali     -  alignment
%     alg   -  'dtw'
%     P     -  warping path, l x 2
%     obj   -  objective
%     tim   -  running time
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-09-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

% function parameter
dp = ps(par, 'dp', 'c');
cons = ps(par, 'cons', 'none');
prIn('dtw', 'dp %s, cons %s', dp, cons);

% dimension
ns = cellDim(Xs, 2);

% distance
D = conDst(Xs{1}, Xs{2});

% dynamic programming implemented in C
hTic = tic;
if strcmp(dp, 'c')
    if strcmp(cons, 'none')
        [v, S] = dtwFord(D);
        
    elseif strcmp(cons, 'sc')
        [v, S] = dtwFordSC(D, par.win);
        
    elseif strcmp(cons, 'ip')        
        [v, S] = dtwFordIP(D, par.sca);

    else
        error('unknown constraint: %s', cons);
    end
    
    P = dtwBack(S);

% dynamic programming implemented in Matlab
elseif strcmp(dp, 'matlab')
    if strcmp(cons, 'none')
        [v, S] = dtwFordSlow(D);

    elseif strcmp(cons, 'sc')
        [PL, PR] = dtwBandSC(ns, par.win);
        PBd = dtwBand2Bd(PL, PR);
        [v, S] = dtwFordBandSlow(D, PBd);

    elseif strcmp(cons, 'ip')
        [PL, PR] = dtwBandIP(ns, par.sca);
        PBd = dtwBand2Bd(PL, PR);
        [v, S] = dtwFordBandSlow(D, PBd);

    else
        error('unknown constraint: %s', cons);
    end

    P = dtwBackSlow(S);

else
    error('unknown dp implementation: %s', dp);
end

% store
ali.alg = 'dtw';
ali.P = P;
ali.obj = v;
ali.tim = toc(hTic);
if ~isempty(aliT)
    ali.dif = pDif(ali.P, aliT.P);
end

prOut;
