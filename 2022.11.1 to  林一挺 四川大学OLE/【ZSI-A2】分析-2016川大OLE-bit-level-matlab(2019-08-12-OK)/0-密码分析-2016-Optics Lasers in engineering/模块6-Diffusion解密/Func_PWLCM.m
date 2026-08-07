% 程序名称：Func_PWLCM(x0,u0,N0,len)
% 2018.6.17 by whp 

function Out=Func_PWLCM(x0,u0,N0,len)

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
      
Out=X(N0+1:N0+len);
end