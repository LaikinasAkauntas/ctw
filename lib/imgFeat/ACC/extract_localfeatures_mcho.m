function featInfo = extract_localfeatures_mcho(imgPath, Reg)
% Extract local features, frames, and their patches.
%
% Input
%   filePathName   -  image path
%   bShowFeat      -  flag of showing figure, 0 | 1
%
% Output  
%   featInfo
%     img   -  image, h x w
%     feat  -  feature, num x 7 
%              each row of feat contains [x y a b c orientation scale]
%     typeFeat
%     shscMatrix(featIdx, :)
%     affMatrix(featIdx, :)
%     patch(featIdx)
%     desc
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-30-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 01-01-2012

% debug
isDeb = 0;

% read image
featInfo.img = imread(imgPath);

% feature detect
tmpFeat = Reg;
nTmpFeat = size(tmpFeat, 1);
disp(size(tmpFeat));
[tmpFeat, nTmpFeat] = purifyFeat(tmpFeat, nTmpFeat);
disp(size(tmpFeat));

featInfo.feat = tmpFeat;
featInfo.typeFeat = ones(nTmpFeat, 1);
featInfo.nFeat = nTmpFeat

%s acquire region patches and descriptors from the features
fprintf('-- Extracting feature regions from image\n');
nMaxOri = 1; % 3
featureScale = 2.0;
patchSize = 31; 
[featIdx, feat_aug, tmpOri, shscMatrix, affMatrix] = compute_norm_trans_image(featInfo.feat, featInfo.img, featureScale, patchSize, nMaxOri);

% reinitialize feat information
featInfo.featIdx = featIdx;
featInfo.feat = [feat_aug, tmpOri];
featInfo.shscMatrix = shscMatrix;
featInfo.affMatrix = affMatrix;
featInfo.typeFeat = featInfo.typeFeat(featIdx);

% obtain local patches using the features
featInfo.patch = cell(length(featIdx), 1);
bOutOfImage = zeros(length(featIdx), 1);
for j = 1 : length(featIdx)
    [featInfo.patch{j}, bOutOfImage(j)] = normalize_patchCMEX2(featInfo.img, affMatrix(j, :), featureScale, patchSize);
end

% delete features which are out of the image
delIdx = find(bOutOfImage);
featInfo.typeFeat(delIdx) = [];
featInfo.featIdx(delIdx) = [];
featInfo.feat(delIdx, :) = [];
featInfo.shscMatrix(delIdx, :) = [];
featInfo.affMatrix(delIdx, :) = [];
featInfo.patch(delIdx) = [];
featInfo.nFeat = size(featInfo.feat, 1);
fprintf('   %d normalized regions are extracted from image %s\n', featInfo.nFeat, imgPath);

% make descriptors for features
tmpDet = zeros(featInfo.nFeat, 1);
featInfo.desc = zeros(featInfo.nFeat, 128);       % initial sift descriptor. all 0.

for j = 1 : featInfo.nFeat
    tmpDet(j) = det([featInfo.affMatrix(j, [1 2]); featInfo.affMatrix(j, [4 5])]);
    featInfo.desc(j, :) = gensiftdesc(featInfo.patch{j})';
end

featInfo.feat = [featInfo.feat tmpDet];
