function [r_mat,string1,string2,r2]= Add_Block_ex(x_gridsize,y_gridsize,Number_of_block,X,Y,r_mat_o)           
%defining new block
r3=zeros(12,1);
r3(1,1)=3;
r3(2,1)=4;
r3(3,1)=X;
r3(7,1)=Y;
r3(4,1)=r3(3,1)+0.5/x_gridsize;
r3(5,1)=r3(4,1);
r3(6,1)=r3(3,1);
r3(8,1)=r3(7,1);
r3(9,1)=r3(8,1)+0.5/y_gridsize;
r3(10,1)=r3(9,1);

%new matrix

r_mat=[r_mat_o r3];

%strings
A=zeros(Number_of_block+1,2);
A(:,1)=82;
for i=1:Number_of_block+1
    rem=mod(i,10);
    mag=i/10-rem/10;
    A(i,1)=65+mag;
    A(i,2)=48+rem;
   
end
string1=char(A);
string1=string1';
B=zeros(1,Number_of_block*3+2);
for i=1:Number_of_block+1
       rem=mod(i,10);
    mag=i/10-rem/10; 
    B(1,3*i-2)=65+mag;
    B(1,3*i-1)=48+rem;
end
for i=1:Number_of_block
    B(1,3*i)=43;   
end
string2=char(B);

%r2 matrix
r2=zeros(12,Number_of_block);
for i=1:Number_of_block
    r2(:,i)=r_mat(:,i+1);
end