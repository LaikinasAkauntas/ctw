function [Dof, join] = amc2dofOld(fname)
% Parse the content of amc file and save the degree-of-freedom of each joint.
%
% Input
%   fname   -  amc file path
%
% Output
%   Dof     -  Dof matrix, dim x nF
%              Notice that: dim = sum(join.dims)
%   join    -  joint information
%     nms   -  joint name, 1 x nJ (cell)
%     dims  -  joint DOF, 1 x nJ
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-22-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

% open
fid = fopen(fname, 'rt');
if fid == -1
    error(['can not open file ' fname]);
end;

% read-in header
line = fgetl(fid);
while ~strcmp(line, ':DEGREES')
    line = fgetl(fid);
end

% read-in data
% labels can be in any order
nF = 0;
maNF = 100000;
m = 0;
maM = 1000;

nms = cell(1, maM);
dims = zeros(1, maM * 3);

while ~feof(fid)
    nF = nF + 1;
    if rem(nF, 1000) == 0
        fprintf('Reading frame: %d\n', nF);
    end

    % first term is the frame number
    if nF == 1
        fscanf(fid, '%s\n', 1);
    end

    dof = zeros(100, 1); nn = 0;
    while true
        line = fgetl(fid);
        if line == -1 % end of the file
            break;
        end

        % reach an empty line, continue read
        parts = tokenise(line, ' ');
        if isempty(parts{1})
            continue;
        end

        % if reading the frame number, break
        p1 = parts{1}(1);
        if '0' <= p1 && p1 <= '9'
            break;
        end

        % read joint name
        if nF == 1
            m = m + 1;
            nms{m} = parts{1};
            dims(m) = length(parts) - 1;
        end

        % read joint angle
        for i = 2 : length(parts)
            nn = nn + 1;
            dof(nn) = atof(parts{i});
        end
    end
    dof(nn + 1 : end, :) = [];
    
    if nF == 1
        nms(m + 1 : end) = [];
        dims(m + 1 : end) = [];
        Dof = zeros(sum(dims), maNF);
    end

    Dof(:, nF) = dof;
end
Dof(:, nF + 1 : end) = [];

join.nms = nms;
join.dims = dims;
