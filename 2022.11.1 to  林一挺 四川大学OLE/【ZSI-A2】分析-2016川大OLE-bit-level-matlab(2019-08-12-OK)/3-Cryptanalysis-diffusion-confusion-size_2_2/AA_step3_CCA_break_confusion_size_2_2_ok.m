%**********************************************************************************************%
% 分析2016-OLE-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% 描述：在b1,b2求得的前提下，算法为permutation-only
% by whp 2019.8.12 16:32-ok
%**********************************************************************************************%

clear;clc;close all;
tic
%% task: recover P1 from c_P1 
P1=[44,88;111,220];
[height,width] = size(P1); L1=height*width; L=4*height*width;

% generate the cipher version of P1
% c_P1=FUNC_corrBIEA_En(P1);
% tmp_P1=Func_BitPlane_Decomposition(c_P1); 
% C1=tmp_P1(1,:); C2=tmp_P1(2,:);
% 
% % calculate sum3
% sum3=sum(C1)+sum(C2)
sum3=13;

%% Part 1. construct log2(L)  chosen cipher images by the feature of C1 to solve index_Z

%% construct the chosen cipher images
CC1_2=zeros(1,L);CC2_2=zeros(1,L);CC3_2=zeros(1,L);CC4_2=zeros(1,L);

cp=zeros(1,L);
for i=1:L
    cp(i)=i-1;
end
CC1_1=bitand(cp,1);CC2_1=bitand(cp,2)/2;CC3_1=bitand(cp,2^2)/2^2;CC4_1=bitand(cp,2^3)/2^3;
l1=sum3-sum(CC1_1); l2=sum3-sum(CC2_1); l3=sum3-sum(CC3_1); l4=sum3-sum(CC4_1);
CC1_2(1:l1)=1; CC2_2(1:l2)=1; CC3_2(1:l3)=1; CC4_2(1:l4)=1; 

%% BPC to formulate the chosen cipher images:
CC1=Func_BitPlane_Composition(CC1_1,CC1_2,height,width);
CC2=Func_BitPlane_Composition(CC2_1,CC2_2,height,width);
CC3=Func_BitPlane_Composition(CC3_1,CC3_2,height,width);
CC4=Func_BitPlane_Composition(CC4_1,CC4_2,height,width);
sum3_CC1=sum(CC1_1)+sum(CC1_2); sum3_CC2=sum(CC2_1)+sum(CC2_2);
sum3_CC3=sum(CC3_1)+sum(CC3_2); sum3_CC4=sum(CC4_1)+sum(CC4_2);

%%  use the decryption machine
CP1=FUNC_corrBIEA_De(CC1); CP2=FUNC_corrBIEA_De(CC2);
CP3=FUNC_corrBIEA_De(CC3); CP4=FUNC_corrBIEA_De(CC4);

%% diffusion: get  B1,B2  from A1,A2 by using ks_b1,ks_b2
load ks_b1.mat ks_b1;
load ks_b2.mat ks_b2;
CD1=Func_do_diffusion_by_b1b2(CP1,ks_b1,ks_b2);CD2=Func_do_diffusion_by_b1b2(CP2,ks_b1,ks_b2);
CD3=Func_do_diffusion_by_b1b2(CP3,ks_b1,ks_b2);CD4=Func_do_diffusion_by_b1b2(CP4,ks_b1,ks_b2);
CD1_1=CD1(1,:); CD1_2=CD1(2,:); 
CD2_1=CD2(1,:); CD2_2=CD2(2,:); 
CD3_1=CD3(1,:); CD3_2=CD3(2,:); 
CD4_1=CD4(1,:); CD4_2=CD4(2,:); 
sum3_CD1=sum(CD1_1)+sum(CD1_2);

%%
for i=1:L
    index_Z(i)=CD1_2(i)+2*CD2_2(i)+2^2*CD3_2(i)+2^3*CD4_2(i) +1;
end
index_Z

%% Part 2. Similarly, construct log2(L)  chosen cipher images by the feature of C2 to solve index_Y

%% construct the chosen cipher images
CC1_2=zeros(1,L);CC2_2=zeros(1,L);CC3_2=zeros(1,L);CC4_2=zeros(1,L);

cp=zeros(1,L);
for i=1:L
    cp(i)=i-1;
end
CC1_1=bitand(cp,1);CC2_1=bitand(cp,2)/2;CC3_1=bitand(cp,2^2)/2^2;CC4_1=bitand(cp,2^3)/2^3;
l1=sum3-sum(CC1_1); l2=sum3-sum(CC2_1); l3=sum3-sum(CC3_1); l4=sum3-sum(CC4_1);
CC1_2(1:l1)=1; CC2_2(1:l2)=1; CC3_2(1:l3)=1; CC4_2(1:l4)=1; 

%% BPC to formulate the chosen cipher images: (just reverse CC_1 and CC_2)
CC1=Func_BitPlane_Composition(CC1_2,CC1_1,height,width);
CC2=Func_BitPlane_Composition(CC2_2,CC2_1,height,width);
CC3=Func_BitPlane_Composition(CC3_2,CC3_1,height,width);
CC4=Func_BitPlane_Composition(CC4_2,CC4_1,height,width);

%%  use the decryption machine
CP1=FUNC_corrBIEA_De(CC1); CP2=FUNC_corrBIEA_De(CC2);
CP3=FUNC_corrBIEA_De(CC3); CP4=FUNC_corrBIEA_De(CC4);

%% diffusion: get  B1,B2  from A1,A2 by using ks_b1,ks_b2
load ks_b1.mat ks_b1;
load ks_b2.mat ks_b2;
CD1=Func_do_diffusion_by_b1b2(CP1,ks_b1,ks_b2);CD2=Func_do_diffusion_by_b1b2(CP2,ks_b1,ks_b2);
CD3=Func_do_diffusion_by_b1b2(CP3,ks_b1,ks_b2);CD4=Func_do_diffusion_by_b1b2(CP4,ks_b1,ks_b2);
CD1_1=CD1(1,:); CD1_2=CD1(2,:); 
CD2_1=CD2(1,:); CD2_2=CD2(2,:); 
CD3_1=CD3(1,:); CD3_2=CD3(2,:); 
CD4_1=CD4(1,:); CD4_2=CD4(2,:); 
sum3_CD1=sum(CD1_1)+sum(CD1_2);

%%
for i=1:L
    index_Y(i)=CD1_1(i)+2*CD2_1(i)+2^2*CD3_1(i)+2^3*CD4_1(i) +1;  %CD_2->CD_1
end
index_Y

%% recover P1 form c_P1
% generate the cipher version of P1
c_P1=FUNC_corrBIEA_En(P1);
tmp_P1=Func_BitPlane_Decomposition(c_P1); 
C1=tmp_P1(1,:); C2=tmp_P1(2,:);

% calculate sum3
sum3=sum(C1)+sum(C2)
% index_Y=uint8(index_Y);index_Z=uint8(index_Z);
for i=1:L
    B1(i)=C2(index_Y(i));
    B2(i)=C1(index_Z(i));    
end

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
rec_P1
toc

%% output


