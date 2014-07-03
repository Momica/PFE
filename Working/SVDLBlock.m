
clear all;
clc;
addpath ./SVDL/utilities;
addpath ./SVDL/src;
addpath ./SVDL;

tic();

%setting parameter
parameters.pro_sign          =   100;        
parameters.par.nDim          =   90;
parameters.lambda            =   0.001;      %test lambda
parameters.lambda1           =   0.001;
parameters.lambda2           =   0.01;
parameters.lambda3           =   1e-4;
parameters.dnum              =   400;
block_l = 0.3; % block level

load('./SVDL/database/session1_05_1_netural_all');

% We load Sparse Dicos if they already exist, otherwise we generate it
savingName = strcat('../DataRetrieved/session1/block_occlusion/',int2str(100*block_l),'/full_face/Session1Block_',int2str(100*block_l),'.mat');
disp(savingName);
if exist('../DataRetrieved/session1/full_face/Session1Dico.mat') == 2
    disp('Dicos already exist. Loading dicos');
    dicos = load('../DataRetrieved/session1/full_face/Session1Dico.mat');
    %dico = fieldnames(dicoStructure);
else
    disp('Dicos not exist. TODO using classic svdl manually');
    keyboard;
    % Load generic structure
%     featuresStructure = load('../DataRetrieved/session1/featuresSession1Many.mat');
%     raw_features = fieldnames(featuresStructure);
% 
%     for n = 1:length(raw_features)
% 
%         % Generate SVDL on current feature
%         currentFeature = featuresStructure.(raw_features{n});
%         currentFeature = double(currentFeature);
%         [dict_v,er,disc_set,tr_dat,trls] = generateSparseDictionnary(currentFeature,parameters);
%         weight = 1;
%         % We save the data, to speed next use based on the same set
%         newDico = struct('dict_v',dict_v,'disc_set',disc_set,'er',er,'tr_dat',tr_dat,'trls',trls,'weight',weight);
%         dicos{n} = newDico;
%     end
%     dicosName = '../DataRetrieved/session1/Session1ManyDicos.mat';
%     save(dicosName,'dicos');
end

% Load testing structure
if exist(savingName) == 2
    disp('Structure occluded already exist. Loading structure...');
    testFeaturesStructure = load(savingName);
    %dico = fieldnames(dicoStructure);
else
    disp('Structure occluded not exist. Creating...');
    dirBlock = strcat('../DataRetrieved/session1/block_occlusion/',int2str(100*block_l),'/full_face');
    disp(dirBlock);

    % generate the block-occluded image
    load('./SVDL/database/session1_05_1_netural_all');
    %block_l = 0.2; % block level
    im_h    = 100;
    im_w    = 82;
    height  = floor(sqrt(im_h*im_w*block_l));
    width   = height;
    load ('./SVDL/rand_w_h');
    w_a     = 1;
    w_b     = im_w - width +1;
    r_w     = w_a + (w_b - w_a).*width_rand;
    h_a     = 1;
    h_b     = im_h - height + 1;
    r_h     = h_a + (h_b - h_a).*height_rand;

    DAT = double(DAT);
    labels(labels>213) = labels(labels>213) -1;
    tt_dat = []; ttls = [];
    for ci = 1:parameters.pro_sign-1
       cdat = DAT(:,labels==ci);
       if ~isempty(cdat)
           tt_dat = [tt_dat cdat(:,1:7) cdat(:,9:end)];
           ttls   = [ttls ci*ones(1,19)];
       end 
    end
    tem_dat = [];
    for ti = 1:size(tt_dat,2)
        img = reshape(tt_dat(:,ti),[100 82]);
        %img = imresize(img,[im_h im_w]);
        J   = Random_Block_Occlu(uint8(img),r_h(ti),r_w(ti),height,width);
        tem_dat(:,ti) = J(:);
    end
    tt_dat = tem_dat;
    sizeDat = size(tt_dat);
    dirDestName = strcat('block_occlusion/',int2str(100*block_l),'/full_face/');
    if exist(dirBlock) == 2
        disp(' image with block exist already do qqch');
    else 
        DAT2ImagesBlock(sizeDat(2), 1,dirDestName ,tt_dat,82,100);
    end
    structureName = strcat('Session1Block_',int2str(100*block_l));
    savingResult = struct(structureName,tt_dat);
    save(savingName,'savingResult');
    testFeaturesStructure = load(savingName);
end
    %savingName = strcat('../DataRetrieved/session1/block_occlusion/featuresSession1Block_',int2str(100*block_l),'.mat');
    %featuresCropper('../DataRetrieved/session1/landmarksFaceBlock.txt',dirBlock,savingName);



testFeatures = fieldnames(testFeaturesStructure.savingResult);
labels(labels>213) = labels(labels>213) -1; % there is no data with label 213, so we shift the label

