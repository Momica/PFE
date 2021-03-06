% goal : read feature coordinnates and extract them normalized
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
landmarkDir='../DataRetrieved/session4/landmarksFace.txt';
%foundNotFoundDir='features/indexingFoundNotFound.txt';
subjectDir='../DataRetrieved/session4/full_face';
fLandmark=fopen(landmarkDir,'r');
%fFound=fopen(foundNotFoundDir,'r');
tLine=fgetl(fLandmark);
disp(tLine);
%tFound=fgetl(fFound);
%disp(tFound);
fullMatrixFeaturesRightEye = [];
fullMatrixFeaturesLeftEye = [];
fullMatrixFeaturesNose = [];
fullMatrixFeaturesMouse = [];

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
    feaName = strcat('face', sprintf('%04d',idImage),'.png'); % a revoir peut �tre 
    %disp(imageName);
    picPath=fullfile(subjectDir,feaName);
    %disp(picDir);
    %disp(exist(picDir));
    if not(exist(picPath))
        disp('pictures directory does not exist');  % cela ne sert peut �tre � rien ...
        mkdir(picPath);
    end
    
    %create a destination directory per person
    personDestDir = strcat('../DataRetrieved/session4/features/',personID); %sprintf('%03d',fix((idImage-1)/20)+1));
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
    
    
    
    picLandmark=str2double(parts(7:end));  % ATTENTION remplacer 11 par end normalement ( je fais �a car il y a un espace de trop � la fin de chaque ligne de landmarksFace.txt, donc je me retrouve avec une parts{1,12} qui contient un espace � la fin
    [npic,npicLandmark] = normalize_face(pic,picLandmark,meanface);%*1.2
    npicLandmark = round(npicLandmark);
    disp(npicLandmark);
    
    %nombre de key point
    disp(length(npicLandmark));
    landmarknum = length(npicLandmark)/2;
    %on parcourt les keypoints
    for i = 1:landmarknum
        disp('boucle for');
        %imfea = imcrop(npic,[npicLandmark(2*i-1)-15 npicLandmark(2*i)-15 30 30]);
        if i == 1
            imfea = imcrop(npic,[npicLandmark(2*i-1)-20 npicLandmark(2*i)-25 50 50]);
            sizeFea = size(imfea);
            imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
            fullMatrixFeaturesRightEye(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
        end
        if i == 2
            imfea = imcrop(npic,[npicLandmark(2*i-1)-25 npicLandmark(2*i)-25 50 50]);
            sizeFea = size(imfea);
            imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
            fullMatrixFeaturesLeftEye(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
        end
        if i == 3
            imfea = imcrop(npic,[npicLandmark(2*i-1)-25 npicLandmark(2*i)-40 50 65]);
            sizeFea = size(imfea);
            imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
            fullMatrixFeaturesNose(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
        end
        if i == 4
            % UNCOMMENT if you want perfect features extraction around the
            % mouse, but the problem is that it will then produce different
            % features size and then it will be tough to compare them
%             lengthMouse = npicLandmark((2*(i+1))-1) - npicLandmark((2*i)-1);
%             heightMouse = npicLandmark((2*(i+1))) - npicLandmark((2*i));
%             disp(lengthMouse);
%             imfea = imcrop(npic,[(npicLandmark(2*i-1))-15 (npicLandmark(2*i))-15 lengthMouse+30 heightMouse+30]); % ATTENTION ici il faudra utiliser un autre cropping
            imfea = imcrop(npic,[(npicLandmark(2*i-1))-15 (npicLandmark(2*i))-20 100 35]);
            sizeFea = size(imfea);
            imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
            fullMatrixFeaturesMouse(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
        end
        if i == 5
            %imfea = imcrop(npic,[npicLandmark(2*i-1)-15 npicLandmark(2*i)-15 30 30]);
            continue;
        end
        % UNCOMMENT if you want to display the key features
%         figure;   
%         imshow(imfea);
        feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',i),'.png');
        disp(feaName);
        imwrite(imfea,feaName);
    end
    
    
    
    
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


