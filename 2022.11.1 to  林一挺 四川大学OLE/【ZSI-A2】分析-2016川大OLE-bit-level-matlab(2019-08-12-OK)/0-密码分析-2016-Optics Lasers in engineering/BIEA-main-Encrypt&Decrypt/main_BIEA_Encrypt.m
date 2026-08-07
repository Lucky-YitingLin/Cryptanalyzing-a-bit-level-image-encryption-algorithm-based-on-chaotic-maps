% 程序描述：2018-Optics&Lasers in Engineering-BIEA-图像加密实验
% 2016-Optics and Lasers in Engineering-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% by whp 2018.6.17
% 加密过程： 明文图像A -> 两个位平面A1和A2 -> Diffusion by PWLCM 1st：B1和B2 
% -> Confusion by PWLCM 2nd: C1和C2 -> 密文图像C


%% step0.1：读取明文图像P1
clear;clc;close all;
tic
P1=imread('../images/Lena.bmp');        %256*256黑白图像
% P1=imread('../images/allSamegray.bmp');
% P1=imread('../images/allBlack.bmp');
% P1=imread('../images/allWhite.bmp');

figure(1);
subplot(2,2,1);imshow( uint8(P1) );title('明文图像P');   
subplot(2,2,2);imhist( uint8(P1) );title('P直方图');  
