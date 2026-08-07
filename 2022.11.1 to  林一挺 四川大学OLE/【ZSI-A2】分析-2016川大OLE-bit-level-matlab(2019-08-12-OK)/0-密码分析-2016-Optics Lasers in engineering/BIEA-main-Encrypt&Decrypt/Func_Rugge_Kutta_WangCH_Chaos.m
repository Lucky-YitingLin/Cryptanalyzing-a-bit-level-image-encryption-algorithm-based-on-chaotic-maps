% 程序名称：FUNC_Rugge_Kutta_WangCH_4D_hyperchaos
% 2018-International Journal of Bifurcation & Chaos-Wang CH-
% A New Chaotic Image Encryption Scheme Using Breadth-First Search and Dynamic Diffusion
% 2018.5.21 by whp 
% 程序描述：连续混沌系统离散化，使用四阶龙格-库塔（Rugge-Kutta）方法 

function Out=Func_Rugge_Kutta_WangCH_Chaos(XX0,N0,L)
h=0.001;     % 离散化控制参数 h=0.001; 
% N0为前面丢弃个数，L为所取序列长度
n=L;t=N0;
a=35;b=8/3;c=55;d=1.3;
% x0=1;y0=0.949;z0=1;w0=1;
x0=XX0(1);y0=XX0(2);z0=XX0(3);w0=XX0(4);
xn=zeros(1,n);yn=zeros(1,n);zn=zeros(1,n);wn=zeros(1,n);

for i=1:n+t
    K11 = a*(y0-x0) +y0*z0;                K12 = a*(y0-(x0 +K11*h/2)) +y0*z0;     
    K13 = a*(y0-(x0 +K12*h/2)) +y0*z0;     K14 = a*(y0-(x0 +K13*h/2)) +y0*z0;   
    x1 = x0 +(K11 +2*K12 +2*K13 +K14)*h/6;
    
    K21 = c*x1-y0-x1*z0+w0;                K22 = c*x1 -(y0 +K21*h/2)-x1*z0+w0;                
    K23 = c*x1 -(y0 +K22*h/2)-x1*z0+w0;    K24 = c*x1 -(y0 +K23*h/2)-x1*z0+w0;
    y1 = y0 +(K21 +2*K22 +2*K23 +K24)*h/6;
    
    K31 = x1*y1-b*z0;                   K32 = x1*y1 -b*(z0 +K31*h/2);                
    K33 = x1*y1 -b*(z0 +K32*h/2);       K34 = x1*y1 -b*(z0 +K33*h/2);
    z1 = z0 +(K31 +2*K32 +2*K33 +K34)*h/6;
    
    K41 = -x1*z1 +d*w0;                 K42 = -x1*z1 +d*(w0 +K41*h/2);
    K43 = -x1*z1 +d*(w0 +K42*h/2);      K44 = -x1*z1 +d*(w0 +K43*h/2);
    w1 = w0 +(K41 +2*K42 +2*K43 +K44)*h/6;  
   
    x0=x1;y0=y1;z0=z1;w0=w1;
    if i>t
        xn(i-t) = x1;yn(i-t) = y1;zn(i-t) = z1;wn(i-t) = w1;
    end
end
Out(1,:)=xn(1:L);
Out(2,:)=yn(1:L);
Out(3,:)=zn(1:L);
Out(4,:)=wn(1:L);
end