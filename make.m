% Makefile.
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 03-20-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-05-2013

path0 = cd;

cd 'lib/cell';
mex cellss.cpp;
mex oness.cpp;
mex zeross.cpp;
cd(path0);

cd 'lib/text';
mex atoi.cpp;
mex atof.cpp;
mex tokenise.cpp;
cd(path0);

cd 'lib/img';
mex maskOver.cpp;
cd(path0);

cd 'src/ali/dtw';
mex dtwFord.cpp;
mex dtwBack.cpp;
mex dtwFordAsy.cpp;
cd(path0);

cd 'src/ali/help';
mex rowBd.cpp;
cd(path0);

cd 'src/ali/imw';
mex timewarp.cpp;
cd(path0);
