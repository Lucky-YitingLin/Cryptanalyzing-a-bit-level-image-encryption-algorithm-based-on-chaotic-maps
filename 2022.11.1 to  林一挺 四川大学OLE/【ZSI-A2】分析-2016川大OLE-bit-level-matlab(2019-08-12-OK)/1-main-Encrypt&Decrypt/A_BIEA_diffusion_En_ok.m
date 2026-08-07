%**********************************************************************************************%
% 名称：对一个基于混沌映射的比特平面图形加密算法的破译
% 2016-OLE-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% 描述：采用比特平面分解，先diffusion，后permutation。仅permutation的keystreams与中间密文关联。
% by whp 2019.8.10
%**********************************************************************************************%

clear;clc;close all;
tic
% P=[0,129; 128,0];
P=[101,129; 28,205];
% P=imread('./images/Lena.bmp');        %256*256黑白图像
[height,width] = size(P); L1=height*width; L=4*height*width;
% C=Func_BitPlane_Composition(A(1,:),A(2,:),height,width)

%% Initialization: generate PRNS1:b1,b2
x0=0.3;u0=1.58;N0=100;
X=Func_Cubic_Logistic(x0,u0,N0,L1);
X=mod(floor(X*10^14),256); X=reshape(X,height,width);
ks_B=Func_BitPlane_Decomposition(X);
ks_b1=ks_B(1,:); ks_b2=ks_B(2,:);

%% BPD
A=Func_BitPlane_Decomposition(P); A1=A(1,:); A2=A(2,:);
% C=Func_BitPlane_Composition(A(1,:),A(2,:),height,width);

%% Stage 1. diffusion: get B1,B2 from A1,A2 by using b1,b2

%  step 1. sum of A2
sum1=sum(A2);
%  step 2. get A11 from A1 using cycle right shift by sum1 bits
A11=circshift(A1',sum1)';

%  step 3. diffusion of 1st element of A11
B1(1)= bitxor( bitxor(bitxor(A11(1),A11(L)),A2(1)), ks_b1(1) ); 
% step 4-step 5
for i=2:L
    B1(i)= bitxor( bitxor(bitxor(A11(i),A11(i-1)),A2(i)), ks_b1(i) ); 
end

% step 6
sum2=sum(B1);
%  step 7. get A22 from A2 using cycle right shift by sum2 bits
A22=circshift(A2',sum2)';

%  step 8. diffusion of 1st element of A22
B2(1)= bitxor( bitxor(bitxor(A22(1),A22(L)),B1(1)), ks_b2(1) ); 
% step 9-step 10
for i=2:L
    B2(i)= bitxor( bitxor(bitxor(A22(i),A22(i-1)),B1(i)), ks_b2(i) ); 
end

%% Stage 2. confusion: get C1,C2 from B1,B2 by using Y,Z
% C2=bitxor(C1,R);

%% BPC
C1=B1; C2=B2;
% A=Func_BitPlane_Decomposition(P); A1=A(1,:); A2=A(2,:);
C=Func_BitPlane_Composition(B1,B2,height,width);
toc

%% output 
% A1
% A11
% B1
% A22
% B2
% P
C
C1
C2
A22
A2
A11
A1
% A1 =     0     1     0     1     1     0     0     1     1     0     0     0     0     0     1     0

% A11 =     1     0     0     0     0     0     1     0     0     1     0     1     1     0     0     1
% A2 =     0     0     1     1     1     0     1     1     0     0     0     0     1     1     0     1
% figure(1);
% subplot(3,2,1);imshow(uint8(P));title('plain image I');
% subplot(3,2,2);imhist(uint8(P));
% subplot(3,2,3);imshow(uint8(C));title('cipher image C');
% subplot(3,2,4);imhist(uint8(C));
