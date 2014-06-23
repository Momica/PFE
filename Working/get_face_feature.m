function [feature] = get_face_feature(im,landmark,mapping,mode,patchMesh,patchSize,opl)%,FeaExtrFun

%% lbp
% patchSize = 19;
% patchMesh = [5,5];
% opl = 2; % 4
onePatchNum = patchMesh(1)*patchMesh(2);
patchNum = length(landmark)/2*patchMesh(1)*patchMesh(2);
featureDim = mapping.num;

landmarknum = length(landmark)/2;

feature = zeros(patchNum,featureDim);

% % complete the image
% parity = mod(patchMesh,2);
% [imh, imw] = size(im);
% comMinX = min(landmark(1)-(patchMesh(2)-1)/2*patchSize-(patchSize-1)/2,landmark(7)-(patchMesh(2)-1)/2*patchSize-(patchSize-1)/2)-3-opl;
% comMaxX = max(max(landmark(3)+(patchMesh(2)-1)/2*patchSize+(patchSize-1)/2,landmark(9)+(patchMesh(2)-1)/2*patchSize+(patchSize-1)/2),...
%     landmark(5)+(patchMesh(2)-1)/2*patchSize+(patchSize-1)/2)+3+opl;
% comMinY = min(landmark(2)-(patchMesh(1)+1)/2*patchSize-(patchSize-1)/2,landmark(4)-(patchMesh(1)+1)/2*patchSize-(patchSize-1)/2)-3-opl;
% comMaxY = max(landmark(8)+(patchMesh(1)-2-parity(1))/2*patchSize+(patchSize-1)/2,landmark(10)+(patchMesh(1)-2-parity(1))/2*patchSize+(patchSize-1)/2)+3+opl;
% 

% complete the image
parity = mod(patchMesh,2);
[imh, imw] = size(im);

minlandmarkx = min(landmark(1:2:end));
maxlandmarkx = max(landmark(1:2:end));

minlandmarky = min(landmark(2:2:end));
maxlandmarky = max(landmark(2:2:end));

comMinX = minlandmarkx-(patchMesh(2)-parity(2))/2*patchSize-(patchSize-1)/2-3-opl;
comMaxX = maxlandmarkx+(patchMesh(2)-parity(2))/2*patchSize+(patchSize-1)/2+3+opl;
comMinY = minlandmarky-(patchMesh(1)+parity(1))/2*patchSize-(patchSize-1)/2-3-opl;
comMaxY = maxlandmarky+(patchMesh(1)-parity(1))/2*patchSize+(patchSize-1)/2+3+opl;

comMinX = round(comMinX);
comMaxX = round(comMaxX);
comMinY = round(comMinY);
comMaxY = round(comMaxY);

if (comMinX<1) | (comMaxX>imw) | (comMinY<1) | (comMaxY>imh)
    timw = imw - min(comMinX,0) + max(comMaxX-imw,0);
    timh = imh -min(comMinY,0) + max(comMaxY-imh,0);
    temim = ones(timh,timw);
    temim(1-min(comMinY,0): imh-min(comMinY,0),1-min(comMinX,0):imw-min(comMinX,0)) = im;
    
    landmark = landmark+repmat([-min(comMinX,0),-min(comMinY,0)],1,landmarknum);
    im = temim;
end

% figure,imshow(im,[]);
for i = 1:landmarknum
     startxMesh = landmark(2*i-1)-(patchMesh(2)-1)/2*patchSize-(patchSize-1)/2;
     endxMesh = landmark(2*i-1)+(patchMesh(2)-1)/2*patchSize+(patchSize-1)/2;
     startyMesh = landmark(2*i)-(patchMesh(1)+parity(1))/2*patchSize-(patchSize-1)/2;
     endyMesh = landmark(2*i)+(patchMesh(1)-2-parity(1))/2*patchSize+(patchSize-1)/2;
     [gridX,gridY] = meshgrid(startxMesh:patchSize:endxMesh,startyMesh:patchSize:endyMesh);
     gridX = round(gridX(:));
     gridY = round(gridY(:));
     gridXend = gridX+patchSize-1;
     gridYend = gridY+patchSize-1;
     for ii=1:onePatchNum;
         tim = im(gridY(ii)-opl:gridYend(ii)+opl,gridX(ii)-opl:gridXend(ii)+opl);%
         feature((i-1)*onePatchNum+ii,:) = lbp(tim,2,8,mapping,mode);
%         rectangle('Position',[gridX(ii),gridY(ii),patchSize,patchSize],'Curvature',[0 0],'EdgeColor','g');
     end
     
end

