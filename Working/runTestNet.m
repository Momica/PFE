clear all
close all
clc

name='bboxOrigin.txt';
result='result.bin';
cmd = ['TestNet.exe ',name,' D:\Study\GraduationProject\Code\ExperimentImages',' Input ',result];
try
    system(cmd);
catch err
    printf('-----------------');
end