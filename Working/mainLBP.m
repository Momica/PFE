% goal : read feature coordinnates and extract them normalized
function mainLBP(algparam, sizeWantedForOneFeature)
clc;

close all;
tic();
addpath ./SVDL/utilities;
addpath ./SVDL/src;
addpath ./SVDL;
%setting parameter
parameters.pro_sign          =   100;        
parameters.par.nDim          =   90;
parameters.lambda            =   0.001;      %test lambda
parameters.lambda1           =   0.001;
parameters.lambda2           =   0.01;
parameters.lambda3           =   1e-4;
parameters.dnum              =   400;
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
dividerLBP = sizeWantedForOneFeature;


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
fullMatrixFeaturesLBP = [];
fullMatrixFeaturesLBPTest = [];
load('./SVDL/database/session1_05_1_netural_all');


featureName = '../DataRetrieved/session1/featuresSession1LBP.mat';

if exist(featureName) == 2
    disp('Features LBP already exist. Loading features LBP');
    load(featureName);
    %dico = fieldnames(dicoStructure);
else

    %fea=zeros(34515,9871);
    idImage=0;
    while tLine~=-1
        close all;
        parts=regexp(tLine,' ','split');
        idImage = str2double(parts{2});
        disp(idImage);
        personID = parts{4};
        foundStatus=parts{6};
        %disp(foundStatus);
        if str2double(foundStatus) == 0
            disp('not found');
            tLine=fgetl(fLandmark);
            %tFound=fgetl(fFound);
            continue
        end
        %disp('found');  
        feaName = strcat('face', sprintf('%04d',idImage),'.png'); % a revoir peut être 
        %disp(imageName);
        picPath=fullfile(subjectDir,feaName);
        %disp(picDir);
        %disp(exist(picDir));
%         if not(exist(picPath))
%             disp('pictures directory does not exist');  % cela ne sert peut être à rien ...
%             mkdir(picPath);
%         end

