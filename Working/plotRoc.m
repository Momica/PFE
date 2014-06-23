% clear;

% simFile = 'testset\All\feat_graph_All.txt';
simFile = 'testset\All_sel\feat_graph.txt';

fid = fopen(simFile);
if fid ==-1
    fprintf('can not open file %s\n',simFile);
end

dis = [];
label = {};
while ~feof(fid)
    sline = fgetl(fid);
    s = sline(7:end);
    i = 1;
    while s(i) ~= ' '
        i= i+1;
    end
    label = [label;s(1:i-1)];
    s = s(i:end);
    sdis = str2num(s);
    dis = [dis;sdis];
    
end

fclose(fid);

sim = dis(1:end,3:end);

imnum = length(label);
tm = zeros(imnum,imnum);

for i = 1:imnum
    for j = 1:imnum
        if strcmp(label(i),label(j))
           tm(i,j) = 1;
        end
    end
end

addpath('eval')

confs = sim(:);
tp = tm(:);

[tpr,fpr,thresh] = icg_roc(tp',confs');
rocM1 = [tpr;fpr];
figure,plot(fpr, tpr,'b');
grid on

