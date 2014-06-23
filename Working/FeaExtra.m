function [fea,lable]=FeaExtra(algparam,fparam)

%% face similar trans
idimage_name = 'dictionary/idimage200'; % 平均脸信息
load(idimage_name);  % id database info
meanface = idimage.meanface;
addpath('meanface');  % face normalization

%% LBP SETTING
addpath('lbp');       %lbp
mapping = getmapping(8,'u2'); 
mode = 'h';
fd = mapping.num;

%% face detect and alignment

%% im preprocessing
% addpath('normalize'); % for image preprocessing

lable = {};
fea = [];

fid = fopen(fparam.listDir);
if fid ==-1
    fprintf('can not open file %s\n',fparam.listDir);
    return;
end

imindex = 1;
while ~feof(fid)
    
    sline = fgetl(fid);
    fps = fullfile(fparam.imDir,sline); % face rect and lable
    ffid = fopen(fps);
    if ffid == -1
        fprintf('can not open file %s\n',fps);
        return;
    end
    % imread
    imname = [fps(1:end-2),'jpg'];
    if ~exist(imname)
        continue;
    end
    im = imread(imname);
    
%     % genrate imagelist
%     imlistfid = fopen('imagelist.txt','wt');
%     if imlistfid == -1
%         fprint('error');
%     end
%     fprintf(imlistfid,'%d\n',1);
%     imdir = [imname];
%     fprintf(imlistfid,'%s',imdir);
%     fclose(imlistfid);
% 
%     cmd = 'FacePartDetect.exe code_face_data imagelist.txt bbox.txt';
%     system(cmd);
%     bboxfid = fopen('bbox.txt');
%     if bboxfid ==-1
%         fprintf('error\n');
%     end
%     df = [];
%     while ~feof(bboxfid)
%         bsline = fgetl(bboxfid);
%         sdf = regexp(bsline, '\s+', 'split');
%         if length(sdf)>2
%             ndf = [str2num(sdf{2}),str2num(sdf{3}),str2num(sdf{4}),str2num(sdf{5})];
%             df = [df;ndf];
%         end
%     end
%     fclose(bboxfid);
    
%     faceDetector = vision.CascadeObjectDetector();
%     bbox = step(faceDetector, test_image);
      
    if size(im,3)>1
        im =rgb2gray(im);
    end
    
    while ~feof(ffid)
        fsline = fgetl(ffid);
        if fsline == -1 % no face
           break;
        end
        fs = regexp(fsline, '\s+', 'split');
        fr = fs(2:5);
        lx = str2num(fr{1}); ly = str2num(fr{2});
        rx = str2num(fr{3}); ry = str2num(fr{4});
        if strcmp(fs{end},'unknown')
            continue;
        end
        lable = [lable;fs{end}];
        % face
        h=figure;imshow(im);
        hold on,scatter([lx,rx],[ly,ry],'*','y');
        
        fprintf('%d\n',imindex);
        imindex = imindex+1;
        
        % get 5 ps
        % face detect
        eyedis = rx-lx;
        fx = max(lx-eyedis*0.6,1);
        fy = max(min(ly,ry)-eyedis*0.6,1);
        fxe = min(rx+eyedis*0.6,size(im,2));
        fye = min(max(ly,ry)+eyedis*1.8,size(im,1));
        fx = round(fx);
        fxe = round(fxe);
        fy = round(fy);
        fye = round(fye);
        rectangle('Position',[fx,fy,fxe-fx,fye-fy],'Curvature',[0 0],'EdgeColor','g');
        
        bboxfid = fopen('bbox.txt','wt');
        if bboxfid ==-1
            fprintf('error\n');
        end
        [ig1,imn,imtype] = fileparts(imname);
        fprintf(bboxfid,'%s %d %d %d %d',[imn,imtype],fx,fxe,fy,fye);
        fclose(bboxfid);
        
        cmd = ['TestNet.exe bbox.txt ',fparam.imDir, ' Input result.bin'];
        system(cmd);
        % read 5 ps
        fr=fopen('result.bin','rb');
        imageNum = fread(fr, 1, 'int32');
        pointNum = fread(fr, 1, 'int32');
        assert(pointNum == 5);
        valid = fread(fr, imageNum, 'int8');
        assert(all(valid) == 1);
        point = reshape(fread(fr, 2 * pointNum * imageNum, 'float64'), [2 * pointNum, imageNum]);
        fclose(fr);
        hold on,scatter(point(1:2:end),point(2:2:end),'*','r');
        drawnow;
        
        idimfea = FaceFea(im,point,algparam,meanface,mapping,mode);
        fea = [fea,idimfea];
        close(h);
        
%        if ~isempty(df)
%             rectangle('Position',[df(1,1),df(1,3),df(1,2)-df(1,1),df(1,4)-df(1,3)],'Curvature',[0 0],'EdgeColor','g');
%        end
        
    end
    fclose(ffid);
    
end
fclose(fid);



function imfea = FaceFea(im,landmark,algparam,meanface,mapping,mode)

patchSize = algparam.patchSize;
patchMesh = algparam.patchMesh;
centered = algparam.centered;
scale = algparam.scale;
olp = algparam.olp;
% 
%   figure,imshow(im);
%   hold on,scatter(landmark(1:2:end),landmark(2:2:end),'*','r'); 
    
[nim,nlandmark] = normalize_face(im,landmark,meanface);%*1.2
nlandmark = round(nlandmark);

%     H = fspecial('gaussian',5,1);
%     nim = imfilter(nim,H);

%     figure,imshow(nim);
%     hold on,scatter(nlandmark(1:2:end),nlandmark(2:2:end),'*','y'); 

imfea = [];
for s = 1:length(scale)
    tnim = imresize(nim,scale(s));
    tnlandmark = round(nlandmark*scale(s));

    if centered == 1
        patchFea = get_face_feature_s(tnim,tnlandmark,mapping,mode,patchMesh,patchSize);
    else
        patchFea = get_face_feature(tnim,tnlandmark,mapping,mode,patchMesh,patchSize,olp);
    end

    imfea = [imfea; patchFea];%      
end
imfea = reshape(imfea',size(imfea,1)*size(imfea,2),1);
