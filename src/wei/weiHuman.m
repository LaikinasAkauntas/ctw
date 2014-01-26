function WEI = weiHuman
% Obtain information of Weizmann sequences. Parse the original
% 'mask.mat' & 'wei.txt' provided by the authors of the databases.
%
% Output
%   WEI    
%     name (e.g., daria_walk, denis_jack)
%       dire  -  direction
%       Pts   -  mask points, 1 x nF (cell)
%       pos   -  index of the frame as mean shape
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% path
global footpath; % specified in addPath.m
foldpath = sprintf('%s/data/wei', footpath);
weipath = sprintf('%s/wei.txt', foldpath);
maskpath = sprintf('%s/mask.mat', foldpath);
shapepath = sprintf('%s/wei.mat', foldpath);

% if mat existed, just load
if exist(shapepath, 'file')
    WEI = matFld(shapepath, 'WEI');
    prInOut('weiHuman', 'old');
    return;
end
prIn('weiHuman', 'new');

% original mask
masks = matFld(maskpath, 'original_masks');

% open text file
fid = fopen(weipath, 'rt');
if fid == -1
    error('can not open file: %s', weipath);
end;

% parse the file line-by-line
while ~feof(fid)
    line = fgetl(fid);
    parts = tokenise(line, ' ');

    % skip empty line
    if isempty(parts)
        continue;
    end

    % the three parts
    cname = parts{1};
    pname = parts{2};
    dire = parts{3};
    pos = parts{4};
    name = sprintf('%s_%s', pname, cname);

    % check the avi
    ppath = sprintf('%s/%s/%s.avi', foldpath, cname, name);
    if ~exist(ppath, 'file')
        error('avi file does not exist for: %s', name);
    end

    % mask
    % for lena
    if strcmp(pname, 'lena') && (strcmp(cname, 'walk') || strcmp(cname, 'run') || strcmp(cname, 'skip'))
        fieldname = sprintf('%s1', name);
    else
        fieldname = name;
    end
    Ms = masks.(fieldname);

    % flip
    if strcmp(dire, 'l')
        Ms = Ms(:, end : -1 : 1, :);
    end
    
    % mask -> point
    nF = size(Ms, 3);
    Pts = cell(1, nF);
    for iF = 1 : nF
        Pts{iF} = maskM2P(double(Ms(:, :, iF)));
    end

    % store
    WEI.(name).dire = dire;
    WEI.(name).Pts = Pts;
    WEI.(name).pos = atoi(pos);
end
fclose(fid);

% sort field by name
names = fieldnames(WEI);
[names2, idx] = sort(names);
for i = 1 : length(names2)
    WEI2.(names2{i}).dire = WEI.(names{idx(i)}).dire;
    WEI2.(names2{i}).Pts = WEI.(names{idx(i)}).Pts;
    WEI2.(names2{i}).pos = WEI.(names{idx(i)}).pos;
end
WEI = WEI2;

% save
save(shapepath, 'WEI');

prOut;
