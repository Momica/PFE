function Ta=affinetrans
load final_shape
load current_shape2
imn=zeros(150,150);
im=imread('im.png');
im=double(rgb2gray(im));
pointn=68;

final_shape=final_shape

acs=sum(current_shape2)/pointn;
current_shape2=current_shape2-[acs(1)*ones(pointn,1) acs(2)*ones(pointn,1)];

A=zeros(pointn*2,4);
b=zeros(pointn*2,1);

A(:,1)=repmat([1 0]',pointn,1);
A(:,2)=repmat([0 1]',pointn,1);
A(:,3)=reshape(current_shape2',pointn*2,1);
A(:,4)=reshape([-current_shape2(:,2) current_shape2(:,1)]',pointn*2,1);

b=reshape(final_shape',pointn*2,1);
x=inv(A'*A)*A'*b

tant=x(4)/x(3);
tant=atan(tant)
if abs(cos(tant))>abs(sin(tant))
   s=x(3)/cos(tant)
else
   s=x(4)/sin(tant)
end
% T=[1 0 x(1);0 1 x(2);0 0 1];
% C=[x(3) -x(4) 0;x(4) x(3) 0;0 0 1];
% Ta=inv(T*C);

iscos=x(3)/s^2;
issin=x(4)/s^2;
Ta=[iscos issin -x(1)*iscos-x(2)*issin; -issin iscos -x(2)*iscos+issin*x(1);0 0 1];


% plot(current_shape2(:,1),-current_shape2(:,2),'*')