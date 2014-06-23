function correct_rate = Fun_ESRC(Train_M,train_label,Test_M,test_label,lambda)
% lambda is the parameter of the coefficient's regularization, e.g., lambda = 1e-3
% trainlabel is a set of numbers from 1 to nCls;
addpath('L1Solvers');
% addpath('l1_ls_matlab');

nDim     =  size(Train_M,1);
nNum     =  length(train_label);
label    =  unique(train_label);
nCls     =  length(label);
Train_M  =  Train_M./( repmat(sqrt(sum(Train_M.*Train_M)), [nDim,1]) );
Test_M   =  Test_M./( repmat(sqrt(sum(Test_M.*Test_M)), [nDim,1]) );

cor_gap  = [];
wro_gap  = [];

for ti = 1:size(Test_M,2)
    disp(num2str(ti));
    y  = Test_M(:,ti);
    [x, nIter] = SolveDALM(Train_M,y, 'lambda',lambda,'tolerance',1e-3);
    y_add = Train_M(:,nNum+1:end)*x(nNum+1:end,1);
    for ci = 1:nCls
        class = label(ci);
        cdat = Train_M(:,train_label==class);
        er   = y - cdat*x(train_label==class) - y_add;
        gap(ci) = er(:)'*er(:);
    end
    index = find(gap == min(gap));
    ID(ti) = label(index(1));
end
correct_rate = sum(ID==test_label)/length(test_label);