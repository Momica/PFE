function [D,er]   =   SVDL(Xg,Yg,X,lambda1,lambda2,lambda3,dnum,BnIter,nIter,isShow)
% Function of Sparse Variation Dictionary Learning
% ----------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is here
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
%----------------------------------------------------------------------
%
% INPUT:
%       Xg   The reference SubSet
%       Yg   The Gallary
%       X{i} The ith variation generic training data
%       lambda1  The parameter to regularize projection coding coefficient
%       lambda2  The parameter to regularize the sparse coding coefficient
%       lambda3  The parameter to regularize the sparse dictionary atom
%       dnum     Predefined number of dictionary atoms
%       BnIter   Outer Iternation number 
%       nIter    Inner Iternation number in dictioanry updaing
%       isShow   1: show the curve of objective function value; 0: not show
%       dnum = number of dictionnary atoms
%
% OUTPUT:
%       D   The learned variation dictionary
%       er  The objective function value vector


% initialize projection coefficients, A
A   =  inv(Xg'*Xg + lambda1*eye(size(Xg,2)))*Xg'*Yg;

% initialize D
wayInit         =   'original';
Y   =  [];
for ti = 1:size(X,2)
    Y  = [Y (X{ti}-Xg)*A];
end
YY  =  zeros(size(Y));
for ti = 1:size(X,2)
    YY(:,ti:19:end) = (X{ti}-Xg)*A;
end
D          = Dictionary_Ini(YY,dnum,wayInit);


bn_it           =     0;
er              =     [];

while bn_it < BnIter
    fprintf(['\n']);
    % updating Dictionary, D, and Coding Coefficients
    % note: here we use Iterative Projection Method (IPM) to solve sparse coding
    % Other sparse coding tools could replace IPM
    
    par.initM      =     'last';  % 'zero','transpose','pinv','last',in double_l1
    ipts.last_coef =     zeros(size(D,2),size(Y,2));
    par.nIter      =     200;     %in function double_l1
    par.sigma      =     1.05;     %in function double_l1
    par.isshow     =     true;
    par.twist      =     true;
    par.citeT      =     1e-6;
    par.cT         =     1e+10;

    n_it            =     0;
    while n_it < nIter
        if mod(n_it,3) == 0
        fprintf(['.']);
        end
    
        if size(D,1)>size(D,2)
            par.c        =    par.sigma*find_max_eigenv(D'*D);
        else
            par.c        =    par.sigma*find_max_eigenv(D*D');
        end
        ipts.D      =   D;
        ipts.X      =   Y;
    
        % Coding Coefficients update
        par.tau     =   lambda2;
        par.lambda  =   0;
        par.lastc   =   ipts.last_coef;
        [opts] = Comp_SparseCoding_Simple_Twist (ipts,par);
        coef  = opts.A;
        
        % Fix Coding Coefficients, update D.
        newD        =   [];
        newcoef     =   [];  
        for i =  1:size(D,2)
            ai      =    coef(i,:);
            TemY    =    Y-D*coef+D(:,i)*ai;
            Temc    =    sqrt(ai*ai');
            di      =    TemY*ai';
            if Temc > eps
            di      =    TemY*ai'./(Temc^2);
            di      =    soft(di,lambda3/2/sqrt(Temc));
            end
            if norm(di,2) < 1e-6
            di        =    zeros(size(di));
            else
            di        =    di./norm(di,2);
            newD      =    [newD di];
            newcoef   =    [newcoef;ai];
            end
            D(:,i)  =    di;
        end
    
        D       =    newD;
        coef    =    newcoef;
        ipts.last_coef = coef;
      
        zz           =   Y-D*coef;
        er_now       =   zz(:)'*zz(:)+lambda2*sum(abs(coef(:)))+lambda3*sum(abs(D(:)));
        er_pro       =   norm(Yg-Xg*A,'fro')^2 + lambda1*norm(A,'fro')^2;
        n_it         =   n_it +1;
        er           =   [er er_now+er_pro];
    end

    if isShow
        plot(er,'r-*');
    end
    
    % updating projection coefficients, A
    for ti = 1:size(X,2)
       tem_coef{ti} = coef(:,(ti-1)*size(Yg,2)+1:ti*size(Yg,2)) ;
    end
    TemM1 = Xg'*Xg;
    TemM2 = Xg'*Yg;
    for ti = 1:size(X,2)
        TemM1 = TemM1 + (X{ti}-Xg)'*(X{ti}-Xg);
        TemM2 = TemM2 + (X{ti}-Xg)'*(D*tem_coef{ti});
    end
    A = inv(TemM1 + lambda1*eye(size(TemM1,2)))*TemM2;
    Y   =  [];
    for ti = 1:size(X,2)
        Y  = [Y (X{ti}-Xg)*A];
    end
    bn_it   =  bn_it + 1;
end