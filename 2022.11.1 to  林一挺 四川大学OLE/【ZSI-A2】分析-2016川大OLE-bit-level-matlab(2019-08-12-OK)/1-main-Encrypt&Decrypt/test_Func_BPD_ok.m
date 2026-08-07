
clear;clc;close all;

%% Case 1. a matrix of size 2*2 
P=[0,129; 128,0]

A=Func_BitPlane_Decomposition(P)

[height,width] = size(P);
C=Func_BitPlane_Composition(A(1,:),A(2,:),height,width)

%% Case 2. a gray image of size 256*256

P=imread('./images/Lena.bmp');        %256*256黑白图像
A=Func_BitPlane_Decomposition(P);

[height,width] = size(P);
C=Func_BitPlane_Composition(A(1,:),A(2,:),height,width);

%****************绘图**************************
figure(2);
subplot(2,2,1);imshow(P);title('明文图像');       
subplot(2,2,2);imhist(P);title('直方图');      
subplot(2,2,3);imshow(uint8(C));title('密文图像');       
subplot(2,2,4);imhist(uint8(C));title('直方图'); 
%****************************************************