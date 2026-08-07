%**********************************************************************************************%
% 2016-OLE-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% 描述：加密算法不是满射，异或解密时存在二值解。为正确解密，令A11_0=1替代A11(L)，A22_0=0替代A22(L);
% by whp 2019.8.11
%**********************************************************************************************%

clear;clc;close all;
tic
% C =[  52     5;   184   106];
% C=imread('./images/C_corrBIEA.bmp');
% P=[101,129; 28,205];
C=zeros(2,2);

% P=imread('./images/Lena.bmp');
[height,width] = size(C); L1=height*width; L=4*height*width;

%% Initialization: generate PRNS1:b1,b2
x0=0.3;u0=1.58;N0=100;
X=Func_Cubic_Logistic(x0,u0,N0,L1);
X=mod(floor(X*10^14),256); X=reshape(X,height,width);
ks_B=Func_BitPlane_Decomposition(X);
ks_b1=ks_B(1,:); ks_b2=ks_B(2,:);

%% BPD
CC=Func_BitPlane_Decomposition(C); C1=CC(1,:); C2=CC(2,:);

%% Stage 1. anti-confusion: get  B1,B2  from C2,C1 by using Z,Y
% step 1. generate PRNS2:Y,Z
y0=0.2;u2=1.58;N0=100;
sumB=sum(C1)+sum(C2);
s0=mod(y0+sumB/L,1);
S=Func_Cubic_Logistic(s0,u2,N0,2*L);
S=mod(floor(S*10^14),L); 
Y=S(1:L); Z=S(L+1:2*L); 
[vY,Y]=sort(Y); [vZ,Z]=sort(Z);

for i=1:L
    B1(i)=C2(Y(i));
    B2(i)=C1(Z(i));
end

%% Stage 2. anti-diffusion: get  A1,A2  from B1,B2by using b1,b2

% step 8-step 10
A22_0=0;
A22(1)=bitxor( bitxor(bitxor(B2(1),A22_0),B1(1)), ks_b2(1) ); 
for i=2:L
    A22(i)= bitxor( bitxor(bitxor(B2(i),A22(i-1)),B1(i)), ks_b2(i) ); 
end

% step 6-step 7
sum2=sum(B1);
A2=circshift(A22',-sum2)';

%  step 3-step 5
A11_0=1;
A11(1)= bitxor( bitxor(bitxor(B1(1),A11_0),A2(1)), ks_b1(1) ); 
for i=2:L
    A11(i)= bitxor( bitxor(bitxor(B1(i),A11(i-1)),A2(i)), ks_b1(i) ); 
end

%  step 1-step 2
sum1=sum(A2);
%  step 2. get A11 from A1 using cycle right shift by sum1 bits
A1=circshift(A11',-sum1)';

%% BPC
rec_P=Func_BitPlane_Composition(A1,A2,height,width);

%% output 
ks_b2
rec_P


% figure(1);
% subplot(3,2,1);imshow(uint8(P));title('plain image I');
% subplot(3,2,2);imhist(uint8(P));
% subplot(3,2,3);imshow(uint8(C));title('cipher image C');
% subplot(3,2,4);imhist(uint8(C));
