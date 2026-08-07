%**********************************************************************************************%
% 名称：对一个基于混沌映射的比特平面图形加密算法的破译
% 2016-OLE-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% 描述：采用比特平面分解，先diffusion，后permutation。仅permutation的keystreams与中间密文关联。
% by whp 2019.8.10
%**********************************************************************************************%

clear;clc;close all;
tic
C=[96   142;    16   204];
[height,width] = size(C); L1=height*width; L=4*height*width;

%% Initialization: generate PRNS1:b1,b2
x0=0.3;u0=1.58;N0=100;
X=Func_Cubic_Logistic(x0,u0,N0,L1);
X=mod(floor(X*10^14),256); X=reshape(X,height,width);
ks_B=Func_BitPlane_Decomposition(X);
ks_b1=ks_B(1,:); ks_b2=ks_B(2,:);

%% BPD
% A=Func_BitPlane_Decomposition(P); A1=A(1,:); A2=A(2,:);
CC=Func_BitPlane_Decomposition(C); B1=CC(1,:); B2=CC(2,:);

%% Stage 1. anti-diffusion
% B1=A1; A22=A2;
%  step 8. diffusion of 1st element of A22
% B2(1)= bitxor( bitxor(bitxor(A22(1),A22(L)),B1(1)), ks_b2(1) ); 
% step 9-step 10
% for i=2:L
%     B2(i)= bitxor( bitxor(bitxor(A22(i),A22(i-1)),B1(i)), ks_b2(i) ); 
% end

% A22(1)=0;
A22(1)=1;
for i=2:L
    A22(i)= bitxor( bitxor(bitxor(B2(i),A22(i-1)),B1(i)), ks_b2(i) ); 
end

%% BPC
% C=Func_BitPlane_Composition(B1,B2,height,width);
toc

%% output 
% P
% C
% encryption
% A22 =     0     0     1     1     1     0     1     1     0     0     0     0     1     1     0     1
% B2 =     0     1     0     1     0     1     0     1     0     1     0     0     0     0     0     0

B2
A22


