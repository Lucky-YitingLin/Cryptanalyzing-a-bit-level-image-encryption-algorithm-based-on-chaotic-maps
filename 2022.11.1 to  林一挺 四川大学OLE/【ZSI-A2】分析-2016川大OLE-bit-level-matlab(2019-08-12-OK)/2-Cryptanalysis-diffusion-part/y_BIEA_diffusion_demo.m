%**********************************************************************************************%
% 2016-OLE-ËÄ´¨´óÑ§-A novel bit-level image encryption algorithm based on chaotic maps
% by whp 2019.8.10
%**********************************************************************************************%

clc;clear; close all;

% P=[101,129; 28,205];
P=imread('./images/Lena.bmp');
% P=double(P);
C=FUNC_BIEA_diffusion_En(P);

rec_P=FUNC_BIEA_diffusion_De(C);

%% output
imwrite(uint8(C),'./images/diffused_Lena.png');
% imwrite(uint8(O),'./images/cipher_all_255.png');

figure(1);
subplot(3,2,1);imshow(uint8(P));title('plain image I');
subplot(3,2,2);imhist(uint8(P));
subplot(3,2,3);imshow(uint8(C));title('cipher image C');
subplot(3,2,4);imhist(uint8(C));
subplot(3,2,5);imshow(uint8(rec_P));title('Recovered image I');
subplot(3,2,6);imhist(uint8(rec_P));