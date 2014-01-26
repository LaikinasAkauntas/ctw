function tran = tranIni(par, varargin)
% Initialize a transformation.
%
% Input
%   par     -  parameter
%     algT  -  transformation name, 'sim' | 'aff' | 'non'
%     ** used only for similarity or affine transformation **
%     d     -  dimension
%     ** used only for non-rigid transformation **
%     P     -  basis point for computing RBF kernel, d x n
%     sigW  -  sigma for computing RBF kernel
%     lamW  -  regularization weight
%   varargin
%     rand  -  flag of random transformation, 'y' | {'n'}
%           
% Output    
%   tran    -  transformation
%     algT  -  transformation name, 'sim' | 'aff' | 'non'
%     ** similarity **
%     R     -  rotation matrix, d x d
%     s     -  scaling factor
%     t     -  translation vector, d x 1
%     ** affine **
%     V     -  projection matrix, d x d
%     t     -  translation vector, d x 1
%     ** non-rigid **
%     W     -  weight matrix, d x n
%     P     -  point set, d x n
%     sigW  -  bandwidth
%     lamW  -  regularization weight
%           
% History   
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-16-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 11-19-2012

% function option
isRand = psY(varargin, 'rand', 'n');

algT = par.algT;

% similarity transform
if strcmp(algT, 'sim')
    d = par.d;
    
    if isRand
        % rotation
        R = ps(par, 'R', []);
        if isempty(R)
            if d == 2
                R = cpd_R(rand(1));
            else
                R = cpd_R(rand(1), rand(1), rand(1));
            end
        end

        % scaling
        s = ps(par, 's', []);
        if isempty(s)
            s = rand(1) * 4 + 1;
        end
        
        % translation
        t = ps(par, 't', []);
        if isempty(t)
            t = zeros(d, 1);
        end
    else
        R = eye(d);
        s = 1;
        t = zeros(d, 1);
    end
    tran = st('algT', algT, 'R', R, 's', s, 't', t);

% affine transform
elseif strcmp(algT, 'aff')
    d = par.d;

    if isRand
        % projection
        V = ps(par, 'V', []);
        if isempty(V)
            if d == 2
                V = eye(2) + 0.5 * abs(randn(2, 2));
            else
                V = cpd_R(rand(1), rand(1), rand(1)) + abs(0.1 * randn(3, 3));
                V = V * .1;
            end
        end
        
        % translation
        t = ps(par, 't', []);
        if isempty(t)
            t = zeros(d, 1) + .1;
        end
    else
        V = eye(d);
        t = zeros(d, 1);
    end
    tran = st('algT', algT, 'V', V, 't', t);

% non-rigid transform
elseif strcmp(algT, 'non')
    [P, sigW, lamW] = stFld(par, 'P', 'sigW', 'lamW');
    n = size(P, 2);

    if ~isRand
        W = zeros(2, n);
        tran = st('algT', algT, 'W', W, 'P', P, 'sigW', sigW);        
        return;
    end

    % prior parameter
    P0 = P;
    w = par.w;

    % grid
    mi = min(P0, [], 2);
    ma = max(P0, [], 2);
    dx = (ma(1) - mi(1)) * .1;
    dy = (ma(2) - mi(2)) * .1;
    xs = mi(1) : dx : ma(1);
    ys = mi(2) : dy : ma(2);    
    [X, Y] = meshgrid(xs, ys);
    P = [X(:) Y(:)]';
    nP = size(P, 2);
    
    % distort the basis
    D = w * randn(2, nP);
    P2 = P + D;
    W = D / (lamW * eye(nP) + cpd_G(P2', P', sigW));
    
    % rotation
    R = cpd_R((rand(1) - .5) * 2 * (pi / 6));
    
    % apply the transformation
    tran = st('algT', algT, 'W', W, 'P', P, 'sigW', sigW, 'lamW', lamW, 'R', R, 's', 1);

    isDeb = 0;
    if isDeb
        figure(2);
        clf;
        subplot(1, 2, 1)
        hold on;
        plot(P(1, :), P(2, :), '.r');
        plot(P2(1, :), P2(2, :), '.b');
        
        xs = [P(1, :); P2(1, :); nan(1, nP)];
        ys = [P(2, :); P2(2, :); nan(1, nP)];
        plot(xs(:), ys(:), '--k');
        
        P4 = tranRun(P0, tran);
        plot(P4(1, :), P4(2, :), 'ob');
        
        [Gr1, controls] = ctps_plot_grid_gen(P0', 3, 7);
        Gr1b = tranRun(Gr1', tran);
        subplot(1, 2, 2);
        ctps_plot_gridbox(1, Gr1, controls, 'b', ':');
        ctps_plot_gridbox(1, Gr1b', controls, 'r', ':');
    end

else
    error('unknown transformation name: %s', algT);
end
