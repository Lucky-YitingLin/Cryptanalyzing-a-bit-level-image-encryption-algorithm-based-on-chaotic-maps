%******************************************************************%
% 描述：对灰度图进行位平面分解，总共8个平面
% 2011-Information Sciences-A chaos-based symmetric image encryption scheme using a bit-level permutation
% by whp 2018.3.23-OK
% 实验记录：
%  lena512:0.0037    0.0074    0.0149    0.0296    0.0577    0.1033    0.2064    0.5770
%  man512: 0.0044    0.0091    0.0172    0.0376    0.0628    0.1557    0.2153    0.4977
%  对图像置乱后再次计算进行比较
%******************************************************************%

%****************图像位平面分解**************************
clear all;clc;close all;
% A1=imread('lena.tiff');      
A1=imread('man.tiff');
[height,width] = size(A1);
img=uint8(A1);
bitPI = zeros(height,width, 8);  
for i = 1:8
    bitPI(:,:,i) = bitget(img, i); 
end
I1=bitPI(:,:,1);I2=bitPI(:,:,2);I3=bitPI(:,:,3);I4=bitPI(:,:,4);
I5=bitPI(:,:,5);I6=bitPI(:,:,6);I7=bitPI(:,:,7);I8=bitPI(:,:,8);
%****************************************************

%****************绘图**************************
figure(1);
subplot(2,4,1);imshow(I1);title('Pic1');         %位平面1 
subplot(2,4,2);imshow(I2);title('Pic2');
subplot(2,4,3);imshow(I3);title('Pic3');
subplot(2,4,4);imshow(I4);title('Pic4');
subplot(2,4,5);imshow(I5);title('Pic5');
subplot(2,4,6);imshow(I6);title('Pic6');
subplot(2,4,7);imshow(I7);title('Pic7');
subplot(2,4,8);imshow(I8);title('Pic8');
%****************************************************

%****************绘图**************************
figure(2);
subplot(1,2,1);imshow(A1);title('原图');       
subplot(1,2,2);imhist(A1);title('直方图');        
%****************************************************

%******************************************************************%
sumI=zeros(1,8);   %预分配内存
for i=1:width
    for j=1:height
        sumI(1)=sumI(1)+I1(i,j);
        sumI(2)=sumI(2)+I2(i,j);
        sumI(3)=sumI(3)+I3(i,j);
        sumI(4)=sumI(4)+I4(i,j);
        sumI(5)=sumI(5)+I5(i,j);
        sumI(6)=sumI(6)+I6(i,j);                   
        sumI(7)=sumI(7)+I7(i,j);            
        sumI(8)=sumI(8)+I8(i,j);
    end
end
%计算每个位平面图的比例
SUM=sumI(1)+sumI(2)*2+sumI(3)*2^2+sumI(4)*2^3+sumI(5)*2^4+sumI(6)*2^5+sumI(7)*2^6+sumI(8)*2^7;
perI=zeros(1,8);
for k=1:8
    perI(k)=sumI(k)*2^(k-1)/SUM;
end
 perI
%******************************************************************%