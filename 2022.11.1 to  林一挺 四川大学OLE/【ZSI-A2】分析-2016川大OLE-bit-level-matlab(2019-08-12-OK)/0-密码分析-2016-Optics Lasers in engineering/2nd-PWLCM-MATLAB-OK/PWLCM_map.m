clear;clc;close all;
x0=0.3;u0=0.2;N0=100;len=200;

X(1)=x0;      %初始值
p=u0;
% u=1.99999999;  %系统参数设置
M=N0+len;
for k=1:M
    if X(k)>=0&&X(k)<p
        X(k+1)=X(k)/p;
    elseif X(k)>=p&&X(k)<0.5
        X(k+1)=(X(k)-p)/(0.5-p);
    elseif X(k)>=0.5&&X(k)<1-p
        X(k+1)=(1-p-X(k))/(0.5-p);
    else
        X(k+1)=(1-X(k))/p;
    end
end
      
t=1:M;
n1=M/2;
%n1=1;
n2=M;

figure(1)
subplot(1,2,1);
plot(t(n1:n2),X(n1:n2),'b-');
hold on
plot(t(n1:n2),X(n1:n2),'r.');
hold off
xlabel('n','fontsiZe',20,'fontname','times new roman','FontAngle','italic');
ylabel('x_n','fontsiZe',20,'fontname','times new roman','FontAngle','italic');

m=n1:n2;
subplot(1,2,2);
plot(X(m-1),X(m),'b.');
xlabel('x_n','fontsiZe',20,'fontname','times new roman','FontAngle','italic');
ylabel('x_n_+_1','fontsiZe',20,'fontname','times new roman','FontAngle','italic');
