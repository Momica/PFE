%size(faceshape)=[2,ps]
function Ta=affMatrix(A,faceshape)
[d ps]=size(faceshape);
faceshape=reshape(faceshape,ps*d,1);
x=A*faceshape;
s=sqrt(x(4)^2+x(3)^2);
%
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