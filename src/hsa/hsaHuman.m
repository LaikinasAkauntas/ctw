function HSA = hsaHuman(varargin)
% Parse the property file of the HSA dataset.
%
% Input
%   varargin
%     txtpath  -  path of text file specifying the range of actions
%     matpath  -  path of mat file containing the parsed result
%
% Output
%   KTH        -  range of each actions, 1 x 1 (struct)
%                 each field contains the starting and ending position, 2 x m
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify    -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% parameter
global footpath; % specified in addPath.m
txtpath1 = [footpath '/data/hsa/hsa.txt'];
matpath1 = [footpath '/data/hsa/hsa.mat'];
txtpath = ps(varargin, 'txtpath', txtpath1);
matpath = ps(varargin, 'matpath', matpath1);

% if mat existed, just load
if exist(matpath, 'file')
    tmpMat = load(matpath);
    HSA = tmpMat.HSA;
    return;
end

fprintf('parsing file %s...\n', txtpath);

% open text file
fid = fopen(txtpath, 'rt');
if fid == -1
    error(['can not open file: ' txtpath]);
end

% line-by-line
while ~feof(fid)
    line = fgetl(fid);
    parts = tokenise(line, ' ');

    % skip empty line
    if isempty(parts)
        continue;
    end
    
    % eliminate the first two 
    name = parts{1};
    parts([1 2]) = [];
    
    % number of segments
    m = length(parts);
    if length(parts{end}) == 1
        m = m - 1;
    end

    % range for segment
    % two forms: xx-xx, and xx-xx (last segment)
    P = zeros(2, m);
    for i = 1 : m
        part = parts{i};
        if i < m
            part = part(1 : end - 1); % skip the comma
        end

        frames = tokenise(part, '-');
        P(1, i) = str2double(frames{1});
        P(2, i) = str2double(frames{2});
    end
    parts(1 : m) = [];
    
    % direction
    if isempty(parts)
        dire = 'l';
    else
        dire = parts{1};
    end

    % store as a sub-field
    HSA.(name).R = P;
    HSA.(name).dire = dire;
end

% save
save(matpath, 'HSA');
