function [J] = Random_Block_Occlu(I,r_h,r_w,height,width)
J = I;
baroon = rgb2gray(imread('baboon.tif'));
% baroon = baroon./(mean(baroon(:))/mean(I(:)));
r_h    = round(r_h);
r_w    = round(r_w);
J(r_h:r_h+height-1,r_w:r_w+width-1)= imresize(baroon,[height width]);
