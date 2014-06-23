function  meanface = gen_meanface(idimage,id_img_dir)

tor = 1e-5;
maxiter = 50;
firstFace = 1;
landmarknum = 5;
face_dim = 2*landmarknum;

faces = zeros(idimage.imnum,face_dim); %face points [N*10]
tA = zeros(idimage.imnum,face_dim);

%read face points
face_index = 1;
for i = 1:length(idimage.idname),
    subname = idimage.idname{i};
    landmarkfile = fullfile(id_img_dir,subname,idimage.landmarkfile);
    
    fid = fopen(landmarkfile);
    if fid == -1
        fprintf('can not open file %s \n',landmarkfile);
        return;
    end
    
    while ~feof(fid)
        sline = fgetl(fid);
        faces(face_index ,:) = str2num(sline(47:end));
        face_index = face_index +1;
    end
    
    fclose(fid);
    
end

meanface = faces(firstFace,:);
meanface = meanface';

e=1;
iter=1;
while e>tor
    %����ƽ������Ӧ��ϵ������
    %���Ļ�
    meanface = reshape(meanface,2,landmarknum);
    acs = sum(meanface,2)/landmarknum;
    meanface = meanface-[acs(1)*ones(1,landmarknum); acs(2)*ones(1,landmarknum)];
    
    C=comatrix(meanface); %=inv(M'M)M'
    meanface=reshape(meanface,face_dim,1);
    
    for i=1:idimage.imnum
        %��ÿ������Ͷ��ƽ������
        faceshape = reshape(faces(i,:),2,landmarknum);
        Ta = affMatrix(C,faceshape);
        tface = zeros(3,landmarknum);%
        for j=1:landmarknum
            tface(:,j) = Ta*[faceshape(1,j) faceshape(2,j) 1]';%����ʹ���м����
        end
        tA(i,:) = reshape(tface(1:2,:),1,landmarknum*2);
    end
    %����ƽ����״�õ��µ�ƽ����cmeanface
    cmeanface = sum(tA)/idimage.imnum;
    %���Ļ�
    cmeanface = reshape(cmeanface,2,landmarknum);
    acs = sum(cmeanface,2)/landmarknum;
    cmeanface = cmeanface-[acs(1)*ones(1,landmarknum); acs(2)*ones(1,landmarknum)];
    cmeanface = reshape(cmeanface,face_dim,1);
    %����cmeanface��meanface�Ĳ�
    e = norm(cmeanface-meanface);
    %�ж���״���Ƿ�������ֹ����
    iter = iter+1;
    if iter>maxiter
        break;
    end
    %����meanface
    meanface = cmeanface';
end
fprintf('meanface error = %f\n',e);
fprintf('iter = %d\n',iter);
% plot(meanface(1:2:10),-meanface(2:2:10),'.','MarkerSize',15)




