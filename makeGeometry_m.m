function [r_mat,string1,string2,r2]= makeGeometry_m(x_gridsize,y_gridsize,Number_of_block,x,y)
%defining geo matrix
r1=[3; 5; 0; 0.1; 0.5; 0.5; 0; 0; 0; 0;1;1];
r2=zeros(12,Number_of_block);
r2(1,:)=3;
r2(2,:)=4;

for i=1:Number_of_block
    r2(3,i)=0.5*(x-1)/x_gridsize;
    r2(7,i)=0.5*(y-1)/y_gridsize;
    r2(4,i)=r2(3,i)+0.5/x_gridsize;
    r2(5,i)=r2(4,i);
    r2(6,i)=r2(3,i);
    r2(8,i)=r2(7,i);
    r2(9,i)=r2(8,i)+0.5/y_gridsize;
    r2(10,i)=r2(9,i);
end
r_mat=[r1 r2];

%defining char strings

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
