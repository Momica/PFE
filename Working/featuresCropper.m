% goal : read feature coordinnates and extract them normalized
function featuresCropper (landmarkTxt,subjectDir,destinationDir,nameForSavingResult)

    % set the mean face for the normalization
    idimage_name = 'dictionary/idimage200'; % modify here if you want an other mean face
    load(idimage_name);  % id database info
    meanface = idimage.meanface;
    addpath('meanface');  % Add the folder "meanface" to the path 
    addpath('../');
    %mapping = getmapping(8,'u2'); 
    mode = 'h';
    %imread('features/images/001/001_03_01_041_00.png');
    %keyboard;
    %landmarkTxt='../DataRetrieved/session4/landmarksFace.txt';
    %foundNotFoundDir='features/indexingFoundNotFound.txt';
    %subjectDir='../DataRetrieved/session4/full_face';
    fLandmark=fopen(landmarkTxt,'r');
    %fFound=fopen(foundNotFoundDir,'r');
    tLine=fgetl(fLandmark);
    disp(tLine);
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
    while tLine~=-1
        % ATTENTION only for block occlusion , remove otherwise
        close all;
        count = count +1;
        disp('count');
        disp(count);
        parts=regexp(tLine,' ','split');
        idImage = str2double(parts{2});
        personID = parts{4};
        %personID = sprintf('%03d',fix((count)/19)+1); % ATTENTION true only for block occlusion
        disp('person id');
        disp(personID);
        foundStatus=parts{6};
        disp(foundStatus);
        if str2double(foundStatus) == 0
            disp('not found');
            tLine=fgetl(fLandmark);
            %tFound=fgetl(fFound);
            continue;
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
        personDestDir = strcat(destinationDir,personID); %sprintf('%03d',fix((idImage-1)/20)+1));
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
        for i = 1:landmarknum
            disp('boucle for');
            %imfea = imcrop(npic,[npicLandmark(2*i-1)-15 npicLandmark(2*i)-15 30 30]);
            if i == 1
                % right eye
                imfea = imcrop(npic,[npicLandmark(2*i-1)-20 npicLandmark(2*i)-25 50 50]);
                sizeFea = size(imfea);
                imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
                fullMatrixFeaturesRightEye(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
                feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',1),'.png');
                disp(feaName);
                imwrite(imfea,feaName);

                % between eye
                betweenEyesDistance = npicLandmark(2*(i+1)-1) - npicLandmark(2*i-1);
                imfea = imcrop(npic,[npicLandmark(2*i-1)+(betweenEyesDistance/2)-25 npicLandmark(2*i)-30 50 40]);
                sizeFea = size(imfea);
                imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
                fullMatrixFeaturesBetweenEye(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
                feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',2),'.png');
                disp(feaName);
                imwrite(imfea,feaName);

                % right eyebrow
                imfea = imcrop(npic,[npicLandmark(2*i-1)-20 npicLandmark(2*i)-35 55 30]);
                sizeFea = size(imfea);
                imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
                fullMatrixEyeBrowRight(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
                feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',3),'.png');
                disp(feaName);
                imwrite(imfea,feaName);
            end
            if i == 2
                % left eye
                imfea = imcrop(npic,[npicLandmark(2*i-1)-25 npicLandmark(2*i)-25 50 50]);
                sizeFea = size(imfea);
                imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
                fullMatrixFeaturesLeftEye(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
                feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',4),'.png');
                disp(feaName);
                imwrite(imfea,feaName);

                % left eyebrow
                imfea = imcrop(npic,[npicLandmark(2*i-1)-25 npicLandmark(2*i)-35 55 30]);
                sizeFea = size(imfea);
                imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
                fullMatrixEyeBrowLeft(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
                feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',5),'.png');
                disp(feaName);
                imwrite(imfea,feaName);
            end
            if i == 3
                % Nose
                imfea = imcrop(npic,[npicLandmark(2*i-1)-25 npicLandmark(2*i)-28 50 52]);
                sizeFea = size(imfea);
                imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
                fullMatrixFeaturesNose(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
                feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',6),'.png');
                disp(feaName);
                imwrite(imfea,feaName);

                % Right Nose
                imfea = imcrop(npic,[npicLandmark(2*i-1)-50 npicLandmark(2*i)-28 50 52]);
                sizeFea = size(imfea);
                imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
                fullMatrixFeaturesNoseRight(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
                feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',7),'.png');
                disp(feaName);
                imwrite(imfea,feaName);

                % Left Nose 
                imfea = imcrop(npic,[npicLandmark(2*i-1) npicLandmark(2*i)-28 50 52]);
                sizeFea = size(imfea);
                imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
                fullMatrixFeaturesNoseLeft(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
                feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',8),'.png');
                disp(feaName);
                imwrite(imfea,feaName);
            end
            if i == 4
                % Right Mouse
                lengthWantedForFeature = 106;
                lengthMouse = npicLandmark((2*(i+1))-1) - npicLandmark((2*i)-1);
                extraSpace = (lengthWantedForFeature-lengthMouse)/2;
                imfea = imcrop(npic,[(npicLandmark(2*(i)-1))-extraSpace (npicLandmark(2*(i)))-20 lengthWantedForFeature/2 40]); 
                sizeFea = size(imfea);
                imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
                fullMatrixFeaturesMouseRight(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
                feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',9),'.png');
                disp(feaName);
                imwrite(imfea,feaName);


            end
            if i == 5
                %imfea = imcrop(npic,[npicLandmark(2*i-1)-15 npicLandmark(2*i)-15 30 30]);
                % Left Mouse
                imfea = imcrop(npic,[(npicLandmark(2*(i)-1))-(lengthMouse/2) (npicLandmark(2*(i)))-20 lengthWantedForFeature/2 40]);
                sizeFea = size(imfea);
                imFeaMatrix = reshape(imfea,sizeFea(1)*sizeFea(2),1);
                fullMatrixFeaturesMouseLeft(:,idImage)=imFeaMatrix ; %ATTENTION declarer avec la taille connu pour gagner en vitesse
                feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',10),'.png');
                disp(feaName);
                imwrite(imfea,feaName);        end
            % UNCOMMENT if you want to display the key features
    %         figure;   
    %         imshow(imfea);
    %         feaName = strcat(keyFeaturesDir,'/',personID,'_',sprintf('%04d',idImage),'_',sprintf('%02d',i),'.png');
    %         disp(feaName);
    %         imwrite(imfea,feaName);
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
    savingResult = struct('fullMatrixFeaturesRightEye',fullMatrixFeaturesRightEye,'fullMatrixFeaturesLeftEye',fullMatrixFeaturesLeftEye,'fullMatrixFeaturesNose',fullMatrixFeaturesNose,'fullMatrixFeaturesBetweenEye',fullMatrixFeaturesBetweenEye,'fullMatrixEyeBrowRight',fullMatrixEyeBrowRight,'fullMatrixEyeBrowLeft',fullMatrixEyeBrowLeft,'fullMatrixFeaturesNoseRight',fullMatrixFeaturesNoseRight,'fullMatrixFeaturesNoseLeft',fullMatrixFeaturesNoseLeft,'fullMatrixFeaturesMouseRight',fullMatrixFeaturesMouseRight,'fullMatrixFeaturesMouseLeft',fullMatrixFeaturesMouseLeft);
    save(nameForSavingResult,'savingResult');

