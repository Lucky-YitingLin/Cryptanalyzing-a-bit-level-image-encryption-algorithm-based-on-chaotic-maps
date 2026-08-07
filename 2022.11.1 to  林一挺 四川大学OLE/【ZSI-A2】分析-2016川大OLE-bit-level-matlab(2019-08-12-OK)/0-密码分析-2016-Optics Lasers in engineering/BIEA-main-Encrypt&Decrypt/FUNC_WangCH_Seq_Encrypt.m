% 程序描述：2018-IJBC-WangCH-图像加密论文实验
% 2018-International Journal of Bifurcation & Chaos-Wang CH-A New Chaotic Image Encryption Scheme Using Breadth-First Search and Dynamic Diffusion
% by whp 2018.5.28
% 加密过程： 明文图像P -> Bredth-first-search置乱图像B -> 全局置乱图像Q -> 扩散加密图像C
% 重要日志：
% 18.5.15中午完成paper-加密部分的step1-13，待分析
% 18.5.21采用龙格库塔法编写混沌程序，调用方法：Out=FUNC_Rugge_Kutta_WangCH_Chaos(XX0,N0,L/16);
% B=reshape(B',1,L);按行读取

function C=FUNC_WangCH_Seq_Encrypt(P)
%% step0：读取图像序列长度L
L=length(P);

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
end