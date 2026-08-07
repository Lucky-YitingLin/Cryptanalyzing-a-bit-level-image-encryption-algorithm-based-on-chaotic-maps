
function BB=Func_do_diffusion_by_b1b2(P,ks_b1,ks_b2)
[height,width] = size(P); L1=height*width; L=4*height*width;

%% BPD
A=Func_BitPlane_Decomposition(P); A1=A(1,:); A2=A(2,:);

%% Stage 1. diffusion: get B1,B2 from A1,A2 by using b1,b2

%  step 1. sum of A2
sum1=sum(A2);
%  step 2. get A11 from A1 using cycle right shift by sum1 bits
A11=circshift(A1',sum1)';

%  step 3. diffusion of 1st element of A11
B1(1)= bitxor( bitxor(A11(1),A2(1)), ks_b1(1) ); 
% step 4-step 5
for i=2:L
    B1(i)= bitxor( bitxor(bitxor(A11(i),A11(i-1)),A2(i)), ks_b1(i) ); 
end

% step 6
sum2=sum(B1);
%  step 7. get A22 from A2 using cycle right shift by sum2 bits
A22=circshift(A2',sum2)';

%  step 8. diffusion of 1st element of A22
B2(1)= bitxor( bitxor(A22(1),B1(1)), ks_b2(1) ); 
% step 9-step 10
for i=2:L
    B2(i)= bitxor( bitxor(bitxor(A22(i),A22(i-1)),B1(i)), ks_b2(i) ); 
end

BB(1,:)=B1; BB(2,:)=B2; 

%% BPC
% C=Func_BitPlane_Composition(B1,B2,height,width);
end