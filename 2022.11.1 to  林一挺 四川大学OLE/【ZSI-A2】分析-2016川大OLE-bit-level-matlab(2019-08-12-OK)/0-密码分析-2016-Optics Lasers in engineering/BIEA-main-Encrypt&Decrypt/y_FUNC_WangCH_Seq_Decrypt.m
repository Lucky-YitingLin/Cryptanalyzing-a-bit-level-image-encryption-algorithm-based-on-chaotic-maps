% 程序描述：2018-IJBC-WangCH-图像加密论文实验
% 2018-International Journal of Bifurcation & Chaos-Wang CH-A New Chaotic Image Encryption Scheme Using Breadth-First Search and Dynamic Diffusion
% by whp 2018.5.28
% reshape函数是按列读取，如果需要按行读取，结合P=P'，即转置矩阵

clear;clc;close all;
%% step1：初始化及输入图像
% CASE1：读入图像
% P1=imread('../images/Lena.bmp');
C1=imread('../images/EncryptImg.bmp'); 
[W,H]=size(C1);
L=W*H;
C2=C1';
C3=reshape(C2,1,L);
C=double(C3);

%% step2：调用加密图像函数（临时获得加密机的使用权）
tic
% C=FUNC_WangCH_Seq_Encrypt(P);
P=FUNC_WangCH_Seq_Decrypt(C);
toc

%% step3：绘制图像
N=sqrt(L);
P0=reshape(P,N,N);
P1=P0';
C0=reshape(C,N,N);
C1=C0';
figure(1);  
subplot(2,2,1);imshow( uint8(C1) );title('密文图像C');
subplot(2,2,2);imhist( uint8(C1) );title('C直方图'); 
subplot(2,2,3);imshow( uint8(P1) );title('解密图像P');   
subplot(2,2,4);imhist( uint8(P1) );title('P直方图'); 