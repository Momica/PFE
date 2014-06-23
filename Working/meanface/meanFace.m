function meanface=meanFace
filename='meanFaceTrainingFile.txt';%'CAS-PEAL-train-sample.txt';%'muct76-afternorm.csv'
tor=1e-5;
maxiter=50;
ps=77;

A=TextToPoints(filename,ps);
[N ps]=size(A);
nPic=N/2;
tA=zeros(nPic,ps*2);

%% distribution
% mp=max(A');
% maxp=find(mp>260);
% pd=zeros(260,260);
% for i=1:nPic
%     for j=1:ps
%         pd(A(i*2,j),A((i-1)*2+1,j))= pd(A(i*2,j),A((i-1)*2+1,j))+1;
%     end
% end

%%

% avf=sum(A,2)/ps;
% avf=diag(avf);
% A=A-avf*ones(N,ps);

firstFace=1;
meanface=A((firstFace-1)*2+1:2*firstFace,:);
meanface=reshape(meanface,ps*2,1);
e=1;
iter=1;
while e>tor
    %����ƽ������Ӧ��ϵ������
    %���Ļ�
    meanface=reshape(meanface,2,ps);
    acs=sum(meanface,2)/ps;
    meanface=meanface-[acs(1)*ones(1,ps); acs(2)*ones(1,ps)];
    C=comatrix(meanface);%=inv(M'M)M'
    meanface=reshape(meanface,ps*2,1);
    for i=1:nPic
        %��ÿ������Ͷ��ƽ������
        faceshape=A((i-1)*2+1:i*2,:);
        Ta=affMatrix(C,faceshape);
        tface=zeros(3,ps);%
        for j=1:ps
            tface(:,j)=Ta*[faceshape(1,j) faceshape(2,j) 1]';%����ʹ���м����
        end
        tA(i,:)=reshape(tface(1:2,:),1,ps*2);
    end
    %����ƽ����״�õ��µ�ƽ����cmeanface
    cmeanface=sum(tA)/nPic;
    %���Ļ�
    cmeanface=reshape(cmeanface,2,ps);
    acs=sum(cmeanface,2)/ps;
    cmeanface=cmeanface-[acs(1)*ones(1,ps); acs(2)*ones(1,ps)];
    cmeanface=reshape(cmeanface,ps*2,1);
    %����cmeanface��meanface�Ĳ�
    e=norm(cmeanface-meanface)
    %�ж���״���Ƿ�������ֹ����
    iter=iter+1;
    if iter>maxiter
        break;
    end
    %����meanface
    meanface=cmeanface';
end
fprintf('error = %f\n',e);
fprintf('iter = %d\n',iter);
%save
savename='TrainMeanface.txt';
wfid=fopen(savename,'wt');
if wfid==-1
    fprintf('error in save meanface\n');
    return;
end
for i=1:ps*2
    fprintf(wfid,'%f ',meanface(i));
end
%fprintf(wfid,'\n');
fclose(wfid);
%show
meanface=reshape(meanface,2,ps);
plot(meanface(1,:),-meanface(2,:),'.','MarkerSize',15)




