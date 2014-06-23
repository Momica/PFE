% goal : read features and return a full matrix containing all of them as
% vectors
clc;
clear all;
close all;

numberOfPerson = 249;
numberOfPicturesPerPerson = 20;
numberOfFeaturesPerPerson = 4;

pathToFeatures = './features';

for idPerson=1:numberOfPerson 
    pathToPersonFolder = strcat(pathToFeatures,'/',sprintf('%03d',idPerson));
    for idPicture=1:numberOfPicturesPerPerson
        pathToPictureFolder = strcat(pathToPersonFolder,'/',sprintf('%04d',idPicture));
        for idFeatures=1:numberOfFeaturesPerPerson
            pathToFeature = strcat(pathToPictureFolder,'/',sprintf('%03d',idPerson),'_',sprintf('%04d',idPicture),'_',sprintf('%02d',idFeatures),'.png');
            disp(pathToFeature);
            currentImage = imread(pathToFeature);
            disp(size(currentImage));
            %disp(height(currentImage));
            %currentImageReshape = reshape(currentImage,he
        end
    end
end
