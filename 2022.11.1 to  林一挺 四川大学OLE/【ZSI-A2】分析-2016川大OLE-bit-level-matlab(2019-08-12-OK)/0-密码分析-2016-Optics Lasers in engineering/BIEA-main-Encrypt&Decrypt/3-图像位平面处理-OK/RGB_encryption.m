% 程序名称：RGB_encryption_hyperchaos_4d_lorenz.m
% 张勇-混沌数字图像加密，P19
% 程序描述：连续混沌系统离散化，使用四阶龙格-库塔（Rugge-Kutta）方法 
% author by whp 2018.1.26
clc;clear;
h=0.002;     % 离散化控制参数 h=0.002; 
% h=0.02;
% n=256*256;
n=512*512;
t=800;
a=10;b=8/3;c=28;r=-1;
x0=1.1;y0=2.2;z0=3.3;w0=4.4;
xn=zeros(1,n);yn=zeros(1,n);zn=zeros(1,n);wn=zeros(1,n);

for i=1:n+t
    K11 = a*(y0-x0) +w0;                K12 = a*(y0-(x0 +K11*h/2)) +w0;     
    K13 = a*(y0-(x0 +K12*h/2)) +w0;     K14 = a*(y0-(x0 +K13*h/2)) +w0;   
    x1 = x0 +(K11 +2*K12 +2*K13 +K14)*h/6;
    
    K21 = c*x1-y0-x1*z0;                K22 = c*x1 -(y0 +K21*h/2)-x1*z0;                
    K23 = c*x1 -(y0 +K22*h/2)-x1*z0;    K24 = c*x1 -(y0 +K23*h/2)-x1*z0;
    y1 = y0 +(K21 +2*K22 +2*K23 +K24)*h/6;
    
    K31 = x1*y1-b*z0;                   K32 = x1*y1 -b*(z0 +K31*h/2);                
    K33 = x1*y1 -b*(z0 +K32*h/2);       K34 = x1*y1 -b*(z0 +K33*h/2);
    z1 = z0 +(K31 +2*K32 +2*K33 +K34)*h/6;
    
    K41 = -y1*z1 +r*w0;                 K42 = -y1*z1 +r*(w0 +K41*h/2);
    K43 = -y1*z1 +r*(w0 +K42*h/2);      K44 = -y1*z1 +r*(w0 +K43*h/2);
    w1 = w0 +(K41 +2*K42 +2*K43 +K44)*h/6;
    
    x0=x1;y0=y1;z0=z1;w0=w1;
    if i>t
        xn(i-t) = x1;yn(i-t) = y1;zn(i-t) = z1;wn(i-t) = w1;
    end
end

figure(1);  %******x-z*******
plot(xn,zn,'r.','linewidth',1,'markersize',1);
set(gca,'fontsize',16,'fontname','times new roman');
xlabel('x','fontsiZe',18,'fontname','times new roman','FontAngle','italic'); 
ylabel('z','fontsiZe',18,'fontname','times new roman','FontAngle','italic');


figure(2);
subplot(2,2,1); x=-30:30; hist(xn,x);
subplot(2,2,2); x=-30:30; hist(yn,x);
subplot(2,2,3); x=0:50;hist(zn,x);
subplot(2,2,4); x=-300:300;hist(wn,x);

px=floor( mod((xn-floor(xn))*10^3,256) );
py=floor( mod((yn-floor(xn))*10^3,256) );
pz=floor( mod((zn-floor(xn))*10^3,256) );
pw=floor( mod((wn-floor(xn))*10^3,256) );

figure(3);
subplot(2,2,1); x=0:255; hist(px,x);
subplot(2,2,2); x=0:255; hist(py,x);
subplot(2,2,3); x=0:255; hist(pz,x);
subplot(2,2,4); x=0:255; hist(pw,x);


%******************读入彩色图像.bmp********************%
P_color=imread('lena.bmp','bmp');
% P_color1=imread('1.jpg','jpg');
% P_color=double(P_color1)/255;
% P_gray=rgb2gray(P_color);

R = P_color(:,:,1);
G = P_color(:,:,2);
B = P_color(:,:,3);

figure(4);
subplot(2,2,1);imshow(P_color);title('原图');
subplot(2,2,2);imhist(R);
subplot(2,2,3);imhist(G);
subplot(2,2,4);imhist(B);

% 
% px=floor( mod((xn-floor(xn))*10^3,256) );
% py=floor( mod((yn-floor(xn))*10^3,256) );
% pz=floor( mod((zn-floor(xn))*10^3,256) );
% pw=floor( mod((wn-floor(xn))*10^3,256) );
% % pv=floor( mod((vn-floor(xn))*10^3,256) );
% pp1=bitxor(px,py);
% pp2=bitxor(pz,pw);
% pp=bitxor(pp1,pp2);
% 
% %******************5d超混沌图像加密********************%
% I1=imread('./Image/Lena.jpg');
% I2=rgb2gray(I1);
% [W,H]=size(P_color)
W=512;H=512;
for i=1:H
    for j=1:W
%         Ox(i,j)=bitxor( I2(i,j),px(1,(i-1)*W +j));
        R1(i,j)=bitxor( R(i,j),py(1,(i-1)*W +j));
        G1(i,j)=bitxor( G(i,j),pz(1,(i-1)*W +j));
        B1(i,j)=bitxor( B(i,j),pw(1,(i-1)*W +j));
    end
end

    P1_color(:,:,1)=R1;
	P1_color(:,:,2)=G1;
    P1_color(:,:,3)=B1;
    imwrite(P1_color,'Encrypt1.bmp','bmp'); 

figure(5);
subplot(2,2,1);imshow(P1_color);title('加密图像');
subplot(2,2,2);imhist(R1);
subplot(2,2,3);imhist(G1);
subplot(2,2,4);imhist(B1);

