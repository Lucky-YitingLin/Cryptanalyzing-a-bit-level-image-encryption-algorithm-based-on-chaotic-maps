% 程序名称：Func_image_combine2to1，将图像的两部分合并为一张图像
% 2018.6.18 by whp 

function C=Func_image_combine2to1(C1,C2)
L1=length(C1)/4;
H=sqrt(L1);W=H;
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
end