%         %create a destination directory per person
%         personDestDir = strcat('../DataRetrieved/session4/featuresLBP/',personID); %sprintf('%03d',fix((idImage-1)/20)+1));
%         %disp(personDestDir);
%         if not(exist(personDestDir))
%             disp('person folder does not exist');
%             mkdir(personDestDir);
%         end
% 
%         % create key features directory / Each pictures correspond to a folder
%         % containing all his extract features
%         keyFeaturesDir = strcat(personDestDir,'/',sprintf('%04d',idImage));
%         if not(exist(keyFeaturesDir))
%             disp('key features folder does not exist');
%             mkdir(keyFeaturesDir);
%         end


        pic=imread(picPath);

        picLandmark=str2double(parts(7:end));  % ATTENTION remplacer 11 par end normalement ( je fais ça car il y a un espace de trop à la fin de chaque ligne de landmarksFace.txt, donc je me retrouve avec une parts{1,12} qui contient un espace à la fin
        imFeaLBP = FaceFeaLBP(pic,picLandmark,algparam,meanface,mapping,mode);
        fullMatrixFeaturesLBP(:,idImage)=imFeaLBP;
        tLine=fgetl(fLandmark);
    end
    save(featureName,'fullMatrixFeaturesLBP');
    %save('Images\EncodingImagesData\feaMetrix.mat','fea');
end
fclose(fLandmark);

sizeFullVectorLBP = size(fullMatrixFeaturesLBP);
sizeFeature = sizeFullVectorLBP(1)/dividerLBP;
numberOfImage = sizeFullVectorLBP(2);

%dicosName = '../DataRetrieved/session1/20featuresSession1LBPDicos.mat';
dicosName = strcat('../DataRetrieved/session1/',int2str(dividerLBP),'featuresSession1LBPDicos.mat');
disp(dicosName);
if exist(dicosName) == 2
    disp('Dico LBP already exist. Loading features LBP');
    load(dicosName);
    %dico = fieldnames(dicoStructure);
else
    for n=1:dividerLBP
        % Generate SVDL on current feature
        currentFeature = fullMatrixFeaturesLBP((n-1)*sizeFeature+1:n*sizeFeature,:);
        currentFeature = double(currentFeature);
        [dict_v,er,disc_set,tr_dat,trls] = generateSparseDictionnary(currentFeature,parameters);
        weight = 1;
        % We save the data, to speed next use based on the same set
        newDico = struct('dict_v',dict_v,'disc_set',disc_set,'er',er,'tr_dat',tr_dat,'trls',trls,'weight',weight);
        dicos{n} = newDico;
    end
    save(dicosName,'dicos');
end



% TEST DATA
featureName = '../DataRetrieved/session4/featuresSession4LBP.mat';
landmarkDir='../DataRetrieved/session4/landmarksFace.txt';
%foundNotFoundDir='features/indexingFoundNotFound.txt';
subjectDir='../DataRetrieved/session4/full_face';
fLandmark=fopen(landmarkDir,'r');
%fFound=fopen(foundNotFoundDir,'r');
tLine=fgetl(fLandmark);
disp(tLine);

if exist(featureName) == 2
    disp('Features LBP already exist. Loading features LBP');
    load(featureName);
    %dico = fieldnames(dicoStructure);
else

    %fea=zeros(34515,9871);
    idImage=0;
    while tLine~=-1
        close all;
        parts=regexp(tLine,' ','split');
        idImage = str2double(parts{2});
        disp(idImage);
        personID = parts{4};
        foundStatus=parts{6};
        %disp(foundStatus);
        if str2double(foundStatus) == 0
            disp('not found');
            tLine=fgetl(fLandmark);
            %tFound=fgetl(fFound);
            continue
        end
        %disp('found');  
        feaName = strcat('face', sprintf('%04d',idImage),'.png'); % a revoir peut être 
        %disp(imageName);
        picPath=fullfile(subjectDir,feaName);
        pic=imread(picPath);

        picLandmark=str2double(parts(7:end));  % ATTENTION remplacer 11 par end normalement ( je fais ça car il y a un espace de trop à la fin de chaque ligne de landmarksFace.txt, donc je me retrouve avec une parts{1,12} qui contient un espace à la fin
        imFeaLBP = FaceFeaLBP(pic,picLandmark,algparam,meanface,mapping,mode);
        fullMatrixFeaturesLBPTest(:,idImage)=imFeaLBP;
        tLine=fgetl(fLandmark);
    end
    keyboard;
    save(featureName,'fullMatrixFeaturesLBPTest');
    %save('Images\EncodingImagesData\feaMetrix.mat','fea');
end
fclose(fLandmark);

sizeFullVectorLBP = size(fullMatrixFeaturesLBPTest);
sizeFeature = sizeFullVectorLBP(1)/dividerLBP;
numberOfImage = sizeFullVectorLBP(2);


labels(labels>213) = labels(labels>213) -1; % there is no data with label 213, so we shift the label
for n=1:dividerLBP % remplacer 20 par une varialble à terme
    currentTestFeature = fullMatrixFeaturesLBPTest((n-1)*sizeFeature+1:n*sizeFeature,:);
    currentTestFeature = double(currentTestFeature);
    
    my_tt_dat{n} = currentTestFeature;
    ttls   = labels;
    my_tt_dat{n} = my_tt_dat{n}(:,ttls<parameters.pro_sign);
    ttls   = ttls(:,ttls<parameters.pro_sign);
    my_tt_dat{n}  = dicos{1,n}.disc_set'*my_tt_dat{n};
end
% testFeatures = fieldnames(testFeaturesStructure.savingResult);
% 
% for n = 1:length(testFeatures)
% %     currentTestFeature = testFeaturesStructure.savingResult.(testFeatures{n});
% %     currentTestFeature = double(currentTestFeature);
% %     
%     
%     my_tt_dat{n} = currentTestFeature;
%     ttls   = labels;
%     my_tt_dat{n} = my_tt_dat{n}(:,ttls<parameters.pro_sign);
%     ttls   = ttls(:,ttls<parameters.pro_sign);
%     my_tt_dat{n}  = dicos{1,n}.disc_set'*my_tt_dat{n};
% end

for n = 1:dividerLBP
%     currentdicos{1,1} = dicos{1,n};
%     current_tt_dat = my_tt_dat{n};
%     Train_M = [dicos{1,n}.tr_dat dicos{1,n}.dict_v];
%     correct_rate = Fun_ESRC_gaps(Train_M,dicos{1,n}.trls, current_tt_dat,ttls,parameters.lambda);
    currentdicos{1,1} = dicos{1,n};
    current_tt_dat{1} = my_tt_dat{n};
    correct_rate = Fun_ESRC_gaps(currentdicos,current_tt_dat,ttls,parameters.lambda);
    %fid = fopen(['result/demo_result_' par.nameDatabase '.txt'],'a');
    %fid = fopen(['result/demo_result.txt'],'a');
    %fprintf(fid,'\n%s\n','========================================');
    %fprintf(fid,'%s%8f%s%8f%s%8f\n','lambda1 = ',parameters.lambda1,'lambda2 = ',parameters.lambda2,' lambda3= ',parameters.lambda3);
    %fprintf(fid,'%s%8f%s%8f%s%8f\n','weight 1 = ',dicos{1,1}.weight,'weight 2 = ',dicos{1,2}.weight,' weight 3= ',dicos{1,3}.weight);
    %fprintf(fid,'%s%8f%s%8f\n','nDim = ',parameters.par.nDim,' lambda= ',parameters.lambda);
    dicos{1,n}.weight = correct_rate;
    %fclose(fid);
end
keyboard;
correct_rate = Fun_ESRC_gaps(dicos,my_tt_dat,ttls,parameters.lambda);
keyboard;
resultFileName = strcat('./SVDL/result/demo_result_LBP_',int2str(dividerLBP),'.txt');
disp(resultFileName);
fid = fopen([resultFileName],'a');
for n = 1:dividerLBP
    fprintf(fid,'%s%8f%s%8f\n','weight ',n,' = ', dicos{1,n}.weight);
end
fprintf(fid,'%s%8f\n','reco_rate1 = ',correct_rate);
fclose(fid);
toc();



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

