%**********************************************************************************************%
% 分析2016-OLE-四川大学-A novel bit-level image encryption algorithm based on chaotic maps
% 描述：对于256*256图像，构造2*log2(4*256*256)=2*18=36幅选择密文图像
% by whp 2019.8.12 
%**********************************************************************************************%

clear;clc;close all;
tic
%% task: recover P1 from c_P1 
C=imread('./images/Lena_c.bmp');
[height,width] = size(C); L1=height*width; L=4*height*width;
tmp_C=Func_BitPlane_Decomposition(C); 
C1=tmp_C(1,:); C2=tmp_C(2,:);
sum3=sum(C1)+sum(C2)

%% Part 2. Similarly, construct log2(L)  chosen cipher images by the feature of C2 to solve index_Y

%% construct the chosen cipher images
CC1_2=zeros(1,L);
cp=zeros(1,L);
for i=1:L
    cp(i)=i-1;
end
CC1_1=bitand(cp,1);CC2_1=bitand(cp,2)/2;CC3_1=bitand(cp,2^2)/2^2;CC4_1=bitand(cp,2^3)/2^3;
CC5_1=bitand(cp,2^4)/2^4;CC6_1=bitand(cp,2^5)/2^5;CC7_1=bitand(cp,2^6)/2^6;CC8_1=bitand(cp,2^7)/2^7;
CC9_1=bitand(cp,2^8)/2^8;CC10_1=bitand(cp,2^9)/2^9;CC11_1=bitand(cp,2^10)/2^10;CC12_1=bitand(cp,2^11)/2^11;
CC13_1=bitand(cp,2^12)/2^12;CC14_1=bitand(cp,2^13)/2^13;CC15_1=bitand(cp,2^14)/2^14;CC16_1=bitand(cp,2^15)/2^15;
CC17_1=bitand(cp,2^16)/2^16;CC18_1=bitand(cp,2^17)/2^17;
c2_sum=sum3-sum(CC1_1);
CC1_2(1:c2_sum)=1; 

%% BPC to formulate the chosen cipher images: (just reverse CC_1 and CC_2)
CC1=Func_BitPlane_Composition(CC1_2,CC1_1,height,width);
CC2=Func_BitPlane_Composition(CC1_2,CC2_1,height,width);
CC3=Func_BitPlane_Composition(CC1_2,CC3_1,height,width);
CC4=Func_BitPlane_Composition(CC1_2,CC4_1,height,width);
CC5=Func_BitPlane_Composition(CC1_2,CC5_1,height,width);
CC6=Func_BitPlane_Composition(CC1_2,CC6_1,height,width);
CC7=Func_BitPlane_Composition(CC1_2,CC7_1,height,width);
CC8=Func_BitPlane_Composition(CC1_2,CC8_1,height,width);
CC9=Func_BitPlane_Composition(CC1_2,CC9_1,height,width);

CC10=Func_BitPlane_Composition(CC1_2,CC10_1,height,width);
CC11=Func_BitPlane_Composition(CC1_2,CC11_1,height,width);
CC12=Func_BitPlane_Composition(CC1_2,CC12_1,height,width);
CC13=Func_BitPlane_Composition(CC1_2,CC13_1,height,width);
CC14=Func_BitPlane_Composition(CC1_2,CC14_1,height,width);
CC15=Func_BitPlane_Composition(CC1_2,CC15_1,height,width);
CC16=Func_BitPlane_Composition(CC1_2,CC16_1,height,width);
CC17=Func_BitPlane_Composition(CC1_2,CC17_1,height,width);
CC18=Func_BitPlane_Composition(CC1_2,CC18_1,height,width);


figure(2);
subplot(5,8,1);imshow(uint8(CC1));title('1st chosen cipher image');
subplot(5,8,2);imhist(uint8(CC1));title('histogram');
subplot(5,8,3);imshow(uint8(CC2));title('2nd chosen cipher image');
subplot(5,8,4);imhist(uint8(CC2));title('histogram');
subplot(5,8,5);imshow(uint8(CC3));title('3rd chosen cipher image');
subplot(5,8,6);imhist(uint8(CC3));title('histogram');

subplot(5,8,7);imshow(uint8(CC4));title('4th chosen cipher image');
subplot(5,8,8);imhist(uint8(CC4));title('histogram');
subplot(5,8,9);imshow(uint8(CC5));title('5th chosen cipher image');
subplot(5,8,10);imhist(uint8(CC5));title('histogram');
subplot(5,8,11);imshow(uint8(CC6));title('6th chosen cipher image');
subplot(5,8,12);imhist(uint8(CC6));title('histogram');

