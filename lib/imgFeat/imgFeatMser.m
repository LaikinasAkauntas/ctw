function [Det, Des] = imgFeatMser(wsPath, parF)
% Obtain MSER feature.
%
% Input
%   wsPath
%     img   -  path of image file
%   parF    -  feature parameter
%     es    -  ellipse scale, {1.0}
%     per   -  maximum relative area, {0.010}
%     ms    -  minimum size of output region, {30}
%     mm    -  minimum margin, {10}
%    
% Output    
%   Reg     -  detector, dR (= 5) x n
%   Des     -  descriptor, dF (= 128) x n
%           
% History   
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-30-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 01-16-2012

% function parameter
es = ps(parF, 'es', 1);
per = ps(parF, 'per', .01);
ms = ps(parF, 'ms', 30);
mm = ps(parF, 'mm', 10);
prIn('imgFeatMser', 'es %.1f, per %.3f, ms %.0f mm %.0f', es, per, ms, mm);

% path
[foldPath, imgNm] = fileparts(wsPath.img);
detPath = sprintf('%s/%s_mser.det', foldPath, imgNm);
desPath = sprintf('%s/%s_mser.des', foldPath, imgNm);

% MSER detectors
opt = sprintf('-t 2 -es %f -per %f -ms %d -mm %d -i "%s" -o "%s"', ...
              es, per, ms, mm, wsPath.img, detPath);
runCom('mser', opt);
Det = loadMat(detPath, 5);

% SIFT descriptor
opt = sprintf('-sift -i "%s" -p1 "%s" -o1 "%s"', ...
              wsPath.img, detPath, desPath);
runCom('compute_descriptors', opt);
Des = loadMat(desPath, 128);

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
function runCom(binNm, opt)
% Run command.
%
% Input
%   binNm  -  name of command
%   opt    -  option of command

% specified in addPath.m
global footpath;

% binary file
binfold = sprintf('%s/lib/imgFeat/bin', footpath);

% for Windows
if strncmp(computer, 'PC', 2)
    binPost = 'exe';

% for Linux
elseif strcmp(computer, 'GLNX86') || strcmp(computer, 'GLNXA64')
    binPost = 'ln';

% for Mac
elseif strcmp(computer, 'MACI64')
    return;
    
else
    error('This function can run only with MS Windows or Linux');
end

% call the binary executable
s = sprintf('%s/%s.%s %s', binfold, binNm, binPost, opt);
unix(s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = loadMat(fpath, dim)
% Load feature matrix.
%
% Input
%   fpath  -  path of feature file
%   dim    -  dimension
%            
% Output     
%   X      -  feature, dim x n

% load the output file
fid = fopen(fpath, 'r');
if fid == -1
    error('file %s does not exist', fpath);
end

dim0 = fscanf(fid, '%f', 1);
num = fscanf(fid, '%d', 1);
X = fscanf(fid, '%f', [dim, inf]);
    
fclose(fid);
