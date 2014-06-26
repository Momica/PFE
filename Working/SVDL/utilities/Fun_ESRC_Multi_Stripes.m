function correct_rate = Fun_ESRC_Multi_Stripes(Train_M_right_eye,Train_M_mouse,Train_M_nose,train_label,Test_M_right_eye,Test_M_mouse,Test_M_nose,test_label,lambda)
% lambda is the parameter of the coefficient's regularization, e.g., lambda = 1e-3
% trainlabel is a set of numbers from 1 to nCls;
addpath('L1Solvers');
% addpath('l1_ls_matlab');



nDim     =  size(Train_M_right_eye,1);
nNum     =  length(train_label);
label    =  unique(train_label);
nCls     =  length(label);
Train_M_right_eye  =  Train_M_right_eye./( repmat(sqrt(sum(Train_M_right_eye.*Train_M_right_eye)), [nDim,1]) );
Test_M_right_eye   =  Test_M_right_eye./( repmat(sqrt(sum(Test_M_right_eye.*Test_M_right_eye)), [nDim,1]) );
%Train_M_left_eye  =  Train_M_left_eye./( repmat(sqrt(sum(Train_M_left_eye.*Train_M_left_eye)), [nDim,1]) );
%Test_M_left_eye   =  Test_M_left_eye./( repmat(sqrt(sum(Test_M_left_eye.*Test_M_left_eye)), [nDim,1]) );
Train_M_mouse  =  Train_M_mouse./( repmat(sqrt(sum(Train_M_mouse.*Train_M_mouse)), [nDim,1]) );
Test_M_mouse   =  Test_M_mouse./( repmat(sqrt(sum(Test_M_mouse.*Test_M_mouse)), [nDim,1]) );
Train_M_nose  =  Train_M_nose./( repmat(sqrt(sum(Train_M_nose.*Train_M_nose)), [nDim,1]) );
Test_M_nose   =  Test_M_nose./( repmat(sqrt(sum(Test_M_nose.*Test_M_nose)), [nDim,1]) );

cor_gap  = [];
wro_gap  = [];

for ti = 1:size(Test_M_right_eye,2)
    disp(num2str(ti));
    y_right_eye  = Test_M_right_eye(:,ti);
    %y_left_eye  = Test_M_left_eye(:,ti);
    y_mouse  = Test_M_mouse(:,ti);
    y_nose  = Test_M_nose(:,ti);
    [x_right_eye, nIter] = SolveDALM(Train_M_right_eye,y_right_eye, 'lambda',lambda,'tolerance',1e-3); % SolveDALM correspond à Dual Augmented Lagrange Multiplier 
    %[x_left_eye, nIter] = SolveDALM(Train_M_left_eye,y_left_eye, 'lambda',lambda,'tolerance',1e-3); % SolveDALM correspond à Dual Augmented Lagrange Multiplier 
    [x_mouse, nIter] = SolveDALM(Train_M_mouse,y_mouse, 'lambda',lambda,'tolerance',1e-3); % SolveDALM correspond à Dual Augmented Lagrange Multiplier 
    [x_nose, nIter] = SolveDALM(Train_M_nose,y_nose, 'lambda',lambda,'tolerance',1e-3); % SolveDALM correspond à Dual Augmented Lagrange Multiplier 
    y_add_right_eye = Train_M_right_eye(:,nNum+1:end)*x_right_eye(nNum+1:end,1);
    %y_add_left_eye = Train_M_left_eye(:,nNum+1:end)*x_left_eye(nNum+1:end,1);
    y_add_mouse = Train_M_mouse(:,nNum+1:end)*x_mouse(nNum+1:end,1);
    y_add_nose = Train_M_nose(:,nNum+1:end)*x_nose(nNum+1:end,1);
    for ci = 1:nCls
        class = label(ci);
        cdat_right_eye = Train_M_right_eye(:,train_label==class);
        %cdat_left_eye = Train_M_left_eye(:,train_label==class);
        cdat_mouse = Train_M_mouse(:,train_label==class);
        cdat_nose = Train_M_nose(:,train_label==class);
        er_right_eye   = y_right_eye - cdat_right_eye*x_right_eye(train_label==class) - y_add_right_eye;
        %er_left_eye   = y_left_eye - cdat_left_eye*x_left_eye(train_label==class) - y_add_left_eye;
        er_mouse   = y_mouse - cdat_mouse*x_mouse(train_label==class) - y_add_mouse;
        er_nose   = y_nose - cdat_nose*x_nose(train_label==class) - y_add_nose;
        gap_right_eye(ci) = er_right_eye(:)'*er_right_eye(:); % correspond à ei page5 du paper je pense ou alors un vecteur qui contint tout les ei
        %gap_left_eye(ci) = er_left_eye(:)'*er_left_eye(:); % correspond à ei page5 du paper je pense ou alors un vecteur qui contint tout les ei
        gap_mouse(ci) = er_mouse(:)'*er_mouse(:); % correspond à ei page5 du paper je pense ou alors un vecteur qui contint tout les ei
        gap_nose(ci) = er_nose(:)'*er_nose(:); % correspond à ei page5 du paper je pense ou alors un vecteur qui contint tout les ei
    end
    gap_1 = (0.75)*gap_right_eye + (0.55)*gap_mouse + (0.53)*gap_nose; % ATTENTION peut être il faudrait pondéré par la confiance que l'on peut accorder à chaque features ( les eyes ont eu de meilleurs résulats par exemple).
    gap_2 = (0.85)*gap_right_eye + (0.55)*gap_mouse + (0.53)*gap_nose;
    gap_3 = (0.95)*gap_right_eye + (0.55)*gap_mouse + (0.53)*gap_nose;
    gap_4 = (0.75)*gap_right_eye + (0.60)*gap_mouse + (0.53)*gap_nose;
    gap_5 = (0.75)*gap_right_eye + (0.65)*gap_mouse + (0.53)*gap_nose;
    gap_6 = (0.75)*gap_right_eye + (0.70)*gap_mouse + (0.53)*gap_nose;
    gap_7 = (0.75)*gap_right_eye + (0.55)*gap_mouse + (0.60)*gap_nose;
    gap_8 = (0.75)*gap_right_eye + (0.55)*gap_mouse + (0.65)*gap_nose;
    gap_9 = (0.75)*gap_right_eye + (0.55)*gap_mouse + (0.70)*gap_nose;
    %keyboard;
    for gapi=1:9
        gap = strcat('gap',gapi);
        disp(gap);
        index = find(gap == min(gap)); % ne suffirait-il pas de sommmer les gaps de chacun des features et ensuite faire le min sur la somme ?
        currentID = strcat('ID_',gapi);
        disp(currentID);
        currentID(ti) = label(index(1));
    end
end
for gapi=1:9
    currentRate = strcat('correct_rate_',gapi);
    disp(currentRate);
    currentRate = sum(ID==test_label)/length(test_label);
end
