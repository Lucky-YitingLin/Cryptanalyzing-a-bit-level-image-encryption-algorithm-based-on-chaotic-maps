% 程序描述：2018-IJBC-WangCH-图像加密论文实验
% 2018-International Journal of Bifurcation & Chaos-Wang CH-A New Chaotic Image Encryption Scheme Using Breadth-First Search and Dynamic Diffusion
% by whp 2018.5.28
% 解密过程： 密文图像C -> 反扩散 -> 全局置乱图像Q -> 双重反置乱 -> 解密的明文图像P
% 重要日志：
% 解密最关键一步为第一步，利用sum1(L)=0,从q(L)开始解
% 18.5.28下午18：00-反扩散解密OK

function P=FUNC_WangCH_Seq_Decrypt(C)
%% step0：读取图像序列长度L
L=length(C);

%% step1：FUNC1_WangCH_4D_hyperchaos产生L/16的两个混沌序列k1,k2
N0=100;XX0(1)=1;XX0(2)=0.949;XX0(3)=1;XX0(4)=1;
Out=Func_Rugge_Kutta_WangCH_Chaos(XX0,N0,L/16);
x=Out(1,:);y=Out(2,:);z=Out(3,:);w=Out(4,:);
k1=mod(floor(((x+y)-fix(x+y))*10^16),4);
k2=mod(floor(((z+w)-fix(z+w))*10^16),4);

%% step2：FUNC2_WangCH_4D_hyperchaos产生L的两个混沌序列k3,k4
N0=100;XX0(1)=1.01;XX0(2)=0.95;XX0(3)=1.01;XX0(4)=1.01;
Out=Func_Rugge_Kutta_WangCH_Chaos(XX0,N0,L);
xx=Out(1,:);yy=Out(2,:);zz=Out(3,:);ww=Out(4,:);
k3=xx+zz;
% k4=mod(floor((yy+ww)*10^15),256); %直方图不均匀
k4=mod(floor((yy+ww)*10^5),256);
[valuek3,T] = sort(k3);
% Q=B;
% for i=1:L
%     t=Q(i);Q(i)=Q(T(i));Q(T(i))=t;
% end
%% step3：混沌序列k4在Breadth-first-search控制序列k2作用下，生成新的密钥序列k
for i=1:L/16
    AA(i,:)=k4(16*(i-1)+1:16*i);
    k(i,:)=Func_Bredth_first_search(AA(i,:),k2(i));
end
k=reshape(k,1,L);

%% step4：i=L,L-1,...,2,1时，反扩散解密过程
% q(i)=bitxor( bitxor(C(i),mod(C(i-1)+k(j(i)),256)), mod(sum1(i)+k(i),256));
sum2(1)=0;
for i=2:L
    sum2(i)=sum2(i-1)+double(C(i-1));
    j(i)=mod(sum2(i)*10^10,L)+1;
end
sum1(L)=0;
q(L)=bitxor( bitxor(C(L),mod(C(L-1)+k(j(L)),256)), mod(sum1(L)+k(L),256));      %q(L)=129，验证正确

for i=L-1:-1:2   
    sum1(i)=sum1(i+1)+q(i+1);        %sum1从后面累加的表达式;
    q(i)=bitxor( bitxor(C(i),mod(C(i-1)+k(j(i)),256)), mod(sum1(i)+k(i),256));
end

sum1(1)=sum1(2)+q(2);    %for循环里的最后 已经加上了q(2)
q(1)=bitxor( bitxor(C(1),k(1)), mod(sum1(1)+k(1),256));      %q(1)=137，验证正确
Q=double(q);
%% step5：全局反置乱Q -> B
B=Q;
for i=L:-1:1
    t=B(i);B(i)=B(T(i));B(T(i))=t;
end

%% step6：调用Func_Bredth_first_search反置乱，使得B -> P
S=B;
for i=1:L/16
    A(i,:)=S(16*(i-1)+1:16*i);
    S1(i,:)=Func_Reverse_Bredth_first_search(A(i,:),k1(i));
end
P1=S1;
P2=P1';
P=reshape(P2,1,L);
end