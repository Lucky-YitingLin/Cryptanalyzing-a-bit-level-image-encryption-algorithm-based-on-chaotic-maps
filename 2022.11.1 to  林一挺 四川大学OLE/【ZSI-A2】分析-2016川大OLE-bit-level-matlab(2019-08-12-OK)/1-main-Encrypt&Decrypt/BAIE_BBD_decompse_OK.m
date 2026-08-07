% 程序描述：2018-Optics&Lasers in Engineering-BIEA-图像加密实验
% 2016-Optics and Lasers in Engineering-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% by whp 2018.6.17
% 程序描述： 明文图像A -> 两个位平面A1和A2 -> ... C1和C2 -> 密文图像C

%% ****************图像位平面分解**************************
clear;clc;close all;
tic
P=imread('./images/Lena.bmp');        %256*256黑白图像
[height,width] = size(P);
img=uint8(P);
bitPI = zeros(height,width, 8);  
for i = 1:8
    bitPI(:,:,i) = bitget(img, i); 
end
I1=bitPI(:,:,1);I2=bitPI(:,:,2);I3=bitPI(:,:,3);I4=bitPI(:,:,4);
I5=bitPI(:,:,5);I6=bitPI(:,:,6);I7=bitPI(:,:,7);I8=bitPI(:,:,8);

%% stpe1:明文图像P -> A1和A2
% P -> 采用BBD二进制位平面分解 A1和A2 ，顺序为由上到下，由左到右，由高位平面到低位平面
L=4*height*width;
L1=height*width;
A1=zeros(1,L);   %预分配内存
A2=zeros(1,L);   %预分配内存
% A1由高四位的比特组成
rowI8=reshape(I8,1,height*width);rowI7=reshape(I7,1,height*width);
rowI6=reshape(I6,1,height*width);rowI5=reshape(I5,1,height*width);
A1(1,1:L1)=rowI8;A1(1,L1+1:2*L1)=rowI7;A1(1,2*L1+1:3*L1)=rowI6;A1(1,3*L1+1:4*L1)=rowI5;
% A2由低四位的比特组成
rowI4=reshape(I4,1,height*width);rowI3=reshape(I3,1,height*width);
rowI2=reshape(I2,1,height*width);rowI1=reshape(I1,1,height*width);
A2(1,1:L1)=rowI4;A2(1,L1+1:2*L1)=rowI3;A2(1,2*L1+1:3*L1)=rowI2;A2(1,3*L1+1:4*L1)=rowI1;

%% stpe4:C1和C2 -> 密文图像C
% P -> 采用BBD二进制位平面分解 A1和A2 ，顺序为由上到下，由左到右，由高位平面到低位平面
C1=A1;C2=A2;
% C1由转换为高四位 位平面矩阵
rowC8=C1(1,1:L1);rowC7=C1(1,L1+1:2*L1);rowC6=C1(1,2*L1+1:3*L1);rowC5=C1(1,3*L1+1:4*L1);
C_8=reshape(rowC8,height,width);C_7=reshape(rowC7,height,width);
C_6=reshape(rowC6,height,width);C_5=reshape(rowC5,height,width);
% C2由转换为低四位 位平面矩阵
rowC4=C2(1,1:L1);rowC3=C2(1,L1+1:2*L1);rowC2=C2(1,2*L1+1:3*L1);rowC1=C2(1,3*L1+1:4*L1);
C_4=reshape(rowC4,height,width);C_3=reshape(rowC3,height,width);
C_2=reshape(rowC2,height,width);C_1=reshape(rowC1,height,width);
% C1和C2 合并为C
for i=1:height
    for j=1:width
        C(i,j)=C_8(i,j)*2^7+C_7(i,j)*2^6+C_6(i,j)*2^5+C_5(i,j)*2^4+C_4(i,j)*2^3+C_3(i,j)*2^2+C_2(i,j)*2^1+C_1(i,j);
    end
end

%****************绘图**************************
% figure(1);
% subplot(2,4,1);imshow(I1);title('Pic1');         %位平面1 
% subplot(2,4,2);imshow(I2);title('Pic2');
% subplot(2,4,3);imshow(I3);title('Pic3');
% subplot(2,4,4);imshow(I4);title('Pic4');
% subplot(2,4,5);imshow(I5);title('Pic5');
% subplot(2,4,6);imshow(I6);title('Pic6');
% subplot(2,4,7);imshow(I7);title('Pic7');
% subplot(2,4,8);imshow(I8);title('Pic8');
%****************************************************

%****************绘图**************************
figure(2);
subplot(2,2,1);imshow(P);title('明文图像');       
subplot(2,2,2);imhist(P);title('直方图');      
subplot(2,2,3);imshow(uint8(C));title('密文图像');       
subplot(2,2,4);imhist(uint8(C));title('直方图'); 
%****************************************************