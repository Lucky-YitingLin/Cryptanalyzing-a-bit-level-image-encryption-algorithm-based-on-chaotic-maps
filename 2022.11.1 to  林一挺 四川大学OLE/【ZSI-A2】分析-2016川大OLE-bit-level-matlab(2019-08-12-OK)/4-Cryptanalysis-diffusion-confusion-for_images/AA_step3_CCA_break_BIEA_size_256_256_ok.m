%**********************************************************************************************%
% 分析2016-OLE-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% 描述：在b1,b2求得的前提下，算法为permutation-only
% by whp 2019.8.12 18:09-ok
%**********************************************************************************************%

clear;clc;close all;
tic
%% task: recover P1 from c_P1 
C=imread('./images/Lena_c.bmp');
[height,width] = size(C); L1=height*width; L=4*height*width;
tmp_C=Func_BitPlane_Decomposition(C); 
C1=tmp_C(1,:); C2=tmp_C(2,:);
sum3=sum(C1)+sum(C2)

%% step 1a. get index_Z
CP1=imread('./images/CP1a.png'); CP2=imread('./images/CP2a.png'); CP3=imread('./images/CP3a.png'); 
CP4=imread('./images/CP4a.png'); CP5=imread('./images/CP5a.png'); CP6=imread('./images/CP6a.png'); 
CP7=imread('./images/CP7a.png'); CP8=imread('./images/CP8a.png'); CP9=imread('./images/CP9a.png'); 
CP10=imread('./images/CP10a.png'); CP11=imread('./images/CP11a.png'); CP12=imread('./images/CP12a.png'); 
CP13=imread('./images/CP13a.png'); CP14=imread('./images/CP14a.png'); CP15=imread('./images/CP15a.png'); 
CP16=imread('./images/CP16a.png'); CP17=imread('./images/CP17a.png'); CP18=imread('./images/CP18a.png'); 

% diffusion: get  B1,B2  from A1,A2 by using ks_b1,ks_b2
load ks_b1.mat ks_b1;
load ks_b2.mat ks_b2;
CD1=Func_do_diffusion_by_b1b2(CP1,ks_b1,ks_b2); CD2=Func_do_diffusion_by_b1b2(CP2,ks_b1,ks_b2);
CD3=Func_do_diffusion_by_b1b2(CP3,ks_b1,ks_b2); CD4=Func_do_diffusion_by_b1b2(CP4,ks_b1,ks_b2);
CD5=Func_do_diffusion_by_b1b2(CP5,ks_b1,ks_b2); CD6=Func_do_diffusion_by_b1b2(CP6,ks_b1,ks_b2);
CD7=Func_do_diffusion_by_b1b2(CP7,ks_b1,ks_b2); CD8=Func_do_diffusion_by_b1b2(CP8,ks_b1,ks_b2);
CD9=Func_do_diffusion_by_b1b2(CP9,ks_b1,ks_b2); CD10=Func_do_diffusion_by_b1b2(CP10,ks_b1,ks_b2);
CD11=Func_do_diffusion_by_b1b2(CP11,ks_b1,ks_b2); CD12=Func_do_diffusion_by_b1b2(CP12,ks_b1,ks_b2);
CD13=Func_do_diffusion_by_b1b2(CP13,ks_b1,ks_b2); CD14=Func_do_diffusion_by_b1b2(CP14,ks_b1,ks_b2);
CD15=Func_do_diffusion_by_b1b2(CP15,ks_b1,ks_b2); CD16=Func_do_diffusion_by_b1b2(CP16,ks_b1,ks_b2);
CD17=Func_do_diffusion_by_b1b2(CP17,ks_b1,ks_b2); CD18=Func_do_diffusion_by_b1b2(CP18,ks_b1,ks_b2);

for i=1:L
    index_Z(i)=CD1(2,i)+2*CD2(2,i)+2^2*CD3(2,i)+2^3*CD4(2,i)+2^4*CD5(2,i)+2^5*CD6(2,i)+2^6*CD7(2,i)+2^7*CD8(2,i)+2^8*CD9(2,i) +...
    +2^9*CD10(2,i)+2^10*CD11(2,i)+2^11*CD12(2,i)+2^12*CD13(2,i)+2^13*CD14(2,i)+2^14*CD15(2,i)+2^15*CD16(2,i)+2^16*CD17(2,i)+2^17*CD18(2,i)+1;
