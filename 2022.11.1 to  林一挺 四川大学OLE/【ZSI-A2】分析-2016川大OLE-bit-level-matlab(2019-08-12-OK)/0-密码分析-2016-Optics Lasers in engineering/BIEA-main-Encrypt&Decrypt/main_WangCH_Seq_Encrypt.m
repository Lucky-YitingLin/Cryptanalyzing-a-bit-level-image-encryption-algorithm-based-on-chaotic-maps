% 程序描述：2018-IJBC-WangCH-图像加密论文实验
% 2018-International Journal of Bifurcation & Chaos-Wang CH-A New Chaotic Image Encryption Scheme Using Breadth-First Search and Dynamic Diffusion
% by whp 2018.5.28
% 加密过程： 明文图像P -> Bredth-first-search置乱图像B -> 全局置乱图像Q -> 扩散加密图像C
% 重要日志：
% 18.5.28 读入L=256*256的图像，然后转换为一个行向量，进行加密，最后的密文转换为矩阵显示
% B=reshape(B',1,L);按行读取

%% step0.1：读取明文图像P1
clear;clc;close all;
tic
P1=imread('../images/Lena.bmp');        %256*256黑白图像
% P1=imread('../images/allSamegray.bmp');
% P1=imread('../images/allBlack.bmp');
% P1=imread('../images/allWhite.bmp');

%% step0.2：预处理。B=reshape(A,m,n)为按列读取方式，而论文中一般是按照raster读取方式，即行读取，因此需要进行适当的变换。
[H,W]=size(P1);L=H*W;
P1=double(P1);
P2=P1';
P3=reshape(P2,1,L);
P=P3;

%% step1：FUNC1_WangCH_4D_hyperchaos产生L/16的两个混沌序列k1,k2
N0=100;XX0(1)=1;XX0(2)=0.949;XX0(3)=1;XX0(4)=1;
Out=Func_Rugge_Kutta_WangCH_Chaos(XX0,N0,L/16);
x=Out(1,:);y=Out(2,:);z=Out(3,:);w=Out(4,:);
k1=mod(floor(((x+y)-fix(x+y))*10^16),4);
k2=mod(floor(((z+w)-fix(z+w))*10^16),4);

%% step2-5：分合图像并调用Func_Bredth_first_search，使得P->S->B
S=P;
for i=1:L/16
    A(i,:)=S(16*(i-1)+1:16*i);
    B(i,:)=Func_Bredth_first_search(A(i,:),k1(i));
end
B=reshape(B',1,L);

%% step6-8：FUNC2_WangCH_4D_hyperchaos产生L的两个混沌序列k3,k4
N0=100;XX0(1)=1.01;XX0(2)=0.95;XX0(3)=1.01;XX0(4)=1.01;
Out=Func_Rugge_Kutta_WangCH_Chaos(XX0,N0,L);
xx=Out(1,:);yy=Out(2,:);zz=Out(3,:);ww=Out(4,:);
k3=xx+zz;
% k4=mod(floor((yy+ww)*10^15),256); %直方图不均匀
k4=mod(floor((yy+ww)*10^5),256);
[valuek3,T] = sort(k3);
Q=B;
for i=1:L
    t=Q(i);Q(i)=Q(T(i));Q(T(i))=t;
end

%% step9：混沌序列k4在Breadth-first-search控制序列k2作用下，生成新的密钥序列k
for i=1:L/16
    AA(i,:)=k4(16*(i-1)+1:16*i);
    k(i,:)=Func_Bredth_first_search(AA(i,:),k2(i));
end
k=reshape(k,1,L);

%% step10：i=1时，扩散加密过程
% sum1=sum((sum(Q))');      %矩阵所有元素累加的和
q=double(Q);
sum1(1)=sum(q)-q(1);
sum2(1)=0;
% q=reshape(Q,1,M*N);
C(1)=bitxor( bitxor(q(1),k(1)), mod(sum1(1)+k(1),256));

%% step11-13：i=2-L时，扩散加密过程
for i=2:L
    sum1(i)=sum1(i-1)-q(i);
    sum2(i)=sum2(i-1)+double(C(i-1));       %此处对上一密文像素值作数据类型变换。否则会导致sum2为整型，后面计算出错。
    j(i)=mod(sum2(i)*10^10,L)+1;
    C(i)=bitxor( bitxor(q(i),mod(C(i-1)+k(j(i)),256)), mod(sum1(i)+k(i),256));
end

%% step0：绘制图像
N=sqrt(L);
img_P=reshape(P1,N,N);img_B=reshape(B,N,N);
img_Q=reshape(Q,N,N);img_k4=reshape(k4,N,N);
img_k=reshape(k,N,N);
C1=reshape(C,N,N);
C2=C1';
img_C=reshape(C2,N,N);
imwrite(uint8(img_C),'../images/EncryptImg.bmp');
% 一维序列转换为二维图像矩阵应当进行转置处理。
figure(1);
subplot(3,4,1);imshow( uint8(img_P) );title('明文图像P');   
subplot(3,4,2);imhist( uint8(img_P) );title('P直方图');    
subplot(3,4,3);imshow( uint8(img_B') );title('Bredth-first search置乱图像B');  
subplot(3,4,4);imhist( uint8(img_B') );title('B直方图'); 
subplot(3,4,5);imshow( uint8(img_Q) );title('全局置乱图像Q');  
subplot(3,4,6);imhist( uint8(img_Q) );title('Q直方图'); 
subplot(3,4,7);imshow(uint8(img_k4));title('密钥图像K4');  
subplot(3,4,8);imhist(uint8(img_k4));title('K4直方图'); 
subplot(3,4,9);imshow( uint8(img_k) );title('密钥图像K');  
subplot(3,4,10);imhist( uint8(img_k) );title('K直方图');
subplot(3,4,11);imshow( uint8(img_C) );title('密文图像C');  
subplot(3,4,12);imhist( uint8(img_C) );title('C直方图');