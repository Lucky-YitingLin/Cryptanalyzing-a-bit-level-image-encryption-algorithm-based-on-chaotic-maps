% 程序名称：Func_PWLCM(x0,u0,N0,len)
% 2018.6.17 by whp 

clc;clear;close all;
%% 调用PWLCM，产生长度为M*N的PRNS
x0=0.3;u0=0.2;N0=100;len=256*256;
XX=Func_PWLCM(x0,u0,N0,len);
X1=mod(floor(XX*10^14),256);

%% 转换为位平面，生成b1,b2
for i = 1:8
    bitX1(:,i) = bitget(X1, i); 
end
X_1=bitX1(:,1);X_2=bitX1(:,2);X_3=bitX1(:,3);X_4=bitX1(:,4);
X_5=bitX1(:,5);X_6=bitX1(:,6);X_7=bitX1(:,7);X_8=bitX1(:,8);
L1=256*256;
% b1由奇数的四个位平面组成
b1(1,1:L1)=X_7;b1(1,L1+1:2*L1)=X_5;b1(1,2*L1+1:3*L1)=X_3;b1(1,3*L1+1:4*L1)=X_1;
% b2由偶数的四个位平面组成
b2(1,1:L1)=X_8;b2(1,L1+1:2*L1)=X_6;b2(1,2*L1+1:3*L1)=X_4;b2(1,3*L1+1:4*L1)=X_2;

sum=cumsum(b1);
% sum1=sum(262144);
sum1=sum(length(b1));
% sum1=sum(size(b1));

X2=reshape(X1,256,256);

figure(1)
subplot(2,2,1);hist(XX,0:0.0001:1);
subplot(2,2,2);hist(X1,0:255);

subplot(2,2,3);imshow( uint8(X2) );title('掩模图像');   
subplot(2,2,4);imhist( uint8(X2) );title('直方图');  