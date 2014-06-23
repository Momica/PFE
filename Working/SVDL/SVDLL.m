%       Xg and d_dat  The reference SubSet
%       Yg   The Gallary
%       X{i} The ith variation generic training data
%       tr_dat Gallery samples -> training data
%       dict_v Dictonnary
%       er The objective function value vector
%       tt_dat Testing Data
%       ge_dat Generic training data
%       ge_ls Generic labels
%       disc_set Referentie d'eigenvectors
%       


clear all;
clc;
addpath utilities;
addpath src;

%seting parameter
pro_sign          =   100;        
par.nDim          =   90;
lambda            =   0.001;      %test lambda
lambda1           =   0.001;
lambda2           =   0.01;
lambda3           =   1e-4;
dnum              =   400;

load('database/session1_05_1_netural_all');
%DAT = double(DAT);
load('../../DataRetrieved/session1/featuresSession1.mat');
fullMatrixFeaturesRightEyeSession1 = double(fullMatrixFeaturesMouseSession1);
labels(labels>213) = labels(labels>213) -1; % there is no data with label 213, so we shift the label

% gallery samples 
tr_dat = fullMatrixFeaturesRightEyeSession1(:,8:20:end); trls = labels(:,8:20:end); % gallery samples , on récupère la 8ème image de chaque personne
tr_dat = tr_dat(:,trls<pro_sign); % contient une image de chaque personne ayant un label < pro_sign
trls   = trls(:,trls<pro_sign);

tr_dat_1 = fullMatrixFeaturesRightEyeSession1(:,8:20:end); trls_1 = labels(:,8:20:end);
tr_dat_2 = tr_dat_1(:,trls<pro_sign); 
trls_2   = trls_1(:,trls<pro_sign);


% reduce the dimensionality via PCA
[disc_set,disc_value,Mean_Image]  =  Eigenface_f(tr_dat,par.nDim); % PCA sur les gallery sample
tr_dat  =  disc_set'*tr_dat;
tr_dat   =  tr_dat./( repmat(sqrt(sum(tr_dat.*tr_dat)), [par.nDim,1]) );

tr_dat_3  =  disc_set'*tr_dat_2;
tr_dat_4   =  tr_dat_3./( repmat(sqrt(sum(tr_dat_3.*tr_dat_3)), [par.nDim,1]) );

% reference subset and variation subset of generic training set
ge_dat = []; d_dat = [];ge_ls = []; ge_id = 1;
for ci = pro_sign:249
   cdat = fullMatrixFeaturesRightEyeSession1(:,labels==ci);
   if ~isempty(cdat)
      ge_dat = [ge_dat cdat(:,1:7) cdat(:,9:end)];
      ge_ls  = [ge_ls ge_id*ones(1,19)];
      d_dat  = [d_dat cdat(:,8)];  % c'est la 8 ème image qui est  pris comme reference subset // Il y a peu être une amélioration à faire ici.
      ge_id  = ge_id + 1;
   end
end
ge_dat  =  disc_set'*ge_dat;
d_dat   =  disc_set'*d_dat;
ge_dat  =  ge_dat./( repmat(sqrt(sum(ge_dat.*ge_dat)), [par.nDim,1]) );
d_dat   =  d_dat./( repmat(sqrt(sum(d_dat.*d_dat)), [par.nDim,1]) );

Xg   =  d_dat;   % The reference SubSet
Yg   =  tr_dat;  % The Gallery 
for ti = 1:19
    X{ti} = ge_dat(:,ti:19:end);  % X{i} The ith variation generic training data
end

% learn sparse variation dictionary
isShow   =  true;
[dict_v,er]   =   SVDL(Xg,Yg,X,lambda1,lambda2,lambda3,dnum,3,5,isShow);

% load testing data
session  =  4;
par.nameDatabase  =   ['mpie_s' num2str(session) '_SVDL'];
load(['database/session' num2str(session) '_05_1_netural_all']);
load('../../DataRetrieved/session4/featuresSession4.mat');
fullMatrixFeaturesRightEyeSession4 = double(fullMatrixFeaturesMouseSession4);
labels(labels>213) = labels(labels>213) -1;
tt_dat = fullMatrixFeaturesRightEyeSession4;
ttls   = labels;
tt_dat = tt_dat(:,ttls<pro_sign);
ttls   = ttls(:,ttls<pro_sign);
tt_dat  =  disc_set'*tt_dat;

% do classification
correct_rate = Fun_ESRC([tr_dat dict_v],trls,tt_dat,ttls,lambda);

fid = fopen(['result/demo_result_' par.nameDatabase '.txt'],'a');
fprintf(fid,'\n%s\n','========================================');
fprintf(fid,'%s%8f%s%8f%s%8f\n','lambda1 = ',lambda1,'lambda2 = ',lambda2,' lambda3= ',lambda3);
fprintf(fid,'%s%8f%s%8f\n','nDim = ',par.nDim,' lambda= ',lambda);
fprintf(fid,'%s%8f\n','reco_rate1 = ',correct_rate);
fclose(fid);