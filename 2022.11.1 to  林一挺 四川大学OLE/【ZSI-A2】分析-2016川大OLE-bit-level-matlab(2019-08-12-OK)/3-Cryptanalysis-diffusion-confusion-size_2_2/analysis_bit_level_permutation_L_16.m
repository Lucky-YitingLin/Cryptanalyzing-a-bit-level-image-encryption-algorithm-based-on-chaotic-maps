
clear;clc;close all;

len=16;
len=13;
cp=zeros(1,len);
for i=1:len
    cp(i)=i-1;
end
cp1=bitand(cp,1);cp2=bitand(cp,2)/2;cp3=bitand(cp,2^2)/2^2;cp4=bitand(cp,2^3)/2^3;
cp1
cp2
cp3
cp4
sum1=sum(cp1)
sum2=sum(cp2)
sum3=sum(cp3)
sum4=sum(cp4)