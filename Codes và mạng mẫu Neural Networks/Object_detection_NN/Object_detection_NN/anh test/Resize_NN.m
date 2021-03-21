clear all;

I=imread('153_100.jpg');
% I1=imwrite('')
% clear all;
% f=imread('peppers.png');
% f_gs=rgb2gray(f);
% f_256=imresize(f,0.5);
f_100=imresize(I,[100 100]);
imwrite(f_100,'153_100.jpg','jpg');
%imwrite(f,'pepper_gray.png','png');
%imwrite(f,'pepper_gray.jpg','jpg','Quality',50);