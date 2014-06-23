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
landmarkDir='features/landmarksFace.txt';
subjectDir='features/images';
fLandmark=fopen(landmarkDir,'r');
tLine=fgetl(fLandmark);
disp(tLine);

%fea=zeros(34515,9871);
count=0;
while tLine~=-1
    parts=regexp(tLine,' ','split');
    picDir=fullfile(subjectDir,parts{1});
    disp(picDir);
    disp(exist(picDir));
    if not(exist(picDir))
        disp('folder does not exist');
        mkdir(picDir);
    end
    
    pic=imread(picDir);
        
    if ndims(pic) == 3
        pic = rgb2gray(pic);
    end

    
    picLandmark=str2double(parts(2:end));
    [npic,npicLandmark] = normalize_face(pic,picLandmark,meanface);%*1.2
    npicLandmark = round(npicLandmark);
    disp(npicLandmark);
    
    %nombre de key point
    landmarknum = length(npicLandmark)/2;
    %on parcourt les keypoints
    for i = 1:landmarknum
    
        imfea = imcrop(npic,[npicLandmark(2*i-1)-15 npicLandmark(2*i)-15 30 30]);
        figure;
        imshow(imfea)
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
    disp(tLine);
end
%save('Images\EncodingImagesData\feaMetrix.mat','fea');


