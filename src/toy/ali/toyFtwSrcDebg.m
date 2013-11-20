function wsSrc = toyFtwSrcDebg(tag, n0, varargin)
% Generate sequence for alignment.
%
% Input
%   tag     -  shape of latent sequence
%              1: sin
%              2: circle
%              3: spiral
%              4: random curve
%   varargin
%     save option
%     inp   -  #frame in latent sequence, {200}
%     qp    -  #sequence, {2}
%
% Output
%   wsSrc
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
[svL, path] = psSv(varargin, 'subx', 'ftw_src_debg', ...
                             'fold', 'toy/ali');

% load
if svL == 2 && exist(path, 'file')
    pr('old ftw src debg: tag %d', tag);
    wsSrc = matFld(path, 'wsSrc');
    prIn(0);
    return;
end
pr('new ftw src debg: tag %d', tag);

% function option
inp = ps(varargin, 'inp', 'nearest');
qp = ps(varargin, 'qp', 'mosek');

% simple
if tag == 1
    % latent sequence
    t = 500;
    X0 = toyAliSeq(3, t);

    % new sequence
    t1 = 100;
    t2 = 100;
    Xs = cell(1, 2);
    Xs{1} = [(ones(2, t1) - 1) * 10, X0, (ones(2, t2) - 1) * 10];
    Xs{2} = X0;
    ns = cellDim(Xs, 2);

    % basis
    [bas, a0s] = cellss(1, 2);
    bas{1} = baTem(t, ns(1), 'pol', [1 .5], 'tra', 1);
    bas{2} = baTem(t, ns(2), 'pol', [1 .5]);

    % init
    head = t1 - 20; 
    tail = t1 + t + 20;
    p = linspace(head, tail, t)';
    % p2 = head + (linspace(1, t, t)' - 1) * (tail - head) / (t - 1);
    % equal('p', p, p2);
    a0s{1} = baTemFit(p, bas{1}, qp);
    a0s{2} = 1;
    a0 = mcat('vert', a0s);
    P0 = baTemCmb(bas, a0);

    % ground-truth
    PT = [linspace(t1 + 1, t1 + t, t)', bas{2}.P];
    aT = baTemFit(PT(:, 1), bas{1}, qp);

% two sin
elseif tag == 2
    % latent sequence
    t = 100;
    X0 = toyAliSeq(3, t);

    % new sequence
    t1 = 20;
    t2 = 20;
    t3 = 10;
    Xs = cell(1, 2);
    Xs{1} = [(ones(2, t1) - 1) * 10, X0, (ones(2, t3) - 1) * 10, X0, (ones(2, t2) - 1) * 10];
    Xs{2} = X0;
    ns = cellDim(Xs, 2);
    
    % basis
    [bas, a0s] = cellss(1, 2);
    bas{1} = baTem(t, ns(1), 'pol', [1 .5], 'tra', 1);
    bas{2} = baTem(t, ns(2), 'pol', [1 .5]);
    
    % init
    head = t1 - 10; 
    tail = t1 + t + t3 + t + 10;
    p = linspace(head, tail, t)';
    a0s{1} = baTemFit(p, bas{1}, qp);
    a0s{2} = 1;
    a0 = mcat('vert', a0s);
    P0 = baTemCmb(bas, a0);

    % ground-truth
    PT = [linspace(t1 + 1, t1 + t, t)', bas{2}.P];
    aT = baTemFit(PT(:, 1), bas{1}, qp);
    
% subsequence
elseif tag == 3
    % latent sequence
%     t = 500;
    X0 = toyAliSeq(5, n0);

    % new sequence
    t1 = 101;
    t2 = 400;
    Xs = cell(1, 2);
    Xs{1} = X0;
    Xs{2} = X0(:, t1 : t2);
    ns = cellDim(Xs, 2);
    l = ns(2);

    % basis
    [bas, a0s] = cellss(1, 2);
    bas{1} = baTem(l, ns(1), 'pol', [1 .5], 'tra', 1);
    bas{2} = baTem(l, ns(2), 'pol', [1 .5]);

    % init
    head = 1;
    tail = l;
%     a0s{1} = baTemFit(1 : l, bas{1}, qp);
    a0s{1} = [.4; 190];
    a0s{2} = 1;
    a0 = mcat('vert', a0s);
    P0 = baTemCmb(bas, a0);

    % ground-truth
    PT = [linspace(t1, t2, l)', bas{2}.P];
    aT = baTemFit(PT(:, 1), bas{1}, qp);

else
    error('unknown tag: %d', tag);
end

aliT.alg = 'truth';
aliT.P = PT;
aliT.a = aT;
aliT.obj = gtwObj(Xs, aliT, [], st('inp', inp));

ali0.alg = 'utw';
ali0.P = P0;
ali0.a = a0;
ali0.obj = gtwObj(Xs, ali0, [], st('inp', inp));

% store
wsSrc.Xs = Xs;
wsSrc.aliT = aliT;
wsSrc.ali0 = ali0;
wsSrc.bas = bas;
wsSrc.head = head;
wsSrc.tail = tail;

% save
if svL > 0
    save(path, 'wsSrc');
end

prIn(0);
