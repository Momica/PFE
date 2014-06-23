%size(meanface)=[2,ps]
function C=comatrix(meanface)
%ÖÐÐÄ»¯
% current_shape2=meanface';
% pointn=size(meanface,2);
% acs=sum(current_shape2)/pointn;
% current_shape2=current_shape2-[acs(1)*ones(pointn,1) acs(2)*ones(pointn,1)];

ps=size(meanface,2);

% A=zeros(ps*2,4);
% A(:,1)=repmat([1 0]',ps,1);
% A(:,2)=repmat([0 1]',ps,1);
% A(:,3)=reshape(meanface,ps*2,1);
% A(:,4)=reshape([-meanface(2,:); meanface(1,:)],ps*2,1);
% C=inv(A'*A)*A';

x2y2=meanface(2,:)*meanface(2,:)'+meanface(1,:)*meanface(1,:)';
C2=zeros(4,ps*2);
C2(1,:)=repmat([1/ps 0]',ps,1);
C2(2,:)=repmat([0 1/ps]',ps,1);
meanface1=meanface/x2y2;
C2(3,:)=reshape(meanface1,ps*2,1);
C2(4,:)=reshape([-meanface1(2,:); meanface1(1,:)],ps*2,1);
C=C2;

