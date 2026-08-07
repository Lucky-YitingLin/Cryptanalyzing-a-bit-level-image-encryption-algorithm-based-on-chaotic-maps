%**********************************************************************************************%
% 分析2016-OLE-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% 描述：在b1,b2求得的前提下，算法为permutation-only
% by whp 2019.8.11
%**********************************************************************************************%

clear;clc;close all;
tic
%% task: recover P1 from c_P1 
P1=[44,88;111,222];
[height,width] = size(P1); L1=height*width; L=4*height*width;

% generate the cipher version of P1
c_P1=FUNC_corrBIEA_En(P1);
tmp_P1=Func_BitPlane_Decomposition(c_P1); 
C1=tmp_P1(1,:); C2=tmp_P1(2,:);

% calculate sum3
sum3=sum(C1)+sum(C2)

%% construct the chosen cipher images
CC1_C1=zeros(1,L); CC1_C2=zeros(1,L);
% CC1_C1(:)=1; CC1_C1(1)=0;
% CC1_C2(1:sum3+1-L)=1; 

CC1_C1(:)=1; CC1_C1(1)=0;
CC1_C2(1:sum3-L)=1; 
CC1_C2(sum3+2-L)=1;

% CC1_C1(:)=1; CC1_C1(1:2)=0;
% CC1_C2(1:sum3+2-L)=1; 


CC1=Func_BitPlane_Composition(CC1_C1,CC1_C2,height,width);
sum3_CC1=sum(CC1_C1)+sum(CC1_C2)
CC1_C1
CC1_C2
% CC1

%%  use the decryption machine
CP1=FUNC_corrBIEA_De(CC1);

%% diffusion: get  B1,B2  from A1,A2 by using ks_b1,ks_b2
load ks_b1.mat ks_b1;
load ks_b2.mat ks_b2;
BB=Func_do_diffusion_by_b1b2(CP1,ks_b1,ks_b2);
CC1_B1=BB(1,:); CC1_B2=BB(2,:); 
CC1_B1
CC1_B2
sum3_CB1=sum(CC1_B1)+sum(CC1_B2)
% % step 8-step 10
% 
% A22(1)=bitxor( bitxor(B2(1),B1(1)), ks_b2(1) ); 
% for i=2:L
%     A22(i)= bitxor( bitxor(bitxor(B2(i),A22(i-1)),B1(i)), ks_b2(i) ); 
% end
% 
% % step 6-step 7
% sum2=sum(B1);
% A2=circshift(A22',-sum2)';
% 
% %  step 3-step 5
% A11(1)= bitxor( bitxor(B1(1),A2(1)), ks_b1(1) ); 
% for i=2:L
%     A11(i)= bitxor( bitxor(bitxor(B1(i),A11(i-1)),A2(i)), ks_b1(i) ); 
% end
% 
% %  step 1-step 2
% sum1=sum(A2);
% %  step 2. get A11 from A1 using cycle right shift by sum1 bits
% A1=circshift(A11',-sum1)';
% 
% %% BPC
% rec_P1=Func_BitPlane_Composition(A1,A2,height,width);
toc

%% output


