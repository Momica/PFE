function Ta=affMatrix1(A,faceshape)
[d ps]=size(faceshape);
faceshape=reshape(faceshape,ps*d,1);
x=A*faceshape;
%
x(1)=131.145;
x(2)=121.474;
x(3)=1.0184;
x(4)=0.0280725;
s=sqrt(x(4)^2+x(3)^2);
% tant=x(4)/x(3);
% tant=atan(tant);
% if abs(cos(tant))>abs(sin(tant))
%    s=x(3)/cos(tant);
% else
%    s=x(4)/sin(tant);
% end

iscos=x(3)/s^2;
issin=x(4)/s^2;
Ta=[iscos issin -x(1)*iscos-x(2)*issin; -issin iscos -x(2)*iscos+issin*x(1);0 0 1];