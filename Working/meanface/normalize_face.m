%% normalize to meanface
function [J,nlandmark] = normalize_face(im,landmark,meanface)   %landmark [1*10]

ps = 5;
meanface = meanface(1:2*ps);

faceps = length(landmark)/2;
disp(faceps);
landmark = reshape(landmark,[2,faceps]);

facepoints = landmark(:,1:ps);
face_center = mean(facepoints,2);

meanface = reshape(meanface,[2,ps]);
meanface = meanface-repmat(mean(meanface,2),[1,ps]);

C = comatrix(meanface); %=inv(M'M)M'
Ta = affMatrix(C,facepoints);
Ta = [1 0 face_center(1);0 1 face_center(2);0 0 1]*Ta;
tform = maketform('affine',Ta');

% J = imtransform(im,tform,'XData',[1 size(im,2)],'YData',[1 size(im,1)]);
% tface = zeros(3,faceps);%
% for j=1:faceps
%     tface(:,j) = Ta*[landmark(1,j) landmark(2,j) 1]';
% end
% nlandmark = reshape(tface(1:2,:),1,faceps*2);

[J,xdata,ydata] = imtransform(im,tform,'XYScale',1);

tface = zeros(3,faceps);%
for j=1:faceps
    tface(:,j) = Ta*[landmark(1,j) landmark(2,j) 1]'-[xdata(1);ydata(1);0];%必须使用中间变量
end
nlandmark = reshape(tface(1:2,:),1,faceps*2);

return

