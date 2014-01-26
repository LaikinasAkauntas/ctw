function wsInit = hsaInit(src, parImg, varargin)
% Select the template image for tracking person.
%
% Input
%   src     -  hsa source
%   parImg  -  image parameter
%   varargin
%     save option
%     fig   -  figure number, {5}
%
% Output
%   wsInit
%     fTem  -  part of frame as the template for tracking, 1 x 2 (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

prIn(1);

% save option
[svL, path] = psSv(varargin, 'fold', 'hsa/init', ...
                             'prex', src.nm, ...
                             'subx', 'init');

% load
if svL == 2 && exist(path, 'file')
    pr('old hsa init: %s', src.nm);
    wsInit = matFld(path, 'wsInit');
    prIn(0);
    return;
end
pr('new hsa init: %s', src.nm);

% function option
fig = ps(varargin, 'fig', 5);

sizTem = [0, 0];
fTem = cropTem(src, parImg, fig, sizTem);

if ~isempty(fTem)
    imwrite(fTem, sprintf('%s.jpg', path(1 : end - 4)));
end

wsInit.fTem = fTem;

% save
if svL > 0
    save(path, 'wsInit');
end

prIn(0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fTem = cropTem(src, par, fig, sizTem)
% Crop human body according to the direction.
%
% Input
%   src     -  hsa src
%   par     -  parameter
%   fig     -  figure number
%   sizTem  -  specified size of template, if [0 0], not used
%
% Output
%   fTem    -  template

R = src.R;
r = R(:, 2);

% path
wsPath = hsaPaths(src);

% open avi
hr = vReader(wsPath.vdo, 'comp', 'img', 'cl', 'gray', 'form', 'double');

% repeat until receiving a 'q'
isQ = 0;
while ~isQ
    fprintf('please indicate 4 points (up, down, left, right) in the image...\n');
    
    if ~exist('iF', 'var')
        iF = r(1);
    else
        figure(fig);
        iF = floor(iF + steps);
    end
    F0 = vRead(hr, iF);
    
    % blur
    F = imgBlur(F0, par);

    % receive coordinates from mouse
    figure(fig); clf;
    imshow(F);
    [x, y] = ginput(4);

    % crop the human
    fTem = cropHuman(F, x, y, sizTem);
    figure(fig + 1); clf;
    imshow(fTem);

    % quit or continue
    isValid = 0;
    states = {'q', 'p', 'n'};
    while ~isValid
        in = input('quit (q) | previous (p) | next (n):', 's');
        
        % type of operation
        for i = 1 : length(states)
            if strcmp(in(1), states{i})
                isValid = i;
                break;
            end
        end

        % steps
        steps = 1;
        if length(in) > 1
            steps = str2double(in(2 : end));
            if isnan(steps)
                isValid = 0;
                
            elseif isValid == 2
                steps = -steps;
            end
        end
    end
    isQ = isValid == 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fTem = cropHuman(f, x, y, sizTem)
% Obtain the bounding box.
%
% Input
%   f       -  input image
%   x       -  x points, 1 x 4
%   y       -  y points, 1 x 4
%   sizTem  -  specified size
%
% Output
%   fTem    -  cropped template

% center
a = floor([mean(y(1 : 2)), mean(x(3 : 4))]);

% size
if ~exist('sizTem', 'var') || isempty(sizTem) || sizTem(1) == 0
    h = (y(2) - y(1)) * 1.2;
    w = h * 1.0;
    sizTem = floor([h w]);
end

% upper-left corner
b = floor(a - sizTem .* [.57 .5]);
box = [b; b + sizTem - 1]';

% crop
fTem = imgCrop(f, box);
