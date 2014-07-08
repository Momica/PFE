% goal : read feature coordinnates and extract them normalized
function mainLBP(algparam)
clc;

close all;

% set the mean face for the normalization
idimage_name = 'dictionary/idimage200'; % modify here if you want an other mean face
load(idimage_name);  % id database info
meanface = idimage.meanface;
addpath('meanface');  % Add the folder "meanface" to the path 
% LBP SETTING
addpath('lbp');       %lbp
mapping = getmapping(8,'u2'); 
mode = 'h';
fd = mapping.num;


%mapping = getmapping(8,'u2'); 
mode = 'h';
%imread('features/images/001/001_03_01_041_00.png');
%keyboard;
landmarkDir='../DataRetrieved/session4/landmarksFace.txt';
%foundNotFoundDir='features/indexingFoundNotFound.txt';
subjectDir='../DataRetrieved/session4/full_face';
fLandmark=fopen(landmarkDir,'r');
%fFound=fopen(foundNotFoundDir,'r');
tLine=fgetl(fLandmark);
disp(tLine);
%tFound=fgetl(fFound);
%disp(tFound);
fullMatrixFeaturesRightEyeLBP = [];
fullMatrixFeaturesLeftEyeLBP = [];
fullMatrixFeaturesNoseLBP = [];
fullMatrixFeaturesMouseRightLBP = [];
fullMatrixFeaturesMouseLeftLBP = [];

%fea=zeros(34515,9871);
idImage=0;
while tLine~=-1
    close all;
    parts=regexp(tLine,' ','split');
    idImage = str2double(parts{2});
    personID = parts{4};
    foundStatus=parts{6};
    disp(foundStatus);
    if str2double(foundStatus) == 0
        disp('not found');
        tLine=fgetl(fLandmark);
        %tFound=fgetl(fFound);
        continue
    end
    disp('found');  
    feaName = strcat('face', sprintf('%04d',idImage),'.png'); % a revoir peut être 
    %disp(imageName);
    picPath=fullfile(subjectDir,feaName);
    %disp(picDir);
    %disp(exist(picDir));
    if not(exist(picPath))
        disp('pictures directory does not exist');  % cela ne sert peut être à rien ...
        mkdir(picPath);
    end
    
    %create a destination directory per person
    personDestDir = strcat('../DataRetrieved/session4/featuresLBP/',personID); %sprintf('%03d',fix((idImage-1)/20)+1));
    disp(personDestDir);
    if not(exist(personDestDir))
        disp('person folder does not exist');
        mkdir(personDestDir);
    end
    
    % create key features directory / Each pictures correspond to a folder
    % containing all his extract features
    keyFeaturesDir = strcat(personDestDir,'/',sprintf('%04d',idImage));
    if not(exist(keyFeaturesDir))
        disp('key features folder does not exist');
        mkdir(keyFeaturesDir);
    end
    
    
    pic=imread(picPath);
        
%     if ndims(pic) == 3
%         pic = rgb2gray(pic);
%     end
    %imshow(pic);
    
    
    
    picLandmark=str2double(parts(7:end));  % ATTENTION remplacer 11 par end normalement ( je fais ça car il y a un espace de trop à la fin de chaque ligne de landmarksFace.txt, donc je me retrouve avec une parts{1,12} qui contient un espace à la fin
%     [npic,npicLandmark] = normalize_face(pic,picLandmark,meanface);%*1.2
%     npicLandmark = round(npicLandmark);
%     disp(npicLandmark);
    imFeaLBP = FaceFeaLBP(pic,picLandmark,algparam,meanface,mapping,mode);
    fullMatrixFeaturesRightEyeLBP(:,idImage)=imFeaLBP ;
    %nombre de key point
    %on parcourt les keypoints
    
        % UNCOMMENT if you want to display the key features
%         figure;   
%         imshow(imfea);
%         feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',i),'.png');
%         disp(feaName);
%         imwrite(imfea,feaName);

    
    
    
    
%     algparam.norml=0;
%     algparam.patchSize=10;
%     algparam.patchMesh=[7 5];
%     algparam.centered=0;
%     algparam.scale=1;
%     imfea = FaceFea(pic,picLandmark,algparam,meanface,mapping,mode);
%     close;
%     count=count+1;
%     fea(:,count)=imfea;

    tLine=fgetl(fLandmark);
    %tFound=fgetl(fFound);
    %disp(tLine);
end
%save('Images\EncodingImagesData\feaMetrix.mat','fea');

function imfea = FaceFeaLBP(im,landmark,algparam,meanface,mapping,mode)

patchSize = algparam.patchSize;
patchMesh = algparam.patchMesh;
centered = algparam.centered;
scale = algparam.scale;
olp = algparam.olp;
% 
%   figure,imshow(im);
%   hold on,scatter(landmark(1:2:end),landmark(2:2:end),'*','r'); 
    
[nim,nlandmark] = normalize_face(im,landmark,meanface);%*1.2
nlandmark = round(nlandmark);

%     H = fspecial('gaussian',5,1);
%     nim = imfilter(nim,H);

%     figure,imshow(nim);
%     hold on,scatter(nlandmark(1:2:end),nlandmark(2:2:end),'*','y'); 

imfea = [];
for s = 1:length(scale)
    tnim = imresize(nim,scale(s));
    tnlandmark = round(nlandmark*scale(s));

    if centered == 1
        patchFea = get_face_feature_s(tnim,tnlandmark,mapping,mode,patchMesh,patchSize);
    else
        patchFea = get_face_feature(tnim,tnlandmark,mapping,mode,patchMesh,patchSize,olp);
    end

    imfea = [imfea; patchFea];%      
end
imfea = reshape(imfea',size(imfea,1)*size(imfea,2),1);

