function mesh1=prepareMesh(filename)
% This function increments a certain value on the vertices of the mesh, so
% that only positive coordiantes are returned. It is just for the purpose
% plotting curves with posiitve dimensions. Any extra setup for the mehs
% can be added in here
mesh1 = stlread(filename);
vertices= mesh1.vertices;

x=vertices(:,1);
y=vertices(:,2);
z=vertices(:,3);

incrementX=0;
incrementY=0;
incrementZ=0;

if min(x)<0
    incrementX= -min(x)+1;
end

if min(y)<0
    incrementY= -min(y)+1;
end

if min(z)<0
    incrementZ= -min(z)+1;
end
x=x+incrementX;
y=y+incrementY;
z=z+incrementZ;    
    
vertices=[x,y,z];
mesh1.vertices= vertices;


end