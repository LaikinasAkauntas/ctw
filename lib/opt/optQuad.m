function x = optQuad(alg, H, f, AEq, bEq, A, blc, buc, blx, bux, x0)
% Quadratic Programming.
%
% Math
%   minimize     x' * H * x + 2 * f' * x
%   subject to   blc <= A * x <= buc
%                blx <= x <= bux
%
% Input
%   alg     -  toolbox name, 'matlab' | 'cvx' | 'mosek'
%   H       -  Hessian matrix, d x d
%   f       -  d x 1
%   A       -  c x d
%   blc     -  c x 1
%   buc     -  c x 1
%   blx     -  d x 1
%   bux     -  d x 1
%   x0      -  initial solution, d x 1 | []
%
% Output
%   x       -  solution, d x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 10-16-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 08-29-2012

% enfore H to be symmetric
H = (H + H') / 2;
if issparse(H)
    H = full(H);
end

% rank
%if rank(H) < size(H, 1)
%     warning('MATLAB:LoadErr', 'rank-deficient');
%end

% matlab
if strcmp(alg, 'matlab')
    warning off;
    option = optimset('Display', 'off', 'LargeScale', 'on');
    x = quadprog(H, f, A, buc, AEq, bEq, blx, bux, x0, option);
    warning on;

% mosek
elseif strcmp(alg, 'mosek')
    parMsk = struct('MSK_IPAR_LOG', 0, ...
                    'MSK_IPAR_LOG_INTPNT', 0, ...
                    'MSK_IPAR_LOG_SIM', 0, ...
                    'MSK_IPAR_LOG_BI', 0, ...
                    'MSK_IPAR_LOG_PRESOLVE', 0);
    cmd = 'minimize info echo(0) statuskeys(1) symbcon';
    res = mskqpopt(H, f, A, blc, buc, blx, bux, parMsk, cmd);
    x = res.sol.itr.xx;

% cvx
elseif strcmp(alg, 'cvx')
    k = size(H, 1);
    cvx_quiet true;
    cvx_begin
        variable x(k, 1);
        minimize(x' * H * x + 2 * f' * x)
        subject to
            A * x <= buc;
    cvx_end

else
    error('unknown algorithm: %s', alg);
end
