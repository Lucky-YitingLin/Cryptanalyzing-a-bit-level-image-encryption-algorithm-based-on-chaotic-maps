%**********************************************************************************************%
% 分析2016-OLE-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% 描述：根据CCA,选取全0的密文图像，获取b2,b1
% by whp 2019.8.11
%**********************************************************************************************%

clear;clc;close all;
tic
C=zeros(256,256);
[height,width] = size(C); L1=height*width; L=4*height*width;

%% use the decryption machine
rec_P=FUNC_corrBIEA_De(C);

%% BPD
CC=Func_BitPlane_Decomposition(C); 
B2=CC(1,:); B1=CC(2,:);
PP=Func_BitPlane_Decomposition(rec_P); 
A1=PP(1,:); A2=PP(2,:);

%% step 1. one gets ks_b2 by the decryption equations: B2->A22
ks_b2(1)=bitxor( A2(1), bitxor(B2(1),B1(1)) );
for i=2:L
    ks_b2(i)= bitxor( A2(i),A2(i-1) ); 
end

%% step 2. A1->A11
sum1=sum(A2);
A11=circshift(A1',sum1)';

%% step 3. one gets ks_b1 by the decryption equations: B1->A11
ks_b1(1)=bitxor( A2(1), A11(1) );
for i=2:L
    ks_b1(i)= bitxor( A2(i), bitxor( A11(i),A11(i-1) ) );
end

toc

%% output
save ks_b1.mat ks_b1;
save ks_b2.mat ks_b2;

