% read the vector in DAT and convert it back to images

function DAT2ImagesBlock(numberImages,session,folderName,data,sizeX,sizeY) 

%clear all;
%clc;
%addpath utilities;
%addpath src;

% loadPath = strcat('./database/session',num2str(session),'_05_1_netural_all');
% load(loadPath);
DAT = double(data);
interval = 0;
step = 8;
for i = 1:numberImages
    %test = rem((i-8),20);
    test = i;
    if test == step
        interval = interval + 1;
        step = step + 19;
    end   
    imgData = DAT(:,i);
    imgMAT = reshape(imgData,sizeY,sizeX);
    IMG{i} = mat2gray(imgMAT);
    %figure;
    %imshow(IMG{i});    
    destDir = strcat('../DataRetrieved/session', num2str(session), '/',folderName);
    if not(exist(destDir))
        disp(' folder does not exist, creating...');
        mkdir(destDir);
    end
    imwrite(IMG{i},[strcat(destDir,'face', sprintf('%04d',i+interval)) '.png'],'png');
end

