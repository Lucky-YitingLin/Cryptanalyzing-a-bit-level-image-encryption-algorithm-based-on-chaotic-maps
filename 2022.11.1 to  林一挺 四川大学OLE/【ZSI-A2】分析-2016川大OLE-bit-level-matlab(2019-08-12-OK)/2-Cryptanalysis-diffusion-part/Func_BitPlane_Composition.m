%******************************************************************%
% 程序名称：Func_BitPlane_Composition
% 2019.8.10 by whp 
%******************************************************************%

function C=Func_BitPlane_Composition(C1,C2,height,width)

%% C1和C2 -> 密文图像C
% P -> 采用BBD二进制位平面分解 A1和A2 ，顺序为由上到下，由左到右，由高位平面到低位平面
% C1=A(1,:);C2=A(2,:);
% L=4*height*width;
L1=height*width;
% C1由转换为高四位 位平面矩阵
rowC8=C1(1,1:L1);rowC7=C1(1,L1+1:2*L1);rowC6=C1(1,2*L1+1:3*L1);rowC5=C1(1,3*L1+1:4*L1);
C_8=reshape(rowC8,height,width);C_7=reshape(rowC7,height,width);
C_6=reshape(rowC6,height,width);C_5=reshape(rowC5,height,width);
% C2由转换为低四位 位平面矩阵
rowC4=C2(1,1:L1);rowC3=C2(1,L1+1:2*L1);rowC2=C2(1,2*L1+1:3*L1);rowC1=C2(1,3*L1+1:4*L1);
C_4=reshape(rowC4,height,width);C_3=reshape(rowC3,height,width);
C_2=reshape(rowC2,height,width);C_1=reshape(rowC1,height,width);
% C1和C2 合并为C
for i=1:height
    for j=1:width
        C(i,j)=C_8(i,j)*2^7+C_7(i,j)*2^6+C_6(i,j)*2^5+C_5(i,j)*2^4+C_4(i,j)*2^3+C_3(i,j)*2^2+C_2(i,j)*2^1+C_1(i,j);
    end
end
C=C';

end