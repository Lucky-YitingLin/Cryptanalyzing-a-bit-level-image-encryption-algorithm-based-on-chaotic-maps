% 程序描述：2018-Optics&Lasers in Engineering-BPIEA-diffusion+confusion-OK
% 2016-Optics and Lasers in Engineering-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% by whp 2018.6.18
% 程序描述： 明文图像A -> 两个位平面A1和A2 -> ... C1和C2 -> 密文图像C

%% ****************图像位平面分解**************************
clear;clc;close all;
%读入256*256图像
P=imread('../images/Lena.bmp');        
% P=imread('../images/allWhite.bmp');     
% P=imread('../images/allBlack.bmp');  
[H,W] = size(P);
img=uint8(P);
bitPI = zeros(H,W, 8);  
for i = 1:8
    bitPI(:,:,i) = bitget(img, i); 
end
I1=bitPI(:,:,1);I2=bitPI(:,:,2);I3=bitPI(:,:,3);I4=bitPI(:,:,4);
I5=bitPI(:,:,5);I6=bitPI(:,:,6);I7=bitPI(:,:,7);I8=bitPI(:,:,8);

%% STEP1:明文图像P -> A1和A2
% P -> 采用BBD二进制位平面分解 A1和A2 ，顺序为由上到下，由左到右，由高位平面到低位平面
L=4*H*W;
L1=H*W;
A1=zeros(1,L);   %预分配内存
A2=zeros(1,L);   %预分配内存
% A1由高四位的比特组成
rowI8=reshape(I8,1,L1);rowI7=reshape(I7,1,L1);
rowI6=reshape(I6,1,L1);rowI5=reshape(I5,1,L1);
A1(1,1:L1)=rowI8;A1(1,L1+1:2*L1)=rowI7;A1(1,2*L1+1:3*L1)=rowI6;A1(1,3*L1+1:4*L1)=rowI5;
% A2由低四位的比特组成
rowI4=reshape(I4,1,L1);rowI3=reshape(I3,1,L1);
rowI2=reshape(I2,1,L1);rowI1=reshape(I1,1,L1);
A2(1,1:L1)=rowI4;A2(1,L1+1:2*L1)=rowI3;A2(1,2*L1+1:3*L1)=rowI2;A2(1,3*L1+1:4*L1)=rowI1;

%% STEP2:Diffusion phase：明文图像 A1和A2 -> 扩散图像 B1和B2
% 调用PWLCM，产生长度为M*N的PRNS
x0=0.01;u1=0.1;N0=100;
XX=Func_PWLCM(x0,u1,N0,L1);X1=mod(floor(XX*10^14),256);
% 转换为位平面，生成b1,b2
for i = 1:8
    bitX1(:,i) = bitget(X1, i); 
end
X_1=bitX1(:,1);X_2=bitX1(:,2);X_3=bitX1(:,3);X_4=bitX1(:,4);
X_5=bitX1(:,5);X_6=bitX1(:,6);X_7=bitX1(:,7);X_8=bitX1(:,8);
% b1由奇数的四个位平面组成
b1(1,1:L1)=X_7;b1(1,L1+1:2*L1)=X_5;b1(1,2*L1+1:3*L1)=X_3;b1(1,3*L1+1:4*L1)=X_1;
% b2由偶数的四个位平面组成
b2(1,1:L1)=X_8;b2(1,L1+1:2*L1)=X_6;b2(1,2*L1+1:3*L1)=X_4;b2(1,3*L1+1:4*L1)=X_2;
% X2为掩模图像
X2=reshape(X1,256,256);

