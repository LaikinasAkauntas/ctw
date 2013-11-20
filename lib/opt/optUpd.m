function opt = optNew(nItMa, m)
% Create optimization information wrapper.
%
% Input
%   nItMa    -  #maximum iteration
%   m        -  #object components
%
% Output
%   opt
%     nIt    -  #iteration
%     nItMa  -  #maximum iteration
%     its    -  iteration index, 1 x nIt
%     objs   -  objective at each iteration, 1 x nIt
%     Obj    -  objective components at each iteration, m x nIt
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 10-16-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

opt = st('nIt', 0, 'nItMa', nItMa, 'its', zeros(1, nItMa), 'objs', zeros(1, nItMa), 'Obj', zeros(m, nItMa));
