%**********************************************************************************************%
% 分析2016-OLE-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% 描述：在不考虑confusion的前提下，利用b2,b1作为diffusion的等效密钥对其破解
% by whp 2019.8.11
%**********************************************************************************************%

clear;clc;close all;
tic
%% task: recover P1 from diffu_P1 
P1=[44,88;111,222];
[height,width] = size(P1); L1=height*width; L=4*height*width;

% generate the diffused version of P1
diffu_P1=FUNC_corrBIEA_diffu_En(P1);
tmp_P1=Func_BitPlane_Decomposition(diffu_P1); 
B1=tmp_P1(1,:); B2=tmp_P1(2,:);

%% anti-diffusion: get  A1,A2  from B1,B2by using b1,b2
load ks_b1.mat ks_b1;
load ks_b2.mat ks_b2;
% step 8-step 10

A22(1)=bitxor( bitxor(B2(1),B1(1)), ks_b2(1) ); 
for i=2:L
    A22(i)= bitxor( bitxor(bitxor(B2(i),A22(i-1)),B1(i)), ks_b2(i) ); 
end

% step 6-step 7
sum2=sum(B1);
A2=circshift(A22',-sum2)';

%  step 3-step 5
A11(1)= bitxor( bitxor(B1(1),A2(1)), ks_b1(1) ); 
for i=2:L
    A11(i)= bitxor( bitxor(bitxor(B1(i),A11(i-1)),A2(i)), ks_b1(i) ); 
end

%  step 1-step 2
sum1=sum(A2);
%  step 2. get A11 from A1 using cycle right shift by sum1 bits
A1=circshift(A11',-sum1)';

%% BPC
rec_P1=Func_BitPlane_Composition(A1,A2,height,width);
toc

%% output
P1
diffu_P1
rec_P1

