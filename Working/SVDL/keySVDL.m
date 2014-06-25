clear all;
clc;
addpath utilities;
addpath src;

%seting parameter
parameters.pro_sign          =   100;        
parameters.par.nDim          =   90;
parameters.lambda            =   0.001;      %test lambda
parameters.lambda1           =   0.001;
parameters.lambda2           =   0.01;
parameters.lambda3           =   1e-4;
parameters.dnum              =   400;


load('../../DataRetrieved/session1/featuresSession1.mat');
rightEyeSession1 = double(fullMatrixFeaturesRightEyeSession1);

[dict_v_right_eye,er_right_eye,disc_set_right_eye,tr_dat_right_eye,trls_right_eye] = generateSparseDictionnary(rightEyeSession1,parameters);

% load testing data
session  =  4;
par.nameDatabase  =   ['mpie_s' num2str(session) '_SVDL'];
load(['database/session' num2str(session) '_05_1_netural_all']);
load('../../DataRetrieved/session4/featuresSession4.mat');
rightEyeSession4 = double(fullMatrixFeaturesRightEyeSession4);
%DAT = double(DAT);
labels(labels>213) = labels(labels>213) -1;
tt_dat = rightEyeSession4;
%tt_dat = DAT;
ttls   = labels;
tt_dat = tt_dat(:,ttls<parameters.pro_sign);
ttls   = ttls(:,ttls<parameters.pro_sign);
tt_dat  =  disc_set_right_eye'*tt_dat;

% do classification
correct_rate = Fun_ESRC([tr_dat_right_eye dict_v_right_eye],trls_right_eye,tt_dat,ttls,parameters.lambda);

fid = fopen(['result/demo_result_' par.nameDatabase '.txt'],'a');
fprintf(fid,'\n%s\n','========================================');
fprintf(fid,'%s%8f%s%8f%s%8f\n','lambda1 = ',parameters.lambda1,'lambda2 = ',parameters.lambda2,' lambda3= ',parameters.lambda3);
fprintf(fid,'%s%8f%s%8f\n','nDim = ',parameters.par.nDim,' lambda= ',parameters.lambda);
fprintf(fid,'%s%8f\n','reco_rate1 = ',correct_rate);
fclose(fid);