end

%% step 1b. get index_Y
CP1=imread('./images/CP1b.png'); CP2=imread('./images/CP2b.png'); CP3=imread('./images/CP3b.png'); 
CP4=imread('./images/CP4b.png'); CP5=imread('./images/CP5b.png'); CP6=imread('./images/CP6b.png'); 
CP7=imread('./images/CP7b.png'); CP8=imread('./images/CP8b.png'); CP9=imread('./images/CP9b.png'); 
CP10=imread('./images/CP10b.png'); CP11=imread('./images/CP11b.png'); CP12=imread('./images/CP12b.png'); 
CP13=imread('./images/CP13b.png'); CP14=imread('./images/CP14b.png'); CP15=imread('./images/CP15b.png'); 
CP16=imread('./images/CP16b.png'); CP17=imread('./images/CP17b.png'); CP18=imread('./images/CP18b.png'); 

% diffusion: get  B1,B2  from A1,A2 by using ks_b1,ks_b2
% load ks_b1.mat ks_b1;
% load ks_b2.mat ks_b2;
CD1=Func_do_diffusion_by_b1b2(CP1,ks_b1,ks_b2); CD2=Func_do_diffusion_by_b1b2(CP2,ks_b1,ks_b2);
CD3=Func_do_diffusion_by_b1b2(CP3,ks_b1,ks_b2); CD4=Func_do_diffusion_by_b1b2(CP4,ks_b1,ks_b2);
CD5=Func_do_diffusion_by_b1b2(CP5,ks_b1,ks_b2); CD6=Func_do_diffusion_by_b1b2(CP6,ks_b1,ks_b2);
CD7=Func_do_diffusion_by_b1b2(CP7,ks_b1,ks_b2); CD8=Func_do_diffusion_by_b1b2(CP8,ks_b1,ks_b2);
CD9=Func_do_diffusion_by_b1b2(CP9,ks_b1,ks_b2); CD10=Func_do_diffusion_by_b1b2(CP10,ks_b1,ks_b2);
CD11=Func_do_diffusion_by_b1b2(CP11,ks_b1,ks_b2); CD12=Func_do_diffusion_by_b1b2(CP12,ks_b1,ks_b2);
CD13=Func_do_diffusion_by_b1b2(CP13,ks_b1,ks_b2); CD14=Func_do_diffusion_by_b1b2(CP14,ks_b1,ks_b2);
CD15=Func_do_diffusion_by_b1b2(CP15,ks_b1,ks_b2); CD16=Func_do_diffusion_by_b1b2(CP16,ks_b1,ks_b2);
CD17=Func_do_diffusion_by_b1b2(CP17,ks_b1,ks_b2); CD18=Func_do_diffusion_by_b1b2(CP18,ks_b1,ks_b2);

for i=1:L
    index_Y(i)=CD1(1,i)+2*CD2(1,i)+2^2*CD3(1,i)+2^3*CD4(1,i)+2^4*CD5(1,i)+2^5*CD6(1,i)+2^6*CD7(1,i)+2^7*CD8(1,i)+2^8*CD9(1,i) +...
    +2^9*CD10(1,i)+2^10*CD11(1,i)+2^11*CD12(1,i)+2^12*CD13(1,i)+2^13*CD14(1,i)+2^14*CD15(1,i)+2^15*CD16(1,i)+2^16*CD17(1,i)+2^17*CD18(1,i)+1;
end

%% step 2. recover P1 using index_Y and index_Z
for i=1:L
    B1(i)=C2(index_Y(i));
    B2(i)=C1(index_Z(i));    
end

%% anti-diffusion: get  A1,A2  from B1,B2 by using b1,b2
% load ks_b1.mat ks_b1;
% load ks_b2.mat ks_b2;
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
rec_P=Func_BitPlane_Composition(A1,A2,height,width);
% rec_P1
toc
% 
%% output
figure(1);
subplot(2,2,1);imshow(uint8(C));title('cipher image C');
subplot(2,2,2);imhist(uint8(C));
subplot(2,2,3);imshow(uint8(rec_P));title('recovered image C');
subplot(2,2,4);imhist(uint8(rec_P));