%% Sec3.1:diffusion phase
% step1:sum of A2
% sumA2=cumsum(A2);sum1=sumA2(length(A2)); %此处cumsum不如sum精简，但累加时更有用
sum1=sum(A2);
% step2:将A1循环右移sum1位,得到A11
A11=circshift(A1',sum1);
A11=A11';
% step3-5:将A11、A2和b1异或扩散，得到B1
B1(1)=bitxor( bitxor(bitxor(A11(1),A11(L)),A2(1)),b1(1));
for i=2:L
    B1(i)=bitxor( bitxor(bitxor(A11(i),A11(i-1)),A2(i)),b1(i));
end

% step6:sum of B1
sum2=sum(B1);
% step7:将A2循环右移sum2位,得到A22
A22=circshift(A2',sum2);
A22=A22';

% step8-10:将A22、B1和b2异或扩散，得到B2
B2(1)=bitxor( bitxor(bitxor(A22(1),A22(L)),B1(1)),b2(1));
for i=2:L
    B2(i)=bitxor( bitxor(bitxor(A22(i),A22(i-1)),B1(i)),b2(i));
end

%% STEP3:Confusion phase：扩散图像 B1和B2 -> 密文图像 C1和C2
% step1:sum of B1 and B2
sumB=sum(B1)+sum(B2);
% step2:y0,u2 of PWLCM 产生Y,Z，长度为L
y0=0.02;u2=0.2;N0=100;
s0=mod(y0+sumB/L,1);
S=Func_PWLCM(s0,u2,N0,2*L);
S1=S(1:L);S2=(L+1:2*L);
Y=mod(floor(S1*10^14),L)+1;
Z=mod(floor(S2*10^14),L)+1;
% step3-4:把B2中的L个元素根据Y打乱位置，赋值给B1
BB1=B1;BB2=B2;
for i=1:L
    temp=BB1(i);BB1(i)=BB2(Y(i));BB2(Y(i))=temp;
end
% step5-6:把B1中的L个元素根据Z打乱位置，赋值给B2
for i=1:L
    temp=BB2(i);BB2(i)=BB1(Z(i));BB1(Z(i))=temp;
end

% B1和B2合并为图像B
% B1由转换为高四位 位平面矩阵
rowB8=B1(1,1:L1);rowB7=B1(1,L1+1:2*L1);rowB6=B1(1,2*L1+1:3*L1);rowB5=B1(1,3*L1+1:4*L1);
B_8=reshape(rowB8,H,W);B_7=reshape(rowB7,H,W);
B_6=reshape(rowB6,H,W);B_5=reshape(rowB5,H,W);
% C2由转换为低四位 位平面矩阵
rowB4=B2(1,1:L1);rowB3=B2(1,L1+1:2*L1);rowB2=B2(1,2*L1+1:3*L1);rowB1=B2(1,3*L1+1:4*L1);
B_4=reshape(rowB4,H,W);B_3=reshape(rowB3,H,W);
B_2=reshape(rowB2,H,W);B_1=reshape(rowB1,H,W);
% C1和C2 合并为C
for i=1:H
    for j=1:W
        B(i,j)=B_8(i,j)*2^7+B_7(i,j)*2^6+B_6(i,j)*2^5+B_5(i,j)*2^4+B_4(i,j)*2^3+B_3(i,j)*2^2+B_2(i,j)*2^1+B_1(i,j);
    end
end

%% STEP4:C1和C2 -> 密文图像C
% P -> 采用BBD二进制位平面分解 A1和A2 ，顺序为由上到下，由左到右，由高位平面到低位平面
% C1=A1;C2=A2;
C1=BB1;C2=BB2;
% C=Func_image_combine2to1(C1,C2);
% sumC=sum(C1)+sum(C2);
% C1由转换为高四位 位平面矩阵
rowC8=C1(1,1:L1);rowC7=C1(1,L1+1:2*L1);rowC6=C1(1,2*L1+1:3*L1);rowC5=C1(1,3*L1+1:4*L1);
C_8=reshape(rowC8,H,W);C_7=reshape(rowC7,H,W);
C_6=reshape(rowC6,H,W);C_5=reshape(rowC5,H,W);
% C2由转换为低四位 位平面矩阵
rowC4=C2(1,1:L1);rowC3=C2(1,L1+1:2*L1);rowC2=C2(1,2*L1+1:3*L1);rowC1=C2(1,3*L1+1:4*L1);
C_4=reshape(rowC4,H,W);C_3=reshape(rowC3,H,W);
C_2=reshape(rowC2,H,W);C_1=reshape(rowC1,H,W);
% C1和C2 合并为C
for i=1:H
    for j=1:W
        C(i,j)=C_8(i,j)*2^7+C_7(i,j)*2^6+C_6(i,j)*2^5+C_5(i,j)*2^4+C_4(i,j)*2^3+C_3(i,j)*2^2+C_2(i,j)*2^1+C_1(i,j);
    end
end

imwrite(uint8(C),'../images/encryptLena.bmp');   
%****************绘图**************************
% part1:加密过程中各个阶段的图像
figure(1);
subplot(2,4,1);imshow(P);title('明文图像（A1和A2）');       
subplot(2,4,2);imhist(P);title('直方图');      
subplot(2,4,3);imshow( uint8(X2) );title('掩模图像');   
subplot(2,4,4);imhist( uint8(X2) );title('直方图'); 
subplot(2,4,5);imshow(uint8(B));title('扩散图像（B1和B2）');       
subplot(2,4,6);imhist(uint8(B));title('直方图'); 
subplot(2,4,7);imshow(uint8(C));title('密文图像（C1和C2）');       
subplot(2,4,8);imhist(uint8(C));title('直方图'); 
% part2:明文图像8个位平面的图像
figure(2);

subplot(2,4,8);imshow(I1);title('bitplane1');         %位平面1 
subplot(2,4,7);imshow(I2);title('bitplane2');
subplot(2,4,6);imshow(I3);title('bitplane3');
subplot(2,4,5);imshow(I4);title('bitplane4');
subplot(2,4,4);imshow(I5);title('bitplane5');
subplot(2,4,3);imshow(I6);title('bitplane6');
subplot(2,4,2);imshow(I7);title('bitplane7');
subplot(2,4,1);imshow(I8);title('bitplane8');
% part3:扩散图像8个位平面的图像
figure(3);
% set(h,'name','Haar小波变换','Numbertitle','off')
% gtext('扩散图像');
subplot(2,4,8);imshow(B_1);title('bitplane1');         %位平面1 
subplot(2,4,7);imshow(B_2);title('bitplane2');
subplot(2,4,6);imshow(B_3);title('bitplane3');
subplot(2,4,5);imshow(B_4);title('bitplane4');
subplot(2,4,4);imshow(B_5);title('bitplane5');
subplot(2,4,3);imshow(B_6);title('bitplane6');
subplot(2,4,2);imshow(B_7);title('bitplane7');
subplot(2,4,1);imshow(B_8);title('bitplane8');
figure(4);
% set(h,'name','Haar小波变换','Numbertitle','off')
% gtext('扩散图像');
subplot(2,4,8);imshow(C_1);title('bitplane1');         %位平面1 
subplot(2,4,7);imshow(C_2);title('bitplane2');
subplot(2,4,6);imshow(C_3);title('bitplane3');
subplot(2,4,5);imshow(C_4);title('bitplane4');
subplot(2,4,4);imshow(C_5);title('bitplane5');
subplot(2,4,3);imshow(C_6);title('bitplane6');
subplot(2,4,2);imshow(C_7);title('bitplane7');
subplot(2,4,1);imshow(C_8);title('bitplane8');
% suptitle('titletest');
%****************************************************