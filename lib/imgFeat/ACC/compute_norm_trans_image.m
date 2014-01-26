function [featIdx, feat_aug, angle, shscMatrix, affMatrix] = compute_norm_trans_image(feat, img, scaling, szPatch, nMaxOri)
% Extract oriented regions from features.
%
% Input
%   feat        -  feature, nFeat x dim
%   img         -  image, h x w x nChan
%   scaling     -  scaling factor measurement region/distinguished region, {2}
%   szPatch     -  patch size, {41}
%   nMaxOri     -  maximum #orientations, {1}
%            
% Output
%   featIdx     -  index for augument feature, nBuff x 1
%   feat_aug    -  augument feature, nBuff x dim
%   angle       -  dominant feature, nBuff x 1
%   shscMatrix  -  nBuff x 4
%   affMatrix   -  nBuff x 9
%            
% History    
%   create      -  Feng Zhou (zhfe99@gmail.com), 12-30-2011
%   modify      -  Feng Zhou (zhfe99@gmail.com), 01-01-2012

% function option
if nargin < 3
    scaling = 2;    
end
if nargin < 4
    szPatch = 41;
end
if nargin < 5
    nMaxOri = 1;
end

% dimension
nFeat = size(feat, 1); 
nBuff = nFeat * max(nMaxOri, 1);
featIdx = zeros(nBuff, 1);
feat_aug = zeros(nBuff, size(feat, 2));
angle = zeros(nBuff, 1);
affMatrix = zeros(nBuff, 9);
shscMatrix = zeros(nBuff, 4);

% used when nMaxOri = 0
fixed_angle = 0; 

% debug flag
isDeb = 0;

% per feature
iAugFeat = 0;
for iFeat = 1 : nFeat
    % feature point | transform matrix
    % patch -> image
    A = [feat(iFeat, 3), feat(iFeat, 4); ...
         feat(iFeat, 4), feat(iFeat, 5)] ^ -0.5; % [a b; b c] ^ 0.5
    
    t_affMatrix = [A(1, 1), A(1, 2), feat(iFeat, 1), A(2, 1), A(2, 2), feat(iFeat, 2), 0, 0, 1];
    t_shscMatrix = [A(1, 1), A(1, 2), A(2, 1), A(2, 2)];
   
    if nMaxOri <= 0
        iAugFeat = iAugFeat + 1;
        R = [cos(fixed_angle), -sin(fixed_angle); ...
             sin(fixed_angle), cos(fixed_angle)];
        AR = A * R;

        featIdx(iAugFeat) = iFeat;
        feat_aug(iAugFeat, :) = feat(iFeat,:);
        angle(iAugFeat) = fixed_angle;
        affMatrix(iAugFeat, :) = [AR(1, 1), AR(1, 2), feat(iFeat, 1), AR(2, 1), AR(2, 2), feat(iFeat, 2), 0, 0, 1];
        shscMatrix(iAugFeat, :) = t_shscMatrix;      
    else
        % orientation estimation
        [t_normRegion, bOutside] = normalize_patchCMEX2(img, t_affMatrix, scaling, szPatch);
        
         % if the region is outside of image domain, skip
        if bOutside
            continue;
        end
        
        % debug
        if isDeb
            figure(6); 
            clf;
            subplot(1, 2, 1);
            imshow(img);
            hold on;
            drawEllipse3(feat(iFeat, 1 : 5), 1, 'r');
            
            subplot(1, 2, 2);
            imshow(t_normRegion);
        end
        
        t_angle = dominant_orientation(t_normRegion, nMaxOri);
        
    %     clf; subplot(131); 
    %     imshow(normalizedRegion{iFeat}); axis equal;
    %     title( [ 'Feature ' num2str(iFeat) ' : ' num2str(angle(iFeat)*180/3.14159) ] );   
    %     subplot(132); 
    %     imshow(imrotate(normalizedRegion{iFeat},angle(iFeat)*180/3.14159) ); axis equal;

        for iAngle = 1 : length(t_angle) 
            iAugFeat = iAugFeat + 1;
            
            %[ affineMatrix(iFeat,:) shscMatrix(iFeat,:) ] = computeNormTransform( 
            R = [cos(t_angle(iAngle)), -sin(t_angle(iAngle)); ...
                 sin(t_angle(iAngle)), cos(t_angle(iAngle))];
            AR = A * R;

            featIdx(iAugFeat) = iFeat;
            feat_aug(iAugFeat, :) = feat(iFeat, :);
            angle(iAugFeat) = t_angle(iAngle);
            affMatrix(iAugFeat, :) = [AR(1, 1), AR(1, 2), feat(iFeat, 1), AR(2, 1), AR(2, 2), feat(iFeat, 2), 0, 0, 1];
            shscMatrix(iAugFeat, :) = t_shscMatrix;
        end
    end
end

if iAugFeat < nBuff
    featIdx(iAugFeat + 1 : end) = [];
    feat_aug(iAugFeat + 1 : end, :) = [];
    angle(iAugFeat + 1 : end) = [];
    affMatrix(iAugFeat + 1 : end, :) = [];
    shscMatrix(iAugFeat + 1 : end, :) = [];
end