currentTestFeature = testFeaturesStructure.savingResult.(testFeatures{1});
currentTestFeature = double(currentTestFeature);

load('./SVDL/database/session1_05_1_netural_all');
DAT = double(DAT);
labels(labels>213) = labels(labels>213) -1;
tt_dat = []; ttls = [];
for ci = 1:parameters.pro_sign-1
   cdat = DAT(:,labels==ci);
   if ~isempty(cdat)
       tt_dat = [tt_dat cdat(:,1:7) cdat(:,9:end)];
       ttls   = [ttls ci*ones(1,19)];
   end 
end
    
my_tt_dat = currentTestFeature;
%ttls   = labels;
my_tt_dat = my_tt_dat(:,ttls<parameters.pro_sign);
%ttls   = ttls(:,ttls<parameters.pro_sign);
my_tt_dat  = dicos.savingResult.disc_set'*my_tt_dat;


% for n = 1:length(testFeatures)
%     currentdicos{1,1} = dicos{1,n};
%     current_tt_dat{1} = my_tt_dat{n};
%     correct_rate = Fun_ESRC_gaps_block(currentdicos,current_tt_dat,ttls,parameters.lambda);
%     %fid = fopen(['result/demo_result_' par.nameDatabase '.txt'],'a');
%     %fid = fopen(['result/demo_result.txt'],'a');
%     %fprintf(fid,'\n%s\n','========================================');
%     %fprintf(fid,'%s%8f%s%8f%s%8f\n','lambda1 = ',parameters.lambda1,'lambda2 = ',parameters.lambda2,' lambda3= ',parameters.lambda3);
%     %fprintf(fid,'%s%8f%s%8f%s%8f\n','weight 1 = ',dicos{1,1}.weight,'weight 2 = ',dicos{1,2}.weight,' weight 3= ',dicos{1,3}.weight);
%     %fprintf(fid,'%s%8f%s%8f\n','nDim = ',parameters.par.nDim,' lambda= ',parameters.lambda);
%     dicos{1,n}.weight = correct_rate;
%     %fclose(fid);
% end

correct_rate = Fun_ESRC_l1([dicos.savingResult.tr_dat dicos.savingResult.dict_v],dicos.savingResult.trls,my_tt_dat,ttls,parameters.lambda);
%fid = fopen(['result/demo_result_' par.nameDatabase '.txt'],'a');
fid = fopen(['./SVDL/result/demo_result_block_norme1_PCA.txt'],'a');
fprintf(fid,'\n======= Occlusion %8f percent ========\n',100*block_l)
%fprintf(fid,'%s%8f%s%8f%s%8f\n','lambda1 = ',parameters.lambda1,'lambda2 = ',parameters.lambda2,' lambda3= ',parameters.lambda3);
%fprintf(fid,'%s%8f%s%8f%s%8f\n','weight 1 = ',dicos{1,1}.weight,'weight 2 = ',dicos{1,2}.weight,' weight 3= ',dicos{1,3}.weight);
%fprintf(fid,'%s%8f%s%8f\n','nDim = ',parameters.par.nDim,' lambda= ',parameters.lambda);
fprintf(fid,'%s%8f\n','reco_rate1 = ',correct_rate);
fclose(fid);
toc();


% % UNCOMMEN to test many weight
%     for i=80:82
%         for j=52:59
%             for k=57:63
%                 disp('weigths');
%                 dicos{1,1}.weight = i/100;
%                 dicos{1,2}.weight = j/100;
%                 dicos{1,3}.weight = k/100;
%                 disp(dicos{1,1}.weight);
%                 disp(dicos{1,2}.weight);
%                 disp(dicos{1,3}.weight);
%                 correct_rate = Fun_ESRC_gaps(dicos,tt_dat,ttls,parameters.lambda);
%                 %fid = fopen(['result/demo_result_' par.nameDatabase '.txt'],'a');
%                 fid = fopen(['result/demo_result_weight.txt'],'a');
%                 fprintf(fid,'\n%s\n','========================================');
%                 %fprintf(fid,'%s%8f%s%8f%s%8f\n','lambda1 = ',parameters.lambda1,'lambda2 = ',parameters.lambda2,' lambda3= ',parameters.lambda3);
%                 fprintf(fid,'%s%8f%s%8f%s%8f\n','weight 1 = ',dicos{1,1}.weight,'weight 2 = ',dicos{1,2}.weight,' weight 3= ',dicos{1,3}.weight);
%                 %fprintf(fid,'%s%8f%s%8f\n','nDim = ',parameters.par.nDim,' lambda= ',parameters.lambda);
%                 fprintf(fid,'%s%8f\n','reco_rate1 = ',correct_rate);
%                 fclose(fid);
%                 toc();
%             end
%         end
%     end
    
