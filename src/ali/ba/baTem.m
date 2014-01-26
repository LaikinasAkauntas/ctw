function ba = baTem(l, n, varargin)
% Generate temporal basis.
%
% Input
%   l       -  length of destined sequence
%   n       -  length of original sequence
%   varargin
%     stp   -  parameter for step basis, {[]}
%     pol   -  parameter for poly basis, {[]}
%     exp   -  parameter for exponential basis, {[]}
%     log   -  parameter for log basis, {[]}
%     tan   -  parameter for tanh basis, {[]}
%     spl   -  parameter for spline basis, {[]}
%     tra   -  parameter for translation basis, {[]}
%
% Output
%   ba      -  basis
%     P     -  warping, l x k
%     sig   -  sign of basis, 1 x k
%     n     -  length of original sequence
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-26-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
parStp = ps(varargin, 'stp', []);
parPol = ps(varargin, 'pol', []);
parExp = ps(varargin, 'exp', []);
parLog = ps(varargin, 'log', []);
parTan = ps(varargin, 'tan', []);
parSpl = ps(varargin, 'spl', []);
parTra = ps(varargin, 'tra', []);

% step basis
if isempty(parStp)
    PStp = [];
    sigStp = [];
else
    [PStp, sigStp] = baTemAlg('stp', l, n, parStp);
end

% poly basis
if isempty(parPol)
    PPol = [];
    sigPol = [];
else
    [PPol, sigPol] = baTemAlg('pol', l, n, parPol);
end

% exponential basis
if isempty(parExp)
    PExp = [];
    sigExp = [];
else
    [PExp, sigExp] = baTemAlg('exp', l, n, parExp);
end

% log basis
if isempty(parLog)
    PLog = [];
    sigLog = [];
else
    [PLog, sigLog] = baTemAlg('log', l, n, parLog);
end

% tanh basis
if isempty(parTan)
    PTan = [];
    sigTan = [];
else
    [PTan, sigTan] = baTemAlg('tan', l, n, parTan);
end

% spline basis
if isempty(parSpl)
    PSpl = [];
    sigSpl = [];
else
    [PSpl, sigSpl] = baTemAlg('spl', l, n, parSpl);
end

% translation basis
if isempty(parTra)
    PTra = [];
    sigTra = [];
else
    [PTra, sigTra] = baTemAlg('tra', l, n, parTra);
end

% store
ba.P = [PStp, PPol, PExp, PLog, PTan, PSpl, PTra];
ba.sig = [sigStp, sigPol, sigExp, sigLog, sigTan, sigSpl, sigTra];
ba.n = n;
