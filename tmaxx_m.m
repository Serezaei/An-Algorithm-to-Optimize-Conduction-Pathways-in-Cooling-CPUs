function tmaxxx=tmaxx_m(Number_of_block,k,r_mat,string1,string2,r2)

%GEOMETRY

Geom =   decsg(r_mat,string2,string1);
pdem = createpde();
geometryFromEdges(pdem,Geom);


% MESH
hmax = 1/80; 
msh=generateMesh(pdem,'Hmax',hmax);
%generateMesh(pdem);

%boundary condition
SinkEdgeID_n=0;
ID_num=size(Geom,2);
for i=1:ID_num
    if Geom(4,i)==0 && Geom(5,i)==0 && Geom(2,i)<=0.1 && Geom(3,i)<=0.1
        SinkEdgeID_n=SinkEdgeID_n+1;
    end
end
SinkEdgeID=zeros(1,SinkEdgeID_n);
turn=1;
for i=1:ID_num
    if Geom(4,i)==0 && Geom(5,i)==0 && Geom(2,i)<=0.1 && Geom(3,i)<=0.1
        SinkEdgeID(1,turn)=i;
        turn=turn+1;
    end
end

applyBoundaryCondition(pdem,'Edge',SinkEdgeID,'u',0);

%PDE Coefficent

 SinkfaceID=zeros(1,Number_of_block);
 SinkfaceID(1,:)=20;
 ID_num=size(Geom,2);
ebss=1e-6;
for i=1:ID_num
    for j=1:Number_of_block
    if abs(Geom(4,i)-r2(7,j))<ebss && abs(Geom(5,i)-r2(10,j))<ebss && abs(Geom(2,i)-r2(3,j))<ebss && abs(Geom(3,i)-r2(3,j))<ebss
        SinkfaceID(1,j)=Geom(7,i);
    end
    if abs(Geom(4,i)-r2(10,j))<ebss && abs(Geom(5,i)-r2(7,j))<ebss && abs(Geom(2,i)-r2(3,j))<ebss && abs(Geom(3,i)-r2(3,j))<ebss
        SinkfaceID(1,j)=Geom(6,i);
    end
    end
end

for i=1:pdem.Geometry.NumFaces
    c=0;
    for j=1:Number_of_block
        if i==SinkfaceID(1,j)
            c=1;
        end
        if c==1
            specifyCoefficients(pdem,'m',0,'d',0,'c',k,'a',0,'f',0,'face',i);
        end
        if c==0
            specifyCoefficients(pdem,'m',0,'d',0,'c',1,'a',0,'f',1,'face',i);
        end
    end
end


%PDE SOLVE
R = solvepde(pdem);
u=R.NodalSolution;
tmaxxx = max(u);


%axis equal