% 程序描述：2018-Optics&Lasers in Engineering-BPIEA-diffusion+confusion-OK
% 2016-Optics and Lasers in Engineering-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% by whp 2018.6.18
% 程序描述： 2018.6.18下午 解密confusion出来的B直方图不对，待处理

%% ****************图像位平面分解**************************
clear;clc;
% close all;
%读入256*256图像
C=imread('../images/encryptLena.bmp'); 
% C=imread('../images/EncryptImg.bmp'); 
C=uint8(C);
% imwrite(C,'../images/encryptLena.bmp');   
[H,W] = size(C);L1=H*W;L=4*L1;
bitPI = zeros(H,W,8);  
for i = 1:8
    bitPI(:,:,i) = bitget(uint8(C), i); 
end
C_1=bitPI(:,:,1);C_2=bitPI(:,:,2);C_3=bitPI(:,:,3);C_4=bitPI(:,:,4);
C_5=bitPI(:,:,5);C_6=bitPI(:,:,6);C_7=bitPI(:,:,7);C_8=bitPI(:,:,8);

%% STEP1:密文图像C -> C1和C2
C1=zeros(1,L);C2=zeros(1,L);   %预分配内存
% C1由高四位的比特组成
rowC8=reshape(C_8,1,L1);rowC7=reshape(C_7,1,L1);
rowC6=reshape(C_6,1,L1);rowC5=reshape(C_5,1,L1);
C1(1,1:L1)=rowC8;C1(1,L1+1:2*L1)=rowC7;C1(1,2*L1+1:3*L1)=rowC6;C1(1,3*L1+1:4*L1)=rowC5;
% C2由低四位的比特组成
rowC4=reshape(C_4,1,L1);rowC3=reshape(C_3,1,L1);
rowC2=reshape(C_2,1,L1);rowC1=reshape(C_1,1,L1);
C2(1,1:L1)=rowC4;C2(1,L1+1:2*L1)=rowC3;C2(1,2*L1+1:3*L1)=rowC2;C2(1,3*L1+1:4*L1)=rowC1;
 
%% STEP2:Confusion decryption phase：密文图像 C1和C2 -> 扩散图像 B1和B2
% step1:sum of C1 and CB2
sumB=sum(C1)+sum(C2);
% step2:y0,u2 of PWLCM 产生Y,Z，长度为L
y0=0.02;u2=0.2;N0=100;
s0=mod(y0+sumB/L,1);
S=Func_PWLCM(s0,u2,N0,2*L);
S1=S(1:L);S2=(L+1:2*L);
Y=mod(floor(S1*10^14),L)+1;
Z=mod(floor(S2*10^14),L)+1;
% 对应解密 -> step5-6:把B1中的L个元素根据Z打乱位置，赋值给B2
CC1=C1;CC2=C2;
for i=1:L
    temp=CC2(i);CC2(i)=CC1(Z(i));CC1(Z(i))=temp;
end
% 对应解密 -> step3-4:把B2中的L个元素根据Y打乱位置，赋值给B1
for i=1:L
    temp=CC1(i);CC1(i)=CC2(Y(i));CC2(Y(i))=temp;
end
B1=CC1;B2=CC2;

% B1和B2合并为图像B
% B1由转换为高四位 位平面矩阵
rowB8=B1(1,1:L1);rowB7=B1(1,L1+1:2*L1);rowB6=B1(1,2*L1+1:3*L1);rowB5=B1(1,3*L1+1:4*L1);
B_8=reshape(rowB8,H,W);B_7=reshape(rowB7,H,W);
B_6=reshape(rowB6,H,W);B_5=reshape(rowB5,H,W);
% C2由转换为低四位 位平面矩阵
rowB4=B2(1,1:L1);rowB3=B2(1,L1+1:2*L1);rowB2=B2(1,2*L1+1:3*L1);rowB1=B2(1,3*L1+1:4*L1);
B_4=reshape(rowB4,H,W);B_3=reshape(rowB3,H,W);
B_2=reshape(rowB2,H,W);B_1=reshape(rowB1,H,W);
% B1和B2 合并为B
for i=1:H
    for j=1:W
        B(i,j)=B_8(i,j)*2^7+B_7(i,j)*2^6+B_6(i,j)*2^5+B_5(i,j)*2^4+B_4(i,j)*2^3+B_3(i,j)*2^2+B_2(i,j)*2^1+B_1(i,j);
    end
end

%****************绘图**************************
% part1:加密过程中各个阶段的图像
figure(11);
% subplot(2,4,1);imshow(P);title('明文图像（A1和A2）');       
% subplot(2,4,2);imhist(P);title('直方图');      
% subplot(2,4,3);imshow( uint8(X2) );title('掩模图像');   
% subplot(2,4,4);imhist( uint8(X2) );title('直方图'); 
subplot(2,4,5);imshow(uint8(B));title('扩散图像（B1和B2）');       
subplot(2,4,6);imhist(uint8(B));title('直方图'); 
subplot(2,4,1);imshow(uint8(C));title('密文图像（C1和C2）');       
subplot(2,4,2);imhist(uint8(C));title('直方图'); 
% part2:明文图像8个位平面的图像
% figure(12);
% 
% subplot(2,4,8);imshow(I1);title('bitplane1');         %位平面1 
% subplot(2,4,7);imshow(I2);title('bitplane2');
% subplot(2,4,6);imshow(I3);title('bitplane3');
% subplot(2,4,5);imshow(I4);title('bitplane4');
% subplot(2,4,4);imshow(I5);title('bitplane5');
% subplot(2,4,3);imshow(I6);title('bitplane6');
% subplot(2,4,2);imshow(I7);title('bitplane7');
% subplot(2,4,1);imshow(I8);title('bitplane8');
% % part3:扩散图像8个位平面的图像
figure(13);
subplot(2,4,8);imshow(B_1);title('bitplane1');         %位平面1 
subplot(2,4,7);imshow(B_2);title('bitplane2');
subplot(2,4,6);imshow(B_3);title('bitplane3');
subplot(2,4,5);imshow(B_4);title('bitplane4');
subplot(2,4,4);imshow(B_5);title('bitplane5');
subplot(2,4,3);imshow(B_6);title('bitplane6');
subplot(2,4,2);imshow(B_7);title('bitplane7');
subplot(2,4,1);imshow(B_8);title('bitplane8');
figure(14);
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