%% normalize to meanface
function [J,nlandmark] = normalize_face_s(im,landmark,meanface)   %landmark [1*10]

ps = length(landmark)/2;

landmark = reshape(landmark,[2,ps]);
landmark_center = mean(landmark,2);

meanface = reshape(meanface,[2,ps]);
C = comatrix(meanface); %=inv(M'M)M'
Ta = affMatrix(C,landmark);
Ta = [1 0 landmark_center(1);0 1 landmark_center(2);0 0 1]*Ta;
tform = maketform('affine',Ta');
% [J, xdata, ydata] = imtransform(im,tform);

% imsize = size(im);
% vpos = [1 1 imsize(2) imsize(2); 1 imsize(1) 1 imsize(1); 1 1 1 1];
% for j = 1 : 4
%     vpos(:,j) = Ta * vpos(:,j);
% end
% vmin = min(vpos,[],2);
% vmax = max(vpos,[],2);
[J,xdata,ydata] = imtransform(im,tform,'XYScale',1);

% figure,imshow(J);

tface = zeros(3,ps);%
for j=1:ps
    tface(:,j) = Ta*[landmark(1,j) landmark(2,j) 1]'-[xdata(1);ydata(1);0];%必须使用中间变量
end

nlandmark = reshape(tface(1:2,:),1,ps*2);
% hold on,scatter(meanface(1:2:10)+landmark_center(1),meanface(2:2:10)+landmark_center(2),'*','r');
% hold on,scatter(nlandmark(1:2:10),nlandmark(2:2:10),'*','y');
% title('J')
return

