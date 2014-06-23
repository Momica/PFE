% 2014 05 22
% id pic feature extraction using code_face and code_point

function [idfea,picfea,label] = idpicFeaExtra(algparam,fparam)
fprintf('debut du programm');
findex=fopen('indexingFoundNotFound.txt','w');
global facefound;
facefound = 0;
global facenotfound;
facenotfound = 0;
%% face similar trans
% set the mean face for the normalization
idimage_name = 'dictionary/idimage200'; % modify here if you want an other mean face
load(idimage_name);  % id database info
meanface = idimage.meanface;
addpath('meanface');  % Add the folder "meanface" to the path 

%% LBP SETTING
addpath('lbp');       %lbp
mapping = getmapping(8,'u2'); %GETMAPPING returns a structure containing a mapping table for LBP codes. 'u2' for uniform lbp
mode = 'h';
fd = mapping.num;

%% face detect and alignment

%% im preprocessing
% addpath('normalize'); % for image preprocessing

label = []; % name of the subject ?
idfea = []; % type of feature ?
picfea = []; % feature ?

iddir = dir(fullfile(fparam.idDir,'*.png')); % read all the image 
for id = 1:length(iddir) % process the image one by one
    idimname = iddir(id).name; % retrive the name of the current image
    name = idimname(1:end-4); % remove '.jpg' ?
    
    % read id image 
    % generate imagelist
    idimname = fullfile(fparam.idDir,idimname); 
    % retrieve the 5 key points ( eyes, mouse extremties, nose )
    points = Get5Points(idimname,fparam.idDir);
    if isempty(points)
        facenotfound = facenotfound + 1;
        fprintf(findex,'photonumber %d  idperson %d found %d\n',id, fix((id-1)/20)+1,0);
    else 
        facefound = facefound + 1;
        fprintf(findex,'photonumber %d  idperson %d found %d\n',id, fix((id-1)/20)+1,1);
    end
end
fprintf(' ==============RESULT===============\n');
fprintf(' face found = %d , face not found = %d', facefound, facenotfound);
fclose(findex);


% function to get 5 key points
function  points = Get5Points(idimname,imDir)

imlistfid = fopen('imagelist.txt','wt');
if imlistfid == -1
    fprintf('reading image error');
end
fprintf(imlistfid,'%d\n',1);
fprintf(imlistfid,'%s',idimname);
fclose(imlistfid);
cmd = 'FacePartDetect.exe code_face_data imagelist.txt bbox.txt'; % install wine if on mac and remove wine on windows
system(cmd);
bboxfid = fopen('bbox.txt');
if bboxfid ==-1
    fprintf('error\n');
end
df = [];
while ~feof(bboxfid)
    bsline = fgetl(bboxfid);
    sdf = regexp(bsline, '\s+', 'split');
    if length(sdf)>2
        ndf = [str2num(sdf{2}),str2num(sdf{3}),str2num(sdf{4}),str2num(sdf{5})];
        df = [df;ndf];
    end
end
fclose(bboxfid);
if isempty(df)
    fprintf('can not find face in %s.\n',idimname);
    points = [];
    return;
else
    points= [1,1,1,1,1];
    return;
end 


