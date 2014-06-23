function A=TextToPoints(filename,ps)
%filename='muct76-afternorm.csv';

n=3000;

% [ims data] = textread(filename,'%s%[^\n]','delimiter',',');%
% [data] = textread(filename,'%*s%n','delimiter',',');
 
fid=fopen(filename);
if fid==-1 
    fprintf('error\n');
    return;
end

A=zeros(n,ps);
j=1;
while ~feof(fid)
    s=fgetl(fid);
    i=1;
    while s(i)~=','%strcmp(s(i),',')~=1
            i=i+1;
    end
    s=s(i+1:end);
    for i=1:length(s)
        if s(i)==','
            s(i)=' ';
        end
    end
    A(j:j+1,:)=reshape(str2num(s),2,ps);
    j=j+2;
    % b=reshape(A,2,length(A)/2);
    % plot(b(1,:),-b(2,:),'.');
end
A=A(1:j-1,:);
fclose(fid);


