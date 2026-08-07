%******************************************************************%
% 描述：对彩色RGB图像进行位平面分解，首先分为RGB三个分量，每个分量8个平面
% by whp 2018.3.23-OK
%******************************************************************%

%****************RGB彩色图像位平面分解**************************
clear all;clc;close all;
% P_color=imread('lena.jpg'); 
P_color=imread('fruits.jpg'); 
R = P_color(:,:,1);
G = P_color(:,:,2);
B = P_color(:,:,3);
[height,width] = size(R);
img=uint8(P_color);
bitPI_R = zeros(height,width, 8);  bitPI_G = zeros(height,width, 8);  bitPI_B = zeros(height,width, 8);  
for i = 1:8
    bitPI_R(:,:,i) = bitget(R, i); 
    bitPI_G(:,:,i) = bitget(R, i);
    bitPI_B(:,:,i) = bitget(R, i);
end
R1=bitPI_R(:,:,1);R2=bitPI_R(:,:,2);R3=bitPI_R(:,:,3);R4=bitPI_R(:,:,4);
R5=bitPI_R(:,:,5);R6=bitPI_R(:,:,6);R7=bitPI_R(:,:,7);R8=bitPI_R(:,:,8);
G1=bitPI_G(:,:,1);G2=bitPI_G(:,:,2);G3=bitPI_G(:,:,3);G4=bitPI_G(:,:,4);
G5=bitPI_G(:,:,5);G6=bitPI_G(:,:,6);G7=bitPI_G(:,:,7);G8=bitPI_G(:,:,8);
B1=bitPI_B(:,:,1);B2=bitPI_B(:,:,2);B3=bitPI_B(:,:,3);B4=bitPI_B(:,:,4);
B5=bitPI_B(:,:,5);B6=bitPI_B(:,:,6);B7=bitPI_B(:,:,7);B8=bitPI_B(:,:,8);
%****************************************************

%****************绘图-R**************************
figure(1);
subplot(2,4,1);imshow(R1);title('Pic1');         %位平面1 
subplot(2,4,2);imshow(R2);title('Pic2');
subplot(2,4,3);imshow(R3);title('Pic3');
subplot(2,4,4);imshow(R4);title('Pic4');
subplot(2,4,5);imshow(R5);title('Pic5');
subplot(2,4,6);imshow(R6);title('Pic6');
subplot(2,4,7);imshow(R7);title('Pic7');
subplot(2,4,8);imshow(R8);title('Pic8');
%****************************************************

%****************绘图-G**************************
figure(2);
subplot(2,4,1);imshow(G1);title('Pic1');         %位平面1 
subplot(2,4,2);imshow(G2);title('Pic2');
subplot(2,4,3);imshow(G3);title('Pic3');
subplot(2,4,4);imshow(G4);title('Pic4');
subplot(2,4,5);imshow(G5);title('Pic5');
subplot(2,4,6);imshow(G6);title('Pic6');
subplot(2,4,7);imshow(G7);title('Pic7');
subplot(2,4,8);imshow(G8);title('Pic8');
%****************************************************

%****************绘图-B**************************
figure(3);
subplot(2,4,1);imshow(B1);title('Pic1');         %位平面1 
subplot(2,4,2);imshow(B2);title('Pic2');
subplot(2,4,3);imshow(B3);title('Pic3');
subplot(2,4,4);imshow(B4);title('Pic4');
subplot(2,4,5);imshow(B5);title('Pic5');
subplot(2,4,6);imshow(B6);title('Pic6');
subplot(2,4,7);imshow(B7);title('Pic7');
subplot(2,4,8);imshow(B8);title('Pic8');
%****************************************************

%****************绘图-RGB**************************
figure(4);
subplot(2,2,1);imshow(P_color);title('彩色图');        
subplot(2,2,2);imshow(R);title('R分量');
subplot(2,2,3);imshow(G);title('G分量');
subplot(2,2,4);imshow(B);title('B分量');
%****************************************************