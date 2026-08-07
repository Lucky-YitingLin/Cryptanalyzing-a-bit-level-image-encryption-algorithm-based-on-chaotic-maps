%**********************************************************************************************%
% 2016-OLE-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% 描述：加密算法不是满射，异或解密时存在二值解。为正确解密，令A22(1)=1，A22(1)=0;;
% by whp 2019.8.10
%**********************************************************************************************%

clear;clc;close all;
tic
C=[  77,45; 31,165 ];
% P=[101,129; 28,205];
% P=imread('./images/Lena.bmp');        %256*256黑白图像
[height,width] = size(C); L1=height*width; L=4*height*width;
% C=Func_BitPlane_Composition(A(1,:),A(2,:),height,width)

%% Initialization: generate PRNS1:b1,b2
x0=0.3;u0=1.58;N0=100;
X=Func_Cubic_Logistic(x0,u0,N0,L1);
X=mod(floor(X*10^14),256); X=reshape(X,height,width);
ks_B=Func_BitPlane_Decomposition(X);
ks_b1=ks_B(1,:); ks_b2=ks_B(2,:);

%% BPD
CC=Func_BitPlane_Decomposition(C); B1=CC(1,:); B2=CC(2,:);
% C=Func_BitPlane_Composition(A(1,:),A(2,:),height,width);

%% Stage 2. anti-diffusion: get  A1,A2  from B1,B2by using b1,b2

% step 8-step 10
% A22(1)=1;
A22(1)=0;
for i=2:L
    A22(i)= bitxor( bitxor(bitxor(B2(i),A22(i-1)),B1(i)), ks_b2(i) ); 
end

% step 6-step 7
sum2=sum(B1);
A2=circshift(A22',-sum2)';

%  step 3-step 5
% A11(1)=0;
A11(1)=1;
for i=2:L
    A11(i)= bitxor( bitxor(bitxor(B1(i),A11(i-1)),A2(i)), ks_b1(i) ); 
end

%  step 1-step 2
sum1=sum(A2);
%  step 2. get A11 from A1 using cycle right shift by sum1 bits
A1=circshift(A11',-sum1)';

%% BPC
% A=Func_BitPlane_Decomposition(P); A1=A(1,:); A2=A(2,:);
rec_P=Func_BitPlane_Composition(A1,A2,height,width);

%% Stage 1. diffusion: get B1,B2 from A1,A2 by using b1,b2

% %  step 1. sum of A2
% sum1=sum(A2);
% %  step 2. get A11 from A1 using cycle right shift by sum1 bits
% A11=circshift(A1',sum1)';
% 
% %  step 3. diffusion of 1st element of A11
% B1(1)= bitxor( bitxor(bitxor(A11(1),A11(L)),A2(1)), ks_b1(1) ); 
% % step 4-step 5
% for i=2:L
%     B1(i)= bitxor( bitxor(bitxor(A11(i),A11(i-1)),A2(i)), ks_b1(i) ); 
% end
% 

toc

%% output 


% figure(1);
% subplot(3,2,1);imshow(uint8(P));title('plain image I');
% subplot(3,2,2);imhist(uint8(P));
% subplot(3,2,3);imshow(uint8(C));title('cipher image C');
% subplot(3,2,4);imhist(uint8(C));
% C
% C1
% C2
A22
% A22 =     0     1     1     0     1     0     0     1     1     1     0     1     1     0     0     0
A2
A11
A1
rec_P
