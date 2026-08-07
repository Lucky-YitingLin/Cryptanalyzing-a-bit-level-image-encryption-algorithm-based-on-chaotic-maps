% 程序名称：Func_PWLCM(x0,u0,N0,len)
% 2018.6.17 by whp 

clc;clear;close all;
x0=0.3;u0=0.2;N0=100;len=256*256;
XX=Func_PWLCM(x0,u0,N0,len);
X1=mod(floor(XX*10^14),256);

X2=reshape(X1,256,256);
figure(1)
subplot(2,2,1);hist(XX,0:0.0001:1);
subplot(2,2,2);hist(X1,0:255);

subplot(2,2,3);imshow( uint8(X2) );title('掩模图像');   
subplot(2,2,4);imhist( uint8(X2) );title('直方图');  