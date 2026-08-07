% 程序描述：sec3.2 step3-4,step5-6比特数据的交叉置换 及其解密 实例
% 2016-Optics and Lasers in Engineering-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% by whp 2018.6.18
% 程序描述： 明文图像A -> 两个位平面A1和A2 -> ... C1和C2 -> 密文图像C

%% ****************图像位平面分解**************************
clear;clc;close all;
B1=[0,1,0,1,0,1,0,1];B2=[0,0,0,0,1,1,1,0];
Y=[2,1,4,3,6,5,8,7];Z=[8,7,6,5,4,3,1,2];
L=8;
% step3-4:把B2中的L个元素根据Y打乱位置，赋值给B1
BB1=B1;BB2=B2;
for i=1:L
    temp=BB1(i);BB1(i)=BB2(Y(i));BB2(Y(i))=temp;
end
BB1
BB2

% step5-6:把B1中的L个元素根据Z打乱位置，赋值给B2
for i=1:L
    temp=BB2(i);BB2(i)=BB1(Z(i));BB1(Z(i))=temp;
end
BB1
BB2

% 
% 对应解密 -> step5-6:把B1中的L个元素根据Z打乱位置，赋值给B2
CC1=BB1;CC2=BB2;
for i=1:L
    temp=CC2(i);CC2(i)=CC1(Z(i));CC1(Z(i))=temp;
end
CC1
CC2
% 对应解密 -> step3-4:把B2中的L个元素根据Y打乱位置，赋值给B1
for i=1:L
    temp=CC1(i);CC1(i)=CC2(Y(i));CC2(Y(i))=temp;
end
CC1
CC2
