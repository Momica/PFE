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
landmarkDir='../DataRetrieved/session1/landmarksFace.txt';
%foundNotFoundDir='features/indexingFoundNotFound.txt';
fLandmark=fopen(landmarkDir,'r');
        fid = fopen('../DataRetrieved/session1/landmarksFaceBlock.txt','w');   % Open destination file.

%fFound=fopen(foundNotFoundDir,'r');
%tLine=fgetl(fLandmark);
%disp(tLine);
%tFound=fgetl(fFound);
%disp(tFound);
fullMatrixFeaturesRightEye = [];
fullMatrixFeaturesLeftEye = [];
fullMatrixFeaturesNose = [];
fullMatrixFeaturesBetweenEye = [];
fullMatrixEyeBrowRight = [];
fullMatrixEyeBrowLeft = [];
fullMatrixFeaturesNoseRight = [];
fullMatrixFeaturesNoseLeft = [];
fullMatrixFeaturesMouseRight = [];
fullMatrixFeaturesMouseLeft = [];

%fea=zeros(34515,9871);
idImage=0;
count = 0;
for i=1:4980    
    count = count +1;
    disp('count');
    disp(count);
    test = rem(count-8,20);
    if test == 0
        disp('test egal 0');
        buffer = fgetl(fLandmark);
    else         
        %fclose(fLandmark);
        %fLandmark=fopen(landmarkDir,'r');
        buffer = fgetl(fLandmark);
        fprintf(fid,'%s\n', buffer);                         % Save to file.
        
    end
    %tLine=fgetl(fLandmark);
  
end
fclose(fid);

        