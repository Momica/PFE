% read the vector in DAT and convert it back to images

function DAT2Images(numberImages,session,folderName,tt_dat,sizeX,sizeY) 

%clear all;
%clc;
%addpath utilities;
%addpath src;

% loadPath = strcat('./database/session',num2str(session),'_05_1_netural_all');
% load(loadPath);
DAT = double(tt_dat);
secondInterval = 0;
for i = 1:numberImages
    imgData = DAT(:,i);
    imgMAT = reshape(imgData,sizeY,sizeX);
    IMG{i} = mat2gray(imgMAT);
    %figure;
    %imshow(IMG{i});    i
    destDir = strcat('../DataRetrieved/session', num2str(session), '/',folderName);
    if not(exist(destDir))
        disp(' folder does not exist, creating...');
        mkdir(destDir);
    end
    imwrite(IMG{i},[strcat(destDir,'face', sprintf('%04d',i)) '.png'],'png');
end

