clear;clc;close all;
tic
%% task: recover P1 from c_P1 
C=imread('./images/Lena_c.bmp');
[height,width] = size(C); L1=height*width; L=4*height*width;

% generate the cipher version of P1
% c_P1=FUNC_corrBIEA_En(P1);
tmp_C=Func_BitPlane_Decomposition(C); 
C1=tmp_C(1,:); C2=tmp_C(2,:);
sum3=sum(C1)+sum(C2)
L+L/2