% goal : read feature coordinnates and extract them normalized
clc;
clear all;
close all;

%mode = 'h';

myFile='features/Copy_of_landmarksFace.txt';
newFile=fopen('features/new.txt','w');
fLandmark=fopen(myFile,'r');
tLine=fgetl(fLandmark);
disp(tLine);

while tLine~=-1

    parts=regexp(tLine,' ','split');

    fprintf(newFile,'%f %f %f %f %f %f %f %f %f %f %f\n',parts{1,1},parts{1,2},parts{1,3},parts{1,4},parts{1,5},parts{1,6},parts{1,7},parts{1,8},parts{1,9},parts{1,10},parts{1,11});

    
    tLine=fgetl(fLandmark);
end
%save('Images\EncodingImagesData\feaMetrix.mat','fea');


