%******************************************************************%
% 程序名称：Func_BitPlane_Decomposition
% 2019.8.10 by whp 
%******************************************************************%

function A=Func_BitPlane_Decomposition(P)
[height,width] = size(P);
img=uint8(P);
bitPI = zeros(height,width, 8);  
for i = 1:8
    bitPI(:,:,i) = bitget(img, i); 
end
I1=bitPI(:,:,1);I2=bitPI(:,:,2);I3=bitPI(:,:,3);I4=bitPI(:,:,4);
I5=bitPI(:,:,5);I6=bitPI(:,:,6);I7=bitPI(:,:,7);I8=bitPI(:,:,8);

%% stpe1:明文图像P -> A1和A2
% P -> 采用BBD二进制位平面分解 A1和A2 ，顺序为由上到下，由左到右，由高位平面到低位平面
L=4*height*width;
L1=height*width;
% A1=zeros(1,L);   %预分配内存
% A2=zeros(1,L);   %预分配内存
A=zeros(2,L);
% A1由高四位的比特组成
rowI8=reshape(I8',1,height*width);rowI7=reshape(I7',1,height*width);
rowI6=reshape(I6',1,height*width);rowI5=reshape(I5',1,height*width);
A(1,1:L1)=rowI8;A(1,L1+1:2*L1)=rowI7;A(1,2*L1+1:3*L1)=rowI6;A(1,3*L1+1:4*L1)=rowI5;
% A2由低四位的比特组成
rowI4=reshape(I4',1,height*width);rowI3=reshape(I3',1,height*width);
rowI2=reshape(I2',1,height*width);rowI1=reshape(I1',1,height*width);
A(2,1:L1)=rowI4;A(2,L1+1:2*L1)=rowI3;A(2,2*L1+1:3*L1)=rowI2;A(2,3*L1+1:4*L1)=rowI1;

end