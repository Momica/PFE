% 2014 05 22
% tenpay verification cam pic and id image

clear;
close all;
clc;

%%
params.pca.numCoeffs = 400;
LDA.dim = 90;

%% fparam 文件存储参数
% fparam.picDir = '..\idfaceverification\data\Tenpay\TP48\cam';
fparam.picDir = '..\idfaceverification\data\Tenpay\TP48\camlow';
fparam.lowpicDir = '..\idfaceverification\data\Tenpay\TP48\camlow';
fparam.idDir = '..\idfaceverification\data\Tenpay\TP48\id';

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
[idfea,picfea,label] = idpicFeaExtra(algparam,fparam);
% save('testset\idfea','idfea')
% save('testset\picfea','picfea')
% save('testset\label','label')

load('testset\idfea','idfea')
load('testset\picfea','picfea')
load('testset\label','label')
pnum = size(idfea,2);

params.pca.numCoeffs = 90;
params.lda.numCoeffs = 30;
Xtrain = [idfea,picfea];
pcamodel = perform_pca_PhD(Xtrain,params.pca.numCoeffs);

prem = diag((pcamodel.eigenVal(1:params.pca.numCoeffs)).^(-0.5));
Xtrain = [idfea,picfea];
Xtrain = (pcamodel.W)'*(Xtrain-repmat(pcamodel.P,1,size(Xtrain,2)));
Xtrain = normc(Xtrain);

%lda
 [mappedX, mapping] = lda(Xtrain', [1:pnum,label'], params.lda.numCoeffs);
 Xtrain = normc(mappedX');

%% kiss
addpath('kiss');

idxam = label;
idxbm = pnum+1:size(Xtrain,2);
matches = ones(1,length(label));
idxam = [idxam,idxam];
id = unique(label);
for i = 1:length(id)
    subnum = length(find(label==id(i)));
    subindex = find(label ~= id(i));
    selectid = randperm(length(subindex),subnum);
    idxbm = [idxbm,pnum+subindex(selectid)'];
end
matches = [matches,zeros(1,length(label))];
M = learnPairwise(Xtrain,idxam,idxbm,logical(matches),1,true);

%% test
%policetest
load('..\idfaceverification\data\Tenpay\idfea-low','idfea')
load('..\idfaceverification\data\Tenpay\picfea-low','picfea')
load('..\idfaceverification\data\Tenpay\pairs','pairs')

prem = diag((pcamodel.eigenVal(1:params.pca.numCoeffs)).^(-0.5));
Xtest = [idfea,picfea];
Xtest = (pcamodel.W)'*(Xtest-repmat(pcamodel.P,1,size(Xtest,2)));
Xtest = normc(Xtest);
% lda
Xtest = (mapping.M)'*(Xtest-repmat((mapping.mean)',[1,size(Xtest,2)]));
Xtest = normc(Xtest);


idfea = Xtest(:,1:size(idfea,2));
picfea = Xtest(:,size(idfea,2)+1:end);

dis = zeros(1,size(Xtest,2));
for  i = 1:length(pairs)
    dis(i) = (idfea(:,pairs(i).idi)-picfea(:,pairs(i).pici))'*M*(idfea(:,pairs(i).idi)-picfea(:,pairs(i).pici));
    
end

addpath('eval')
[tpr,fpr,thresh] = icg_roc([pairs.match],-dis);
figure,plot(fpr, tpr,'b');

grid on