subplot(5,8,13);imshow(uint8(CC7));title('7th chosen cipher image');
subplot(5,8,14);imhist(uint8(CC7));title('histogram');
subplot(5,8,15);imshow(uint8(CC8));title('8th chosen cipher image');
subplot(5,8,16);imhist(uint8(CC8));title('histogram');
subplot(5,8,17);imshow(uint8(CC9));title('9th chosen cipher image');
subplot(5,8,18);imhist(uint8(CC9));title('histogram');
% 
subplot(5,8,19);imshow(uint8(CC10));title('10th chosen cipher image');
subplot(5,8,20);imhist(uint8(CC10));title('histogram');
subplot(5,8,21);imshow(uint8(CC11));title('11th chosen cipher image');
subplot(5,8,22);imhist(uint8(CC11));title('histogram');
subplot(5,8,23);imshow(uint8(CC12));title('12th chosen cipher image');
subplot(5,8,24);imhist(uint8(CC12));title('histogram');

subplot(5,8,25);imshow(uint8(CC13));title('13th chosen cipher image');
subplot(5,8,26);imhist(uint8(CC13));title('histogram');
subplot(5,8,27);imshow(uint8(CC14));title('14th chosen cipher image');
subplot(5,8,28);imhist(uint8(CC14));title('histogram');
subplot(5,8,29);imshow(uint8(CC15));title('15th chosen cipher image');
subplot(5,8,30);imhist(uint8(CC15));title('histogram');

subplot(5,8,31);imshow(uint8(CC16));title('16th chosen cipher image');
subplot(5,8,32);imhist(uint8(CC16));title('histogram');
subplot(5,8,33);imshow(uint8(CC17));title('17th chosen cipher image');
subplot(5,8,34);imhist(uint8(CC17));title('histogram');
subplot(5,8,35);imshow(uint8(CC18));title('18th chosen cipher image');
subplot(5,8,36);imhist(uint8(CC18));title('histogram');

imwrite(uint8(CC1),'./images/CC1b.png');  %注意，写入时要采用uint8类型，否则读取时出错
imwrite(uint8(CC2),'./images/CC2b.png'); 
imwrite(uint8(CC3),'./images/CC3b.png'); 
imwrite(uint8(CC4),'./images/CC4b.png'); 
imwrite(uint8(CC5),'./images/CC5b.png'); 
imwrite(uint8(CC6),'./images/CC6b.png'); 
imwrite(uint8(CC7),'./images/CC7b.png'); 
imwrite(uint8(CC8),'./images/CC8b.png'); 
imwrite(uint8(CC9),'./images/CC9b.png'); 
imwrite(uint8(CC10),'./images/CC10b.png'); 
imwrite(uint8(CC11),'./images/CC11b.png'); 
imwrite(uint8(CC12),'./images/CC12b.png'); 
imwrite(uint8(CC13),'./images/CC13b.png'); 
imwrite(uint8(CC14),'./images/CC14b.png'); 
imwrite(uint8(CC15),'./images/CC15b.png'); 
imwrite(uint8(CC16),'./images/CC16b.png'); 
imwrite(uint8(CC17),'./images/CC17b.png'); 
imwrite(uint8(CC18),'./images/CC18b.png');

% %%  use the decryption machine
CP1=FUNC_corrBIEA_De(CC1); CP2=FUNC_corrBIEA_De(CC2); CP3=FUNC_corrBIEA_De(CC3); 
CP4=FUNC_corrBIEA_De(CC4); CP5=FUNC_corrBIEA_De(CC5); CP6=FUNC_corrBIEA_De(CC6);
CP7=FUNC_corrBIEA_De(CC7); CP8=FUNC_corrBIEA_De(CC8); CP9=FUNC_corrBIEA_De(CC9);
CP10=FUNC_corrBIEA_De(CC10); CP11=FUNC_corrBIEA_De(CC11); CP12=FUNC_corrBIEA_De(CC12);
CP13=FUNC_corrBIEA_De(CC13); CP14=FUNC_corrBIEA_De(CC14); CP15=FUNC_corrBIEA_De(CC15);
CP16=FUNC_corrBIEA_De(CC16); CP17=FUNC_corrBIEA_De(CC17); CP18=FUNC_corrBIEA_De(CC18);

imwrite(uint8(CP1),'./images/CP1b.png');  %注意，写入时要采用uint8类型，否则读取时出错
imwrite(uint8(CP2),'./images/CP2b.png'); 
imwrite(uint8(CP3),'./images/CP3b.png'); 
imwrite(uint8(CP4),'./images/CP4b.png'); 
imwrite(uint8(CP5),'./images/CP5b.png'); 
imwrite(uint8(CP6),'./images/CP6b.png'); 
imwrite(uint8(CP7),'./images/CP7b.png'); 
imwrite(uint8(CP8),'./images/CP8b.png'); 
imwrite(uint8(CP9),'./images/CP9b.png'); 
imwrite(uint8(CP10),'./images/CP10b.png'); 
imwrite(uint8(CP11),'./images/CP11b.png'); 
imwrite(uint8(CP12),'./images/CP12b.png'); 
imwrite(uint8(CP13),'./images/CP13b.png'); 
imwrite(uint8(CP14),'./images/CP14b.png'); 
imwrite(uint8(CP15),'./images/CP15b.png'); 
imwrite(uint8(CP16),'./images/CP16b.png'); 
imwrite(uint8(CP17),'./images/CP17b.png'); 
imwrite(uint8(CP18),'./images/CP18b.png');

