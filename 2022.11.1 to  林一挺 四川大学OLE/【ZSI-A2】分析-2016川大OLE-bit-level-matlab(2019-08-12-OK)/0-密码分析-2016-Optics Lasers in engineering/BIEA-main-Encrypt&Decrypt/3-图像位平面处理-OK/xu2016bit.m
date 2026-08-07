%%%%%%%%%%%%%%%%%%%%%%%%%%paper1-2015/6/4-PWLCM-加密%%%%%%%%%%%%%%%%

        close all
        clear all
        clc
        img= imread('lena.bmp');
        img=double(img);
        save img.txt -ascii img
%         H1=Entropy(img);
        %lena 117 brain 4 couple 58
        img(255,255)=117;
        
        x0=0.01234567890123;
        u1=0.12345678912345;
        y0=0.01234567891234;
        u2=0.21234567891234;
        N0=500;
      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [height,width] = size(img);
        img=uint8(img);

        bitPI = zeros(height,width, 8);  
        for i = 1:8      %%图像位平面分解
            bitPI(:,:,i) = bitget(img, i);  % 
        end

        d1= zeros(1,height*width, 8);
        for i=1:8
            d1(:,:,i)=reshape(bitPI(:,:,i),1,height*width);
        end
        
        I1=[d1(:,:,1) d1(:,:,2) d1(:,:,3) d1(:,:,4)];
        I2=[d1(:,:,5) d1(:,:,6) d1(:,:,7) d1(:,:,8)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            x=PWLCM(x0,u1,height*width+N0);

            b=x(N0+1:height*width+N0);
            b=mod(floor(b*10^14),256);

            bitPC = zeros(1,height*width, 8);  
            for n = 1:8              %%量化后的混沌矩阵位平面分解
                bitPC(:,:,n) = bitget(b, n);  
            end
            b11=[bitPC(:,:,1) bitPC(:,:,3) bitPC(:,:,5) bitPC(:,:,7)];
            b22=[bitPC(:,:,2) bitPC(:,:,4) bitPC(:,:,6) bitPC(:,:,8)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%加密部分%%%%%%%%%%%%%%%%%%% 
   %%%%迭代次数
k=1;  

for s=1:k
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%扩散
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
            sum22=0;
            for i=1:4*height*width;
                sum22=sum22+I2(i);
            end

            I1=circshift(I1',sum22)';
            I1(1)=xor(xor(xor(I1(1),I2(1)),b11(1)),I1(4*height*width));
            %I1(1)=xor(xor(I1(1),I2(1)),b11(1));
            for i=2:4*height*width
                I1(i)=xor(xor(xor(I1(i),I2(i)),I1(i-1)),b11(i));
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%
            sum11=0;
            for i=1:4*height*width;
                sum11=sum11+I1(i);
            end

            I2=circshift(I2',sum11)';
            I2(1)=xor(xor(xor(I1(1),I2(1)),b22(1)),I2(4*height*width));
            %I2(1)=xor(xor(I1(1),I2(1)),b22(1));
            for i=2:4*height*width
                I2(i)=xor(xor(xor(I1(i),I2(i)),I2(i-1)),b22(i));
            end
toc
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%置乱
tic
            sum=0;
            for i=1:4*height*width;
                sum=sum+I1(i)+I2(i);
            end

            y01=mod(y0+sum/(8*height*width),1); 
            y=PWLCM(y01,u2,8*height*width+N0);
            %y=PLogistic(y01,u2,8*height*width+N0);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             y=zeros(1,8*height*width+N0);
%             y(1)=y01;
%             for i=1:8*height*width+N0-1
%                 y(i+1)=u2*y(i)*(1-y(i));
%             end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            a=y(N0+1:4*height*width+N0);
            a=mod(floor(a*10^14),4*height*width)+1;
            a1=y(4*height*width+N0+1:8*height*width+N0);
            a1=mod(floor(a1*10^14),4*height*width)+1;

            for i=1:4*height*width          %%%%%swap     
                temp=I1(i);
                I1(i)=I2(a(i));
                I2(a(i))=temp;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%
            for i=1:4*height*width        
                temp=I2(i);
                I2(i)=I1(a1(i));
                I1(a1(i))=temp;
            end
toc
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end  

            b1=zeros(1,height*width, 8);
            for i=1:4
                b1(:,:,i)=I1((i-1)*height*width+1:i*height*width);
            end
            for i=5:8
                b1(:,:,i)=I2((i-5)*height*width+1:(i-4)*height*width);
            end

            b2=zeros(height,width, 8);
            for i=1:8
                b2(:,:,i)=reshape(b1(:,:,i),height,width);
            end
     
%%%%%%%%%%%%%%%%置乱后的位平面图合并成加密图像%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  EncrypImage=combitplane(b2(:,:,1),b2(:,:,2),b2(:,:,3),b2(:,:,4),b2(:,:,5),b2(:,:,6),b2(:,:,7),b2(:,:,8));
  EncrypImage=double(EncrypImage);
  save EncrypImage1.txt -ascii EncrypImage
  H2=Entropy(EncrypImage);
  figure(1)%%%%%%原图与加密图像
  imshow(EncrypImage/255);title('EncrypImage');
