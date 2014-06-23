clear;
close all;
clc;

%%
params.pca.numCoeffs = 400;
LDA.dim = 90;

%% fparam 文件存储参数
fparam.listDir = 'testset\All_sel\list_All_3.txt';
fparam.imDir = 'testset\All_sel\ALL_3';

% fparam.listDir = 'testset\All\list_All.txt';
% fparam.imDir = 'testset\All\ALL';

% fparam.listDir = 'data/list.txt';
% fparam.imDir = 'data\re-verification\';
% fparam.rtxpicDir = 'data/Tenpay/rtximage3/';
% fparam.idlandmarkDir = 'data/Tenpay/FivePoint_ID/';
% fparam.rtxlandmarkDir = 'data/Tenpay/FivePoint_rtx/';
% fparam.idlandmarkDir = 'data/Tenpay/test/FivePoint_ID/';
% fparam.rtxlandmarkDir = 'data/Tenpay/test/FivePoint_rtx/';

%% algparam  特征提取参数
algparam.patchMesh = [7,5];
algparam.scale = [1, 0.8,0.64,0.5]; 
algparam.patchSize = 10;%11
algparam.pindex = [];
algparam.centered = 0;
algparam.norml = 0;
algparam.fd = 59;
algparam.olp = 2;
algparam.dFea = algparam.fd * algparam.patchMesh(1) * algparam.patchMesh(2)...
    * size(algparam.scale,2) * (5+size(algparam.pindex,2));

%% feature extraction
% [fea,label] = FeaExtra(algparam,fparam);
% save('testset\all_sel_fea','fea')
% save('testset\all_sel_label','label')

load('testset\all_sel_fea','fea')
load('testset\all_sel_label','label')
fea = sqrt(fea);

%% pca lda metric
load('J:\DING\papers\face\DataBase\LFW\model\LFWpcamodel0415.mat')
load('J:\DING\papers\face\DataBase\LFW\model\LFWldamodel0415')
load('J:\DING\papers\face\DataBase\LFW\model\LFWm0415')

% load('testset\IDRTX-Pca')
% load('testset\IDRTX-M')
% pcamodel = tpca;


prem = diag((pcamodel.eigenVal(1:params.pca.numCoeffs)).^(-0.5));
fealow = (fea-repmat(pcamodel.P,[1,size(fea,2)]));
fealow = (pcamodel.W(:,1:params.pca.numCoeffs))'*fealow;
fealow = prem*fealow;
fealow = normc(fealow);
clear pcamodel
% % lda
fealow = (LFWldamodel.M)'*(fealow-repmat((LFWldamodel.mean)',[1,size(fealow,2)]));
fealow = normc(fealow);
clear LFWldamodel

imnum = size(fealow,2);
dis = zeros(imnum,imnum);
% M = eye(150);
for i = 1:imnum
    for j = 1:imnum
        %compute distance picsfea(:,i),idfea(:,j)
        dis(i,j) = (fealow(:,j)-fealow(:,i))'*M*(fealow(:,j)-fealow(:,i));
    end
end

tm = zeros(imnum,imnum);
for i = 1:imnum
    for j = 1:imnum
        if strcmp(label(i),label(j))
           tm(i,j) = 1;
        end
    end
end

addpath('eval')

confs = dis(:);
tp = tm(:);

[tpr,fpr,thresh] = icg_roc(tp',-confs');
rocM1 = [tpr;fpr];
figure,plot(fpr, tpr,'b');
grid on