%% hog
% patchSize = 19;
% patchMesh = [7,5];
% onePatchNum = patchMesh(1)*patchMesh(2);
% patchNum = length(landmark)/2*patchMesh(1)*patchMesh(2);
% featureDim = 144;
% 
% landmarknum = length(landmark)/2;
% 
% feature = zeros(patchNum,featureDim);
% 
% % complete the image
% [imh, imw] = size(im);
% comMinX = min(landmark(1)-(patchMesh(2)-1)/2*patchSize-(patchSize-1)/2,landmark(7)-(patchMesh(2)-1)/2*patchSize-(patchSize-1)/2)-1;
% comMaxX = max(max(landmark(3)+(patchMesh(2)-1)/2*patchSize+(patchSize-1)/2,landmark(9)+(patchMesh(2)-1)/2*patchSize+(patchSize-1)/2),...
%     landmark(5)+(patchMesh(2)-1)/2*patchSize+(patchSize-1)/2)+1;
% comMinY = min(landmark(2)-(patchMesh(1)+1)/2*patchSize-(patchSize-1)/2,landmark(4)-(patchMesh(1)+1)/2*patchSize-(patchSize-1)/2)-1;
% comMaxY = max(landmark(8)+(patchMesh(1)-3)/2*patchSize+(patchSize-1)/2,landmark(10)+(patchMesh(1)-3)/2*patchSize+(patchSize-1)/2)+1;
% 
% if (comMinX<1) | (comMaxX>imw) | (comMinY<1) | (comMaxY>imh)
%     timw = imw - min(comMinX,0) + max(comMaxX-imw,0);
%     timh = imh -min(comMinY,0) + max(comMaxY-imh,0);
%     temim = ones(timh,timw);
%     temim(1-min(comMinY,0): imh-min(comMinY,0),1-min(comMinX,0):imw-min(comMinX,0)) = im;
%     
%     landmark = landmark+repmat([-min(comMinX,0),-min(comMinY,0)],1,landmarknum);
%     im = single(temim);
% end
% 
% 
% % figure,imshow(im);
% for i = 1:landmarknum
% 
%      startxMesh = landmark(2*i-1)-(patchMesh(2)-1)/2*patchSize-(patchSize-1)/2;
%      endxMesh = landmark(2*i-1)+(patchMesh(2)-1)/2*patchSize+(patchSize-1)/2;
%      startyMesh = landmark(2*i)-(patchMesh(1)+1)/2*patchSize-(patchSize-1)/2;
%      endyMesh = landmark(2*i)+(patchMesh(1)-3)/2*patchSize+(patchSize-1)/2;
%      [gridX,gridY] = meshgrid(startxMesh:patchSize:endxMesh,startyMesh:patchSize:endyMesh);
%      gridX = gridX(:);
%      gridY = gridY(:);
%      gridXend = gridX+patchSize-1;
%      gridYend = gridY+patchSize-1;
%      for ii=1:onePatchNum;
%          tim = im(gridY(ii):gridYend(ii),gridX(ii):gridXend(ii));
%          feature((i-1)*onePatchNum+ii,:) = reshape(hog(tim,8,9),[1 144]);
% %         rectangle('Position',[gridX(ii),gridY(ii),patchSize,patchSize],'Curvature',[0 0],'EdgeColor','g');
%      end
%      
% end    

%% sift
% patchMesh = [7,5];
% onePatchNum = patchMesh(1)*patchMesh(2);
% patchNum = length(landmark)/2*patchMesh(1)*patchMesh(2);
% 
% % sift setting
% patchSize = 16;
% gridSpace = 10;
% featureDim = 128;
% nrml_threshold = 1;
% 
% xHalfLen = (4*gridSpace+patchSize)/2;
% %((patchMesh(2)-1)*gridSpace+patchSize)/2;
% 
% yupLen = 4*gridSpace+patchSize/2-1;
% % ((patchMesh(1)-1)/2)*gridSpace+patchSize+patchSize/2-1;
% ydownLen = gridSpace+patchSize/2;
% % ((patchMesh(1)-5)/2)*gridSpace+patchSize+patchSize/2-1;
% 
% landmarknum = length(landmark)/2;
% 
% feature = zeros(patchNum,featureDim);
% 
% % complete the image
% [imh, imw] = size(im);
% 
% comMinX = min(landmark(1)-(patchMesh(2)-1)/2*patchSize-(patchSize-1)/2,landmark(7)-(patchMesh(2)-1)/2*patchSize-(patchSize-1)/2)-1;
% comMaxX = max(max(landmark(3)+(patchMesh(2)-1)/2*patchSize+(patchSize-1)/2,landmark(9)+(patchMesh(2)-1)/2*patchSize+(patchSize-1)/2),...
%     landmark(5)+(patchMesh(2)-1)/2*patchSize+(patchSize-1)/2)+1;
% comMinY = min(landmark(2)-(patchMesh(1)+1)/2*patchSize-(patchSize-1)/2,landmark(4)-(patchMesh(1)+1)/2*patchSize-(patchSize-1)/2)-1;
% comMaxY = max(landmark(8)+(patchMesh(1)-3)/2*patchSize+(patchSize-1)/2,landmark(10)+(patchMesh(1)-3)/2*patchSize+(patchSize-1)/2)+1;
% 
% if (comMinX<1) | (comMaxX>imw) | (comMinY<1) | (comMaxY>imh)
%     timw = imw - min(comMinX,0) + max(comMaxX-imw,0);
%     timh = imh -min(comMinY,0) + max(comMaxY-imh,0);
%     temim = ones(timh,timw);
%     temim(1-min(comMinY,0): imh-min(comMinY,0),1-min(comMinX,0):imw-min(comMinX,0)) = im;
%     
%     landmark = landmark+repmat([-min(comMinX,0),-min(comMinY,0)],1,landmarknum);
%     im = temim;
% end
% 
% %figure,imshow(im);
% for i = 1:landmarknum
%      startxMesh = landmark(2*i-1)-xHalfLen;
%      endxMesh = landmark(2*i-1)+xHalfLen-patchSize;
%      startyMesh = landmark(2*i)-yupLen;
%      endyMesh = landmark(2*i)+ydownLen;
%      
%      [gridX,gridY] = meshgrid(startxMesh:gridSpace:endxMesh,startyMesh:gridSpace:endyMesh);
%   
%      siftArr = sp_find_sift_grid(im, gridX, gridY, patchSize, 0.8);
%      [siftArr, siftlen] = sp_normalize_sift(siftArr, nrml_threshold);
%      feature((i-1)*onePatchNum+1:i*onePatchNum,:) = siftArr;
% 
% end