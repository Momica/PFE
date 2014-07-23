% goal : read feature coordinnates and crop them normalized
clc;
clear all;
close all;

% set the mean face for the normalization
idimage_name = 'dictionary/idimage200'; % modify here if you want an other mean face
load(idimage_name);  % id database info
meanface = idimage.meanface;
addpath('meanface');  % Add the folder "meanface" to the path 

%mapping = getmapping(8,'u2'); 
mode = 'h';
%imread('features/images/001/001_03_01_041_00.png');
%keyboard;
landmarkDir='../DataRetrieved/session1/landmarksFace.txt';
%foundNotFoundDir='features/indexingFoundNotFound.txt';
subjectDir='../DataRetrieved/session1/full_face';
fLandmark=fopen(landmarkDir,'r');
%fFound=fopen(foundNotFoundDir,'r');
tLine=fgetl(fLandmark);
disp(tLine);
%tFound=fgetl(fFound);
%disp(tFound);
fullMatrixFeatures = [];


%fea=zeros(34515,9871);
idImage=0;
while tLine~=-1
    close all;
    disp('hello');
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
    personDestDir = strcat('../DataRetrieved/session1/GRIDfeatures/',personID); %sprintf('%03d',fix((idImage-1)/20)+1));
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
    [npic,npicLandmark] = normalize_face(pic,picLandmark,meanface);%*1.2
    npicLandmark = round(npicLandmark);
    disp(npicLandmark);
    
    %nombre de key point
    disp(length(npicLandmark));
    landmarknum = length(npicLandmark)/2;
    %on parcourt les keypoints
    numberX = 5;
    numberY = 5;
    sizeFeatureX = 25;
    sizeFeatureY = 31;
    marge = 2;
    for i=1:numberX
        for j=1:numberY
            disp(i);
            disp(j);
            testI = ((i-1)*sizeFeatureX);
            if testI == 0
                testI = 1;
            end
            testJ = ((j-1)*sizeFeatureY);
            if testJ == 0
                testJ =1;
            end
            imfea = imcrop(npic,[testI+marge testJ+marge sizeFeatureX sizeFeatureY]);
            sizeFea = size(imfea);
            display(sizeFea);
            imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
            fullMatrixFeatures{((i-1)*(numberY))+j}(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
            feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',((i-1)*(numberY))+j),'.png');
            disp(feaName);
            imwrite(imfea,feaName);
        end
    end


    tLine=fgetl(fLandmark);
    %tFound=fgetl(fFound);
    %disp(tLine);
end
%newFeatures = struct('fullMatrixEyeBrowLeft',fullMatrixEyeBrowLeft,'fullMatrixEyeBrowRight',fullMatrixEyeBrowRight,'fullMatrixFeaturesBetweenEye',fullMatrixFeaturesBetweenEye,'fullMatrixFeaturesCheekLeftDown',fullMatrixFeaturesCheekLeftDown,'fullMatrixFeaturesCheekLeftUpper',fullMatrixFeaturesCheekLeftUpper,'fullMatrixFeaturesCheekRightDown',fullMatrixFeaturesCheekRightDown,'fullMatrixFeaturesCheekRightUpper',fullMatrixFeaturesCheekRightUpper,'fullMatrixFeaturesChin',fullMatrixFeaturesChin,'fullMatrixFeaturesFrontHeadCenter',fullMatrixFeaturesFrontHeadCenter,'fullMatrixFeaturesFrontHeadLeft',fullMatrixFeaturesFrontHeadLeft,'fullMatrixFeaturesFrontHeadRight',fullMatrixFeaturesFrontHeadRight,'fullMatrixFeaturesLeftEye',fullMatrixFeaturesLeftEye,'fullMatrixFeaturesMouseCenter',fullMatrixFeaturesMouseCenter,'fullMatrixFeaturesMouseLeft',fullMatrixFeaturesMouseLeft,'fullMatrixFeaturesMouseRight',fullMatrixFeaturesMouseRight,'fullMatrixFeaturesNose',fullMatrixFeaturesNose,'fullMatrixFeaturesNoseLeft',fullMatrixFeaturesNoseLeft,'fullMatrixFeaturesNoseRight',fullMatrixFeaturesNoseRight,'fullMatrixFeaturesRightEye',fullMatrixFeaturesRightEye);
newFeaturesName = '../DataRetrieved/session1/GRIDfeaturesSession1.mat';
for i=1:5
    for j=1:7
        newfeature = fullMatrixFeatures{((i-1)*(numberY))+j};
        save(newFeaturesName,'newfeature');
    end
end
        %save('Images\EncodingImagesData\feaMetrix.mat','fea');


