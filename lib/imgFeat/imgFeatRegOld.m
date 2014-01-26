function Feat = imgFeatDect(imgPath, alg, param)
% Image feature detection.
%
% Input
%   imgPath  -  path of image file
%   alg      -  algorithm for feature detector, 'mser' | 'sift'
%   param    -  parameter (can be [])
%            
% Output     
%   Feat     -  feature, num x dim
%            
% History    
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-30-2011
%   modify   -  Feng Zhou (zhfe99@gmail.com), 12-31-2011

prIn('imgFeatDect', 'alg %s', alg);

% specified in addPath.m
global footpath;

% binary file
binfold = sprintf('%s/lib/imgFeat/bin', footpath);

% output file
[imgFold, imgName] = fileparts(imgPath);
outPath = sprintf('%s/%s_%s_feat.out', imgFold, imgName, alg); 

% MSER
if strcmp(alg, 'mser')

    % defualt parameter for MSER features
    if ~exist('param', 'var') || isempty(param)
        param.MSER_Ellipse_Scale = 1.0;
        param.MSER_Maximum_Relative_Area = 0.010;
        param.MSER_Minimum_Size_Of_Output_Region = 30;
        param.MSER_Minimum_Margin = 10;
        param.MSER_Use_Relative_Margins = 0;
        param.MSER_Vervose_Output = 0;
    end

    opt = sprintf('-t 2 -es %f -per %f -ms %d -mm %d -i "%s" -o "%s"', ...
                  param.MSER_Ellipse_Scale, param.MSER_Maximum_Relative_Area, ...
                  param.MSER_Minimum_Size_Of_Output_Region, param.MSER_Minimum_Margin, ...
                  imgPath, outPath);

    % for Windows
    if strncmp(computer, 'PC', 2)
        exec_str = ['"' binfold '/mser.exe"'];

    % for Linux
    elseif strcmp(computer, 'GLNX86') || strcmp(computer, 'GLNXA64')
        exec_str = [binfold '/mser.ln'];

    % for Mac
    elseif strcmp(computer, 'MACI64')
        pr('use MSER on Mac');
        
    else
        error('This function can run only with MS Windows or Linux');
    end

% SIFT        
elseif strcmp(alg, 'sift')
    % load image
    image = imread(inname);
    if size(image, 3) > 1
        image = rgb2gray(image);
    end
    [rows, cols] = size(image); 
      
    % convert into PGM imagefile, readable by "keypoints" executable
    f = fopen('tmp.pgm', 'w');
    if f == -1
        error('Could not create file tmp.pgm');
    end
    
    fprintf(f, 'P5\n%d\n%d\n255\n', cols, rows);
    fwrite(f, image', 'uint8');
    fclose(f);
    fprintf('-- Detecting SIFT LOG features from %s\n',file);
    
    opt = sprintf('<tmp.pgm >"%s"', outname);
    if strncmp(computer,'PC',2) % MS Windows
        exec_str = ['"' fpath '/detectors/siftWin32"'];
        
    elseif strcmp(computer,'GLNX86') % Linux
        exec_str = [fpath '/detectors/sift'];
        
    else 
        error('This function can run only with MS Windows or Linux');
    end

else
    error('unknown feature detector: %s', alg);
end
        
% call the binary executable
if ~strcmp(computer, 'MACI64')
    result = unix([exec_str  ' ' opt]);
end

% load the output file
fid = fopen(outPath, 'r');
if fid == -1
    error('fild %s does not exist', outPath);
end

if strcmp(alg, 'sift')
    [header, count] = fscanf(fid, '%d %d', [1 2]);
    if count ~= 2
        error('Invalid keypoint file beginning.');
    end
    num = header(1);
    len = header(2);
    if len ~= 128
        error('Keypoint descriptor length invalid (should be 128).');
    end

    % Creates the two output matrices (use known size for efficiency)
    %locs = double(zeros(num, 4));
    %descriptors = double(zeros(num, 128));
    feat = zeros(num, 5);
    % Parse tmp.key
    for i = 1 : num
        [vector, count] = fscanf(fid, '%f %f %f %f', [1 4]); %row col scale ori
        if count ~= 4
            error('Invalid keypoint file format');
        end
        % convert the params into elliptical representation
        feat(i, 1) = vector(1, 2);
        feat(i, 2) = vector(1, 1);
        feat(i, 3) = 0.05 / vector(1, 3) ^ 2; % adequate param: 0.05 & x2 or 0.03 & x1.5
        feat(i, 4) = 0;
        feat(i, 5) = 0.05 / vector(1, 3) ^ 2;

        [descrip, count] = fscanf(fid, '%d', [1 len]);
        if (count ~= 128)
            error('Invalid keypoint file value.');
        end
        
        % Normalize each input vector to unit length
        %descrip = descrip / sqrt(sum(descrip.^2));
        %descriptors(i, :) = descrip(1, :);
    end
    
elseif strcmp(alg, 'mser')
    header = fscanf(fid, '%f',1);
    num = fscanf(fid, '%d', 1);
    Feat = fscanf(fid, '%f', [5, inf]);
    Feat = Feat';
    
else
    error('unknown feature detector: %s', alg);    
end
fclose(fid);

prOut;
