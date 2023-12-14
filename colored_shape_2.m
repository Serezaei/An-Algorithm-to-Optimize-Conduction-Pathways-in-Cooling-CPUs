
clc
clear all
k=300;
x_gridsize=40;
y_gridsize=40/3.4973;
array_mat_1=[9	1
10	2
11	3
12	4
13	5
14	6
15	7
16	8
17	9
18	10
19	11
20	12
21	13
22	14
21	15
21	16
21	17
21	18
21	19
20	20
21	21
10	1
11	2
12	3
20	22
13	4
14	5
15	6
16	7
17	8
18	9
19	10
20	11
21	14
21	12
8	1
22	13
9	2
10	3
11	4
22	15
12	5
13	6
17	7
16	6
18	8
15	5
14	4
19	9
13	3
12	2
20	10
11	1
7	1
8	2
18	7
21	11
17	6
19	8
16	5
20	9
21	10
15	4
22	12
14	3
22	11
13	2
22	16
15	3
6	1
16	4
22	17
17	5
18	6
23	13
19	7
23	12
20	8
9	3
21	9
7	2
22	10
23	11
12	1
23	14
14	2
23	15
20	7
23	18
19	6
22	20
21	8
24	19
18	5
24	20
22	9
10	4
23	10
17	4
20	19
16	3
20	16
15	2
25	21
13	1
24	12
24	11
8	3
25	13
26	14
27	15
20	6
20	17
19	5
19	18
18	4
21	7
20	13
22	8
28	16
23	9
29	17
24	10
5	1
6	2
17	3
19	21
18	2
18	22
19	2
11	5
22	7
19	17
21	6
17	22
20	3
30	18
23	8
12	7
20	5
11	8
24	9
9	4
7	3
26	22
25	12
25	11
16	2
12	6
25	10
19	4
17	2
12	9
14	1
5	2
4	1
6	3
23	7
13	10
22	6
14	11
24	8
13	12
21	4
13	13
22	5
12	14
20	2
11	15
21	2
10	16
22	2
11	17
23	3
10	18
24	2
9	19
25	3
26	4
8	20
31	17
32	16
26	13

];

grid_size_x=0.5/x_gridsize;
grid_size_y=0.5/y_gridsize;
Number_of_block=2*size(array_mat_1,1);
array_mat_2=array_mat_1;
array_mat_2(:,1)=-array_mat_1(:,1);
array_mat=[array_mat_1;array_mat_2];

%GEOMETRY
sink_num=size(array_mat,1);
r0 = [3 6 0.5 0.1 -0.1 -0.5 -0.5 0.5 0 0 0 0 1 1];
r_mat=r0;
string1=['R100'];
string2=['R100'];
sink_num=size(array_mat,1);
for i=1:sink_num
    if i<=(sink_num/2)
        x1=(array_mat(i,1)-1)*grid_size_x;
        x2=array_mat(i,1)*grid_size_x;
    end
    if i>(sink_num/2)
        x1=(array_mat(i,1)+1)*grid_size_x;
        x2=array_mat(i,1)*grid_size_x;
    end
    y1=(array_mat(i,2)-1)*grid_size_y;
    y2=array_mat(i,2)*grid_size_y;
    r= [3 4 x1 x2 x2 x1 y1 y1 y2 y2 0 0 0 0];
    r_mat= [r_mat ; r];
    if i==1
        r2_op=r;
    end
    if i>1
        r2_op=[r2_op;r];
    end
    Rn=['R' num2str(100+i)];
    string1=[string1; Rn];
    string2=[string2 '+' Rn];
end

r_mat= r_mat';
string1=string1';
r2_op=r2_op';
Geom =decsg(r_mat,string2,string1);
pdem =createpde();
geometryFromEdges(pdem,Geom);
figure
pdegplot(pdem,'EdgeLabels','on'); 
pdegplot(pdem,'SubdomainLabels','on'); 

% MESH
hmax = 1/80; 
msh=generateMesh(pdem,'Hmax',hmax);
figure
pdeplot(pdem);


%boundary condition
SinkEdgeID_n=0;
ID_num=size(Geom,2);
for i=1:ID_num
    if Geom(4,i)==0 && Geom(5,i)==0 && Geom(2,i)<=0.1  && Geom(3,i)<=0.1 && Geom(2,i)>=-0.1  && Geom(3,i)>=-0.1
        SinkEdgeID_n=SinkEdgeID_n+1;
    end
end
SinkEdgeID=zeros(1,SinkEdgeID_n);
turn=1;
for i=1:ID_num
    if Geom(4,i)==0 && Geom(5,i)==0 && Geom(2,i)<=0.1  && Geom(3,i)<=0.1 && Geom(2,i)>=-0.1  && Geom(3,i)>=-0.1
        SinkEdgeID(1,turn)=i;
        turn=turn+1;
    end
end

for i=1:SinkEdgeID_n
    applyBoundaryCondition(pdem,'Edge',SinkEdgeID(1,i),'u',0);
end

%PDE Coefficent

SinkfaceID=zeros(1,Number_of_block);
SinkfaceID(1,:)=20;
ID_num=size(Geom,2);
ebss=1e-6;
tic
for i=1:ID_num
    for j=1:Number_of_block
        if (j)<=(sink_num/2)
               if abs(Geom(4,i)-r2_op(7,j))<ebss && abs(Geom(5,i)-r2_op(10,j))<ebss && abs(Geom(2,i)-r2_op(3,j))<ebss && abs(Geom(3,i)-r2_op(3,j))<ebss
                   SinkfaceID(1,j)=Geom(7,i);
               end
               if abs(Geom(4,i)-r2_op(10,j))<ebss && abs(Geom(5,i)-r2_op(7,j))<ebss && abs(Geom(2,i)-r2_op(3,j))<ebss && abs(Geom(3,i)-r2_op(3,j))<ebss
                   SinkfaceID(1,j)=Geom(6,i);
               end
        end
        if (j)>(sink_num/2)
               if abs(Geom(4,i)-r2_op(10,j))<ebss && abs(Geom(5,i)-r2_op(7,j))<ebss && abs(Geom(2,i)-r2_op(3,j))<ebss && abs(Geom(3,i)-r2_op(3,j))<ebss
                   SinkfaceID(1,j)=Geom(7,i);
               end
               if abs(Geom(4,i)-r2_op(7,j))<ebss && abs(Geom(5,i)-r2_op(10,j))<ebss && abs(Geom(2,i)-r2_op(3,j))<ebss && abs(Geom(3,i)-r2_op(3,j))<ebss
                   SinkfaceID(1,j)=Geom(6,i);
               end
        end
    end
end
toc
heatedFacesID=setdiff(1:pdem.Geometry.NumFaces,SinkfaceID);
specifyCoefficients(pdem,'m',0,'d',0,'c',1,'a',0,'f',1,'face',heatedFacesID);
specifyCoefficients(pdem,'m',0,'d',0,'c',k,'a',0,'f',0,'face',SinkfaceID);
toc

%PDE SOLVE
R = solvepde(pdem);
u=R.NodalSolution;
tmaxxx = max(u);
figure
pdeplot(pdem,'xydata',u,'contour','on','colormap','jet'); 
axis off
colorbar off
daspect([1,1,1])

%axis equal