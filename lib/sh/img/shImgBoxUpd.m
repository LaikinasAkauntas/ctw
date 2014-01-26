function ha = shImgBoxUpd(ha, Fs)
% Plot images in boxs.
%
% Input
%   ha       -  handle
%   Fs       -  image, 1 x m (cell)
%
% Output
%   ha
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
m = length(Fs);

% plot image
hImgs = cell(1, m);
for i = 1 : m
    set(ha.hImgs{i}, 'CData', Fs{i});
end
