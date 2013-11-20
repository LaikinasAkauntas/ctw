function line = getline(fid)
% Get a line from a file, but ignore it if it starts with character '#'.
%
% Input
%   fid     -  file handle
%
% Output
%   line    -  string
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

line = fgetl(fid);

while ~isempty(line) && line(1) == '#'
    line = fgetl(fid);
end
