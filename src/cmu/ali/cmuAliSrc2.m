function wsSrc = cmuAliSrc2(tag, varargin)
% Obtain the source according to the sepcified tag.
%
% Input
%   tag       -  source type
%   varargin
%     save option
%
% Output
%   wsSrc
%     srcs    -  sources, 1 x 2 (cell)
%     paraFs  -  feature parameter, 1 x 2 (cell)
%     rangs   -  range parameter, 1 x 2 (cell)
%     aliT    -  ground truth alignment
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 04-22-2009
%   modify    -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

% save option
[svL, path] = psSv(varargin, 'subx', 'src', ...
                             'fold', 'moc/ali');

% load
if svL == 2 && exist(path, 'file')
    prom('t', 'old moc ali src: tag %d\n', tag);
    wsSrc = matFld(path, 'wsSrc');
    return;
end
prom('t', 'new moc ali src: tag %d\n', tag);

pairs = {'10', '06',   [0 0], '11', '01',     [0 0]; ... % 1 kick ball
         '08', '01', [0 200], '09', '01',     [0 0]; ... % 2 walk vs run
         '16', '02',   [0 0], '13', '42',     [0 0]; ... % 3 jump vs jump
         '02', '01', [1 240], '09', '01',     [0 0]; ... % 4 walk vs run
         '13', '17', [1 800], '15', '13',   [1 800]; ... % 5 jump vs forward jump
         '02', '01',   [0 0], '54', '11',   [1 241]; ... % 6 walk vs penguin walk
         '02', '01',   [0 0], '54', '12',   [1 500]; ... % 7 walk vs dragon walk
         '02', '01',   [0 0], '54', '01', [500 900]; ... % 8 walk vs monkey walk
         '08', '01', [0 200], '08', '07',   [41 0]};     % 9 walk vs stride

% subject
[srcs, paraFs, rangs] = cellss(1, 2);
if tag < 10
    srcs{1} = mocSrc('moc', pairs{tag, 1}, pairs{tag, 2});
    srcs{2} = mocSrc('moc', pairs{tag, 4}, pairs{tag, 5});

    for i = 1 : 2
        if strcmp(srcs{i}.dbe, 'moc')
            paraFs{i}.filt = 'barbic';
            paraFs{i}.feat = 'log';
        elseif strcmp(srcs{i}.dbe, 'kit')
            paraFs{i}.filt = 'all2';
            paraFs{i}.feat = 'log';
        end
    end

%     [rangs, C] = aliTruth(srcs);
    aliT = [];
    rangs{1} = pairs{tag, 3};
    rangs{2} = pairs{tag, 6};

elseif tag == 10
    srcs{1} = mocSrc('kit', '01', 'brownies');
    srcs{2} = mocSrc('kit', '03', 'brownies');
    
    for i = 1 : 2
        if strcmp(srcs{i}.dbe, 'moc')
            paraFs{i}.filt = 'barbic';
            paraFs{i}.feat = 'log';
        elseif strcmp(srcs{i}.dbe, 'kit')
            paraFs{i}.filt = 'all2';
            paraFs{i}.feat = 'log';
        end
    end
    
%     [rangs, C] = aliTruth(sources);
    aliT = [];
    
    % open up cabinet
    rangs{1} = [468 1246];
    rangs{2} = [442 1272];

    % open down cabinet
%     rangs{1} = [1255 2135];
%     rangs{2} = [1312 2412];

    % open fridge
%     rangs{1} = [2215 2515];
%     rangs{2} = [2419 2732];

% log sequence
elseif tag == 11
    srcs{1} = mocSrc('kit', '01', 'brownies');
    srcs{2} = mocSrc('kit', '03', 'brownies');
    
    for i = 1 : 2
        if strcmp(srcs{i}.dbe, 'moc')
            paraFs{i}.filt = 'barbic';
            paraFs{i}.feat = 'log';
        elseif strcmp(srcs{i}.dbe, 'kit')
            paraFs{i}.filt = 'all2';
            paraFs{i}.feat = 'log';
        end
    end
    aliT = [];
    % open up cabinet
    rangs{1} = [0 0];
    rangs{2} = [0 0];

else
    error('unknown tag');
end

% store
wsSrc.srcs = srcs;
wsSrc.paraFs = paraFs;
wsSrc.rangs = rangs;
wsSrc.aliT = aliT;

if svL > 0
    save(path, 'wsSrc');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [rangs, C] = aliTruth(srcs)
% Obtain ground truth

% path
global footpath; % specified in addPath.m
foldpath = sprintf('%s/save/ali/truth', footpath);

pairs = {'02', '01', '07', '01'; ...
         '02', '02', '05', '01'; ...
         '02', '02', '06', '01'; ...
         '02', '02', '07', '02'; ...
         '06', '01', '05', '01'; ...
         '07', '01', '08', '02'; ...
         '08', '09', '08', '10'; ...
         '10', '04', '12', '01'; ...
         '12', '01', '12', '02'};

m = size(pairs, 1);

s1 = srcs{1};
s2 = srcs{2};

[rangs] = cellss(1, 2);
for i = 1 : m
    
    if strcmp(s1.pno, pairs{i, 1}) && ...
       strcmp(s1.trl, pairs{i, 2}) && ...
       strcmp(s2.pno, pairs{i, 3}) && ...
       strcmp(s2.trl, pairs{i, 4}) 
        truthpath = sprintf('%s/W_%s_%s_%s_%s_GTruth.mat', foldpath, s1.pno, s1.trl, s2.pno, s2.trl);
        mat = loadMat(truthpath);
        wsWarp = mat.wsWarp;

        % range
        range = wsWarp.range;
        rangs{1} = range(:, 1)';
        rangs{2} = range(:, 2)';
        
        % correspondence
        W0 = wsWarp.W;
        W = W0(rangs{1}(1) : rangs{1}(2), rangs{2}(1) : rangs{2}(2));
        C = W2C(W);
        return;
    end
end

error('unfound ground truth');
