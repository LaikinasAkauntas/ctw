function [Dof, join] = amc2dof(fname)
% Parse the content of amc file to obtain the degree-of-freedom (DOF) of joint.
%
% Input
%   fname   -  amc file path
%
% Output
%   Dof     -  Dof matrix, dim (= sum(join.dims)) x nF
%   join    -  joint information
%     nms   -  joint names, 1 x nJ (cell)
%     dims  -  dimension of each joint, 1 x nJ
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 04-22-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-17-2012

prIn('amc2dof');

% open
fid = fopen(fname, 'rt');
if fid == -1
    error('can not open file: %s', fname);
end;

% read header
line = fgetl(fid);
while ~strcmp(line, ':DEGREES')
    line = fgetl(fid);
end

% read data
nF = 0;
maNF = 200000;
m = 0;
maM = 1000;

nms = cell(1, maM);
dims = zeros(1, maM * 3);

while ~feof(fid)
    nF = nF + 1;
    if rem(nF, 1000) == 0
        pr('reading frame: %d', nF);
    end

    % first term is the frame number
    if nF == 1
        fscanf(fid, '%s\n', 1);
    end

    dof = zeros(100, 1); nn = 0;
    while true
        line = fgetl(fid);
        
        % end of the file
        if line == -1 
            break;
        end
        
        parts = tokenise(line, ' ');

        % reach an empty line, skip       
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

% store
join.nms = nms;
join.dims = dims;

prOut;
