function it = a2it(a)
% Obtain the iteration id from the string.
%
% Input
%   a       -  iteration string, 'spa' | 'tem' | 'wei'
%
% Output
%   it      -  iteration id, 1   |    2   |   3
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 09-20-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-19-2013

if strcmp(a, 'spa')
    it = 1;

elseif strcmp(a, 'tem')
    it = 2;

elseif strcmp(a, 'wei')
    it = 3;

else
    error('unknown iteration string: %s', a);
end
