
% function to get 5 key points
function  points = Get5Points(idimname,imDir)

imlistfid = fopen('imagelist.txt','wt');
if imlistfid == -1
    printf('reading image error');
end
fprintf(imlistfid,'%d\n',1);
fprintf(imlistfid,'%s',idimname);
fclose(imlistfid);
cmd = 'FacePartDetect.exe code_face_data imagelist.txt bbox.txt';
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
end

bboxfid = fopen('bbox.txt','wt');
if bboxfid ==-1
    fprintf('error\n');
end
[ig1,imn,imtype] = fileparts(idimname);
fprintf(bboxfid,'%s %d %d %d %d',[imn,imtype],df(1),df(2),df(3),df(4));
fclose(bboxfid);

cmd = ['TestNet.exe bbox.txt ',imDir, ' Input result.bin'];
system(cmd);
% read 5 ps
fr=fopen('result.bin','rb');
imageNum = fread(fr, 1, 'int32');
pointNum = fread(fr, 1, 'int32');
assert(pointNum == 5);
valid = fread(fr, imageNum, 'int8');
assert(all(valid) == 1);
points = reshape(fread(fr, 2 * pointNum * imageNum, 'float64'), [2 * pointNum, imageNum]);
fclose(fr);
