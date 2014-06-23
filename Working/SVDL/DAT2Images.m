% read the vector in DAT and convert it back to images

function DAT2Images(numberImages) 

%clear all;
%clc;
%addpath utilities;
%addpath src;

session = 4;
loadPath = strcat('SVDL/database/session',num2str(session),'_05_1_netural_all');
load(loadPath);
DAT = double(DAT);
for i = 1:numberImages
    imgData = DAT(:,i);
    imgMAT = reshape(imgData,100,82);
    IMG{i} = mat2gray(imgMAT);
    %figure;
    %imshow(IMG{i});    i
    destDir = strcat('../DataRetrieved/session', num2str(session), '/');
    if not(exist(destDir))
        disp('session folder does not exist');
        mkdir(destDir);
    end
    imwrite(IMG{i},[strcat(destDir,'face', sprintf('%04d',i)) '.png'],'png');
end

