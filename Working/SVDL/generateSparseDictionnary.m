%       Xg and d_dat  The reference SubSet
%       Yg   The Gallary
%       X{i} The ith variation generic training data
%       tr_dat Gallery samples -> training data
%       dict_v Dictonnary
%       er The objective function value vector
%       tt_dat Testing Data
%       ge_dat Generic training data
%       ge_ls Generic labels
%       disc_set Referentiel d'eigenvectors
%       

function [dict_v,er,disc_set,tr_dat,trls] = generateSparseDictionnary(raw_data,parameters)

%seting parameter
pro_sign          =   parameters.pro_sign;        
par.nDim          =   parameters.par.nDim;
lambda            =   parameters.lambda;      %test lambda
lambda1           =   parameters.lambda1;
lambda2           =   parameters.lambda2;
lambda3           =   parameters.lambda3;
dnum              =   parameters.dnum;


% load des labels
load('./SVDL/database/session1_05_1_netural_all');
%DAT = double(DAT);
%load('../../DataRetrieved/session1/featuresSession1.mat');
%raw_data = double(fullMatrixFeaturesRightEyeSession1);
labels(labels>213) = labels(labels>213) -1; % there is no data with label 213, so we shift the label

% gallery samples 
tr_dat = raw_data(:,8:20:end); trls = labels(:,8:20:end); % gallery samples , on récupère la 8ème image de chaque personne
%tr_dat = DAT(:,8:20:end); trls = labels(:,8:20:end); % gallery samples , on récupère la 8ème image de chaque personne
tr_dat = tr_dat(:,trls<pro_sign); % contient une image de chaque personne ayant un label < pro_sign
trls   = trls(:,trls<pro_sign);


% reduce the dimensionality via PCA
[disc_set,disc_value,Mean_Image]  =  Eigenface_f(tr_dat,par.nDim); % PCA sur les gallery sample
tr_dat  =  disc_set'*tr_dat;
tr_dat   =  tr_dat./( repmat(sqrt(sum(tr_dat.*tr_dat)), [par.nDim,1]) );


% reference subset and variation subset of generic training set
ge_dat = []; d_dat = [];ge_ls = []; ge_id = 1;
for ci = pro_sign:249
   cdat = raw_data(:,labels==ci);
   %cdat = DAT(:,labels==ci);
   if ~isempty(cdat)
      ge_dat = [ge_dat cdat(:,1:7) cdat(:,9:end)];
      ge_ls  = [ge_ls ge_id*ones(1,19)];
      d_dat  = [d_dat cdat(:,8)];  % c'est la 8 ème image qui est  pris comme reference subset, c'est juste parceque cela correspond bien à la variation de notre gallery set, mais cela implique une connaissance au préalable // Il y a peu être une amélioration à faire ici.
      ge_id  = ge_id + 1;
   end
end
% reduce the dimentionality of the generic and reference subset via PCA
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


end