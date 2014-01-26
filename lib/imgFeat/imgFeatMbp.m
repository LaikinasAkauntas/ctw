function [Pt, M, MP] = imgFeatMbp(F0, mbpPath, parF)
% Image shape (contour) detection by mBp algorithm.
%
% References
%   D. R. Martin, C. Fowlkes and J. Malik, 
%   "Learning to Detect Natural Image Boundaries Using Local Brightness, Color, and Texture Cues", PAMI, 2004
%
% Input
%   F0       -  original image
%   mbpPath  -  path of mBp file
%   parF     -  parameter
%     th     -  threshold, {0.05}
%            
% Output     
%   Pt       -  mask point, 2 x n
%   M        -  mask, h x w (binary)
%   MP       -  boundary probability, h x w (continuous)
%            
% History    
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-30-2011
%   modify   -  Feng Zhou (zhfe99@gmail.com), 12-09-2012

% function parameter
th = ps(parF, 'th', .05);
prIn('imgFeatMbp', 'th %.2f', th);

% load from the pre-computed result
if exist(mbpPath, 'file')
    [G, mPb_nmax_rsz] = matFld(mbpPath, 'G', 'mPb_nmax_rsz');
    
% run mBp detector and save the result
else
    % normalize pixel to [0, 1]
    F = double(F0) / 255;

    % mPb contour detector
    [G, mPb_nmax_rsz] = multiscalePb(F);
    
    % create fold if not existed
    foldpath = fileparts(mbpPath);
    if ~isdir(foldpath)
        mkdir(foldpath);
    end
    
    % save
    save(mbpPath, 'G', 'mPb_nmax_rsz');
end

% remove the points on the boundary
wid = 3;
G(1 : wid, :) = 0;
G(end - wid + 1 : end, :) = 0;
G(:, 1 : wid) = 0;
G(:, end - wid + 1 : end) = 0;

% binary mask
MP = G;
M = G > th;
M = bwmorph(M, 'skel', inf);

% boundary point
Pt = maskM2P(M);
Pt(3, :) = [];

prOut;
