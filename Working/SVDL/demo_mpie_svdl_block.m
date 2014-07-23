
clear all;
clc;
addpath utilities;
addpath src;


%seting parameter
pro_sign          =   101;
par.nDim          =   500;
lambda            =   0.001;      %test lambda
lambda1           =   0.001;
lambda2           =   0.01;
lambda3           =   1e-4;
dnum              =   400;
par.nameDatabase  =   'MPIES1_Block_SVDL';


load('database/session1_05_1_netural_all');
DAT = double(DAT);
tem_dat = [];
for di = 1:size(DAT,2)
    img = reshape(DAT(:,di),[100 82]);
    img = imresize(img,[25 20]);
    tem_dat(:,di) = img(:);
end
DAT = tem_dat;
labels(labels>213) = labels(labels>213) -1; % there is no data with label 213, so we shift the label

% gallery samples
tr_dat = DAT(:,8:20:end); trls = labels(:,8:20:end); 
tr_dat = tr_dat(:,trls<pro_sign);
trls   = trls(:,trls<pro_sign);
tr_dat   =  tr_dat./( repmat(sqrt(sum(tr_dat.*tr_dat)), [par.nDim,1]) );

% reference subset and variation subset of generic training set
ge_dat = []; d_dat = [];ge_ls = []; ge_id = 1;
for ci = pro_sign:249
   cdat = DAT(:,labels==ci);
   if ~isempty(cdat)
      ge_dat = [ge_dat cdat(:,1:7) cdat(:,9:end)];
      ge_ls  = [ge_ls ge_id*ones(1,19)];
      d_dat  = [d_dat cdat(:,8)];
      ge_id  = ge_id + 1;
   end
end
ge_dat  =  ge_dat./( repmat(sqrt(sum(ge_dat.*ge_dat)), [par.nDim,1]) );
d_dat   =  d_dat./( repmat(sqrt(sum(d_dat.*d_dat)), [par.nDim,1]) );
Xg   =  d_dat;
Yg   =  tr_dat;
for ti = 1:19
    X{ti} = ge_dat(:,ti:19:end);
end

% learn sparse variation dictionary
isShow   =  true;
[dict_v,er]   =   SVDL(Xg,Yg,X,lambda1,lambda2,lambda3,dnum,4,5,isShow);


% generate the block-occluded image
load('database/session1_05_1_netural_all');
block_l = 0.175; % block level
im_h    = 25;
im_w    = 20;
height  = floor(sqrt(im_h*im_w*block_l));
width   = height;
load rand_w_h;
w_a     = 1;
w_b     = im_w - width +1;
r_w     = w_a + (w_b - w_a).*width_rand;
h_a     = 1;
h_b     = im_h - height + 1;
r_h     = h_a + (h_b - h_a).*height_rand;

DAT = double(DAT);
labels(labels>213) = labels(labels>213) -1;
tt_dat = []; ttls = [];
for ci = 1:pro_sign-1
   cdat = DAT(:,labels==ci);
   if ~isempty(cdat)
       tt_dat = [tt_dat cdat(:,1:7) cdat(:,9:end)];
       ttls   = [ttls ci*ones(1,19)];
   end 
end
tem_dat = [];
for ti = 1:size(tt_dat,2)
    img = reshape(tt_dat(:,ti),[100 82]);
    img = imresize(img,[25 20]);
    J   = Random_Block_Occlu(uint8(img),r_h(ti),r_w(ti),height,width);
    tem_dat(:,ti) = J(:);
end
tt_dat = tem_dat;

% do classification
correct_rate = Fun_ESRC_l1([tr_dat dict_v],trls,tt_dat,ttls,lambda);

fid = fopen(['result/demo_result_' par.nameDatabase '.txt'],'a');
fprintf(fid,'\n%s\n','=================17,5%=======================');
fprintf(fid,'%s%8f%s%8f%s%8f\n','lambda1 = ',lambda1,'lambda2 = ',lambda2,' lambda3= ',lambda3);
fprintf(fid,'%s%8f%s%8f\n','nDim = ',par.nDim,' lambda= ',lambda);
fprintf(fid,'%s%8f\n','reco_rate1 = ',correct_rate);
fclose(fid);

