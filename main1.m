clear all
clc
tic
%variables defined by user
k=100;
phi=10;
x_gridsize=5;
y_gridsize=5;


%first block position
Y_gridsize=2*y_gridsize;
omega=round(x_gridsize*Y_gridsize*phi/100);
tmaxxx_o=100;
r_mat_o=zeros(12,2);
Number_of_block=1;
y=1;
Break_value=0;
for x=1:x_gridsize
    [r_mat,string1,string2,r2]= makeGeometry_m(x_gridsize,y_gridsize,Number_of_block,x,y);
    tmaxxx=tmaxx_m(Number_of_block,k,r_mat,string1,string2,r2);
    if tmaxxx_o > tmaxxx
        tmaxxx_o=tmaxxx;
        r_mat_o=r_mat;
    end
end

%main algorithem
r_mat_op=r_mat_o;
epss=1e-6;
for Number_of_block=2:omega 
    Number_of_block
    r_mat_o=r_mat_op;
    for x=1:x_gridsize
        for y=1:Y_gridsize
            X=0.5*(x-1)/x_gridsize;
            Y=0.5*(y-1)/y_gridsize; 
            %verifing lack of repetition
            Break_value=0;
            for i=2:Number_of_block
                if abs((X-r_mat_o(3,i)))<epss && abs((Y-r_mat_o(7,i)))<epss    
                    Break_value=1;    
                end
            end
            if Break_value==1
                continue
            end
            %verifing vicinity block existance
            Break_value=1;
            for i=2:Number_of_block
                if (abs((X-(r_mat_o(3,i)-0.5/x_gridsize)))<epss && abs((Y-(r_mat_o(7,i)-0.5/y_gridsize)))<epss) || (abs((X-(r_mat_o(3,i)-0.5/x_gridsize)))<epss && abs(Y-r_mat_o(7,i))<epss) || (abs((X-(r_mat_o(3,i)-0.5/x_gridsize)))<epss && abs((Y-(r_mat_o(7,i)+0.5/y_gridsize)))<epss) || (abs((X-r_mat_o(3,i)))<epss && abs((Y-(r_mat_o(7,i)-0.5/y_gridsize)))<epss) || (abs((X-r_mat_o(3,i)))<epss && abs((Y-(r_mat_o(7,i)+0.5/y_gridsize)))<epss) || (abs((X-(r_mat_o(3,i)+0.5/x_gridsize)))<epss && abs((Y-(r_mat_o(7,i)+0.5/y_gridsize)))<epss) || (abs((X-(r_mat_o(3,i)+0.5/x_gridsize)))<epss && abs((Y-r_mat_o(7,i)))<epss) || (abs((X-(r_mat_o(3,i)+0.5/x_gridsize)))<epss && abs((Y-(r_mat_o(7,i)-0.5/y_gridsize)))<epss)    
                    Break_value=0;   
                end
            end
            if Break_value==1
                continue
            end
            [r_mat,string1,string2,r2]= Add_Block(x_gridsize,y_gridsize,Number_of_block,X,Y,r_mat_o);
            tmaxxx=tmaxx_m(Number_of_block,k,r_mat,string1,string2,r2);
            if (tmaxxx_o > tmaxxx) && tmaxxx~=0
                tmaxxx_o=tmaxxx;
                r_mat_op=r_mat;
                string1_op=string1;
                string2_op=string2;
                r2_op=r2;
            end
        end
    end
end

%ploting
plot_tmaxx(x_gridsize,y_gridsize,Number_of_block,k,r_mat_op,string1_op,string2_op,r2_op)
h=size(r2_op,2);

%%defining geometry matrix
geo_mat=zeros(h,2);
for i=1:h
    geo_mat(i,1)=r2_op(3,i)*x_gridsize*2+1;
    geo_mat(i,2)=r2_op(7,i)*y_gridsize*2+1;
end
tmax=tmaxxx_o
toc