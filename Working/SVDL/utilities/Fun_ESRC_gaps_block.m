function correct_rate = Fun_ESRC_gaps(dicos,tt_dat,test_label,lambda)
addpath ./SVDL/utilities;


% lambda is the parameter of the coefficient's regularization, e.g., lambda = 1e-3
% trainlabel is a set of numbers from 1 to nCls;
addpath('./SVDL/L1Solvers');
% addpath('l1_ls_matlab');
sizeDicos = size(dicos);
sizeDicos = sizeDicos(2);

train_label = dicos{1,1}.trls;

nDim     =  size(dicos{1,1}.tr_dat,1);
nNum     =  length(train_label);
label    =  unique(train_label);
nCls     =  length(label);
%gap(1) = 0;

for n=1 : sizeDicos % for each kind of features
    dicos{1,n}.Train_M = [dicos{1,n}.tr_dat dicos{1,n}.dict_v];
    dicos{1,n}.Train_M =  dicos{1,n}.Train_M./( repmat(sqrt(sum(dicos{1,n}.Train_M.*dicos{1,n}.Train_M)), [nDim,1]) );
    tt_dat{1,n}   =  tt_dat{1,n}./( repmat(sqrt(sum(tt_dat{1,n}.*tt_dat{1,n})), [nDim,1]) );
end

for ti = 1:size(tt_dat{1,1},2) % For each test picture
    disp(num2str(ti));
    test = rem((ti-8),20);
    if test ~= 0
        for n=1 : sizeDicos % For each kind of key feature
            Test_M = tt_dat{1,n};
            Train_M = dicos{1,n}.Train_M;
            y{n}  = Test_M(:,ti);
            [currentX, nIter] = SolveDALM(Train_M,y{n}, 'lambda',lambda,'tolerance',1e-3); % SolveDALM correspond à Dual Augmented Lagrange Multiplier
            x{n} = currentX;
            y_add{n} = Train_M(:,nNum+1:end)*x{n}(nNum+1:end,1);
        end

        for ci = 1:nCls % For each person ID
            class = label(ci);
            gap(ci) = 0;
            for n=1 : sizeDicos % For each kind of key feature
                Train_M = dicos{1,n}.Train_M;
                cdat = Train_M(:,train_label==class);
                er   = y{n} - cdat*x{n}(train_label==class) - y_add{n};
                gap(ci) = gap(ci) + (dicos{1,n}.weight)*(er(:)'*er(:)); % On somme les gaps de chacune des features / ATTENTION mettre les weight ici !!!
            end
        end
        index = find(gap == min(gap)); % ne suffirait-il pas de sommmer les gaps de chacun des features et ensuite faire le min sur la somme ?
        ID(ti) = label(index(1));
    end
end
%keyboard;

correct_rate = sum(ID==test_label)/length(test_label);