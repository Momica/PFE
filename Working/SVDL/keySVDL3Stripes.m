
clear all;
clc;
addpath utilities;
addpath src;
tic();

%seting parameter
parameters.pro_sign          =   100;        
parameters.par.nDim          =   90;
parameters.lambda            =   0.001;      %test lambda
parameters.lambda1           =   0.001;
parameters.lambda2           =   0.01;
parameters.lambda3           =   1e-4;
parameters.dnum              =   400;

if exist('/Users/baptistemetge/Code/PFE/Git/PFE/DataRetrieved/session1/featuresSession1StripesDicos.mat') == 2
    disp('hello');
    load('/Users/baptistemetge/Code/PFE/Git/PFE/DataRetrieved/session1/featuresSession1StripesDicos.mat');
    %dicos = fieldnames(dicoStructure);
else
    
    load('../../DataRetrieved/session1/featuresSession1Stripes.mat');
    rightEyeSession1 = double(fullMatrixFeaturesRightEye);
    %leftEyeSession1 = double(fullMatrixFeaturesLeftEyeSession1);
    mouseSession1 = double(fullMatrixFeaturesMouse);
    noseSession1 = double(fullMatrixFeaturesNose);

    [dict_v_right_eye,er_right_eye,disc_set_right_eye,tr_dat_right_eye,trls] = generateSparseDictionnary(rightEyeSession1,parameters);
    %[dict_v_left_eye,er_left_eye,disc_set_left_eye,tr_dat_left_eye,trls] = generateSparseDictionnary(leftEyeSession1,parameters);
    [dict_v_mouse,er_mouse,disc_set_mouse,tr_dat_mouse,trls] = generateSparseDictionnary(mouseSession1,parameters);
    [dict_v_nose,er_nose,disc_set_nose,tr_dat_nose,trls] = generateSparseDictionnary(noseSession1,parameters);
end

% load testing data
session  =  4;
par.nameDatabase  =   ['mpie_s' num2str(session) '_SVDL'];
load(['database/session' num2str(session) '_05_1_netural_all']);
load('../../DataRetrieved/session4/featuresSession4Stripes.mat');
rightEyeSession4 = double(fullMatrixFeaturesRightEye);
%leftEyeSession4 = double(fullMatrixFeaturesLeftEyeSession4);
mouseSession4 = double(fullMatrixFeaturesMouse);
noseSession4 = double(fullMatrixFeaturesNose);

%DAT = double(DAT);
labels(labels>213) = labels(labels>213) -1;

tt_dat_right_eye = rightEyeSession4;
%tt_dat_left_eye = leftEyeSession4;
tt_dat_mouse = mouseSession4;
tt_dat_nose = noseSession4;
%tt_dat = DAT;
ttls   = labels;
tt_dat_right_eye = tt_dat_right_eye(:,ttls<parameters.pro_sign);
%tt_dat_left_eye = tt_dat_left_eye(:,ttls<parameters.pro_sign);
tt_dat_mouse = tt_dat_mouse(:,ttls<parameters.pro_sign);
tt_dat_nose = tt_dat_nose(:,ttls<parameters.pro_sign);
ttls   = ttls(:,ttls<parameters.pro_sign);
tt_dat_right_eye  =  disc_set_right_eye'*tt_dat_right_eye;
%tt_dat_left_eye  =  disc_set_left_eye'*tt_dat_left_eye;
tt_dat_mouse  =  disc_set_mouse'*tt_dat_mouse;
tt_dat_nose  =  disc_set_nose'*tt_dat_nose;

%Train_Galleries = struct('Train_M_right_eye',[tr_dat_right_eye dict_v_right_eye],'Train_M_left_eye',[tr_dat_left_eye dict_v_left_eye]);
%Test_Sets = struct('tt_dat_right_eye',tt_dat_right_eye,'tt_dat_left_eye',tt_dat_lest_eye);

% do classification
correct_rate = Fun_ESRC_Multi_Stripes([tr_dat_right_eye dict_v_right_eye],[tr_dat_mouse dict_v_mouse],[tr_dat_nose dict_v_nose],trls,tt_dat_right_eye,tt_dat_mouse,tt_dat_nose,ttls,parameters.lambda);

fid = fopen(['result/demo_result_' par.nameDatabase '.txt'],'a');
fprintf(fid,'\n%s\n','========================================');
fprintf(fid,'%s%8f%s%8f%s%8f\n','lambda1 = ',parameters.lambda1,'lambda2 = ',parameters.lambda2,' lambda3= ',parameters.lambda3);
fprintf(fid,'%s%8f%s%8f\n','nDim = ',parameters.par.nDim,' lambda= ',parameters.lambda);
fprintf(fid,'%s%8f\n','reco_rate1 = ',correct_rate);
fclose(fid);
toc();