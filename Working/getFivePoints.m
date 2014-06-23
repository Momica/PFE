clear all
close all
clc

fb=fopen('bboxOrigin.txt');
fr=fopen('result.bin','rb');
fw=fopen('landmarksFace.txt','w');
imageNum = fread(fr, 1, 'int32');
pointNum = fread(fr, 1, 'int32');
assert(pointNum == 5);
valid = fread(fr, imageNum, 'int8');
assert(all(valid) == 1);
point = reshape(fread(fr, 2 * pointNum * imageNum, 'float64'), [2 * pointNum, imageNum]);
for i=1:size(point,2)
    tLine=fgetl(fb);
    sArr=regexp(tLine,' ','split');
    fprintf(fw,'%s %f %f %f %f %f %f %f %f %f %f\n',sArr{1},point(1,i),point(2,i),point(3,i),point(4,i),point(5,i),point(6,i),point(7,i),point(8,i),point(9,i),point(10,i));
end
fclose(fb);
fclose(fr);
fclose(fw);