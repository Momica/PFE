
clear all;
clc;
addpath utilities;
addpath src;
tic();

%setting parameter
parameters.pro_sign          =   100;        
parameters.par.nDim          =   90;
parameters.lambda            =   0.001;      %test lambda
parameters.lambda1           =   0.001;
parameters.lambda2           =   0.01;
parameters.lambda3           =   1e-4;
parameters.dnum              =   400;

session  =  4;
par.nameDatabase  =   ['mpie_s' num2str(session) '_SVDL'];
load(['database/session' num2str(session) '_05_1_netural_all']);

% Load generic structure
featuresStructure = load('../../DataRetrieved/session1/featuresSession1.mat');
features = fieldnames(featuresStructure);
% Load testung structure
testFeaturesStructure = load('../../DataRetrieved/session4/featuresSession4.mat');
testFeatures = fieldnames(testFeatures);
labels(labels>213) = labels(labels>213) -1; % there is no data with label 213, so we shift the label
for n = 1:length(features)
    
    % Generate SVDL on current feature
    currentFeature = S.(features{n});
    currentFeature = double(currentFeature);
    [dict_v,er,disc_set,tr_dat,trls] = generateSparseDictionnary(currentFeature,parameters);
    
    % load testing data corresponding
    currentTestFeature = S.(testFeatures{n});
    currentTestFeature = double(currentTestFeature);

    tt_dat = currentTestFeature;
    ttls   = labels;
    tt_dat = tt_dat(:,ttls<parameters.pro_sign);
    ttls   = ttls(:,ttls<parameters.pro_sign);
    tt_dat  =  disc_set'*tt_dat;

    %Train_Galleries = struct('Train_M_right_eye',[tr_dat_right_eye dict_v_right_eye],'Train_M_left_eye',[tr_dat_left_eye dict_v_left_eye]);
    %Test_Sets = struct('tt_dat_right_eye',tt_dat_right_eye,'tt_dat_left_eye',tt_dat_lest_eye);

    % do classification
    correct_rate = Fun_ESRC([tr_dat dict_v],trls,tt_dat,ttls,parameters.lambda);


% load('../../DataRetrieved/session1/featuresSession1.mat');
% rightEyeSession1 = double(fullMatrixFeaturesRightEyeSession1);
% leftEyeSession1 = double(fullMatrixFeaturesLeftEyeSession1);
% mouseSession1 = double(fullMatrixFeaturesMouseSession1);
% noseSession1 = double(fullMatrixFeaturesNoseSession1);
% 
% 
% [dict_v,er,disc_set,tr_dat,trls] = generateSparseDictionnary(rightEyeSession1,parameters);
% [dict_v_left_eye,er_left_eye,disc_set_left_eye,tr_dat_left_eye,trls] = generateSparseDictionnary(leftEyeSession1,parameters);
% [dict_v_mouse,er_mouse,disc_set_mouse,tr_dat_mouse,trls] = generateSparseDictionnary(mouseSession1,parameters);
% [dict_v_nose,er_nose,disc_set_nose,tr_dat_nose,trls] = generateSparseDictionnary(noseSession1,parameters);


fid = fopen(['result/demo_result_' par.nameDatabase '.txt'],'a');
fprintf(fid,'\n%s\n','========================================');
fprintf(fid,'%s%8f%s%8f%s%8f\n','lambda1 = ',parameters.lambda1,'lambda2 = ',parameters.lambda2,' lambda3= ',parameters.lambda3);
fprintf(fid,'%s%8f%s%8f\n','nDim = ',parameters.par.nDim,' lambda= ',parameters.lambda);
fprintf(fid,'%s%8f\n','reco_rate1 = ',correct_rate);
fclose(fid);
toc();