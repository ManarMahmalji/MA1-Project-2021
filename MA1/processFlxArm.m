function humerus= processFlxArm(mesh)
% This function estimates the shoulder and elbow joints for a stretched arm, 
% calucaltes the corresponding humerus length , and plots it in 3D
% 
% Input:
% mesh: pathc struct with fields: faces and vertices
% 
% Output:
% humerus: float, humeus bone length in cm



vertices=mesh.vertices;
x=vertices(:,1);
y=vertices(:,2);
z=vertices(:,3);

% Get shoulder point

% Divide the vertices into two groups based on their midpoint( threshold) in the
% x direction and find shoulder among all points in the left group
thr= (max(x)+min(x))/2;
% filtering and extracting points less than midpoint
filter= x<thr;
x=nonzeros(filter.*x);
y=nonzeros(filter.*y);
z=nonzeros(filter.*z);
% Finding the vertex with max z-coordiante
[Zmax,I]=max(z);
Xs= x(I);
% Cutting with an x-section at this vertex 
secVert=findXSection(mesh,Xs);
% Shouler joint is approximated to be the center of gravity of the section
shoulder= [Xs,mean(secVert(:,2)),mean(secVert(:,3))];

% Get elbow point 

% To get the elbow point, the exterenal and internal corners of the flexed  
% arm should be approximated

 x=vertices(:,1);
 y=vertices(:,2);
 z=vertices(:,3);
 
% Get interanl corner

% Dividing the scan into segments along z-axis
% 50 segments between max and min z coordinates 
scale= linspace(min(z)+1,max(z)-1,50);
segments(size(scale,2)).pts= zeros(1000,3);
% Recrding segments in a vector of struct
for i=1:size(scale,2)
    Zs=scale(i);
    segments(i).pts=findZSection(mesh,Zs);
end


% sorting each of the segments in the x diretion in ascending order
for i=1:size(segments,2)
  Xseg= segments(i).pts(:,1);
  Yseg= segments(i).pts(:,2);
  Zseg= segments(i).pts(:,3);
  segVert= [Xseg Yseg Zseg];
  [temp,I]=sort(Xseg);
  segVert= segVert(I,:);
  segments(i).pts= segVert;
end

% looping through each segment and checking each two successive vertices if
% they have a difference in x greater than 20 mm 

intCorn=0;
segment=0;

for i=1:size(segments,2) 
  Xseg= segments(i).pts(:,1);
  Zseg= segments(i).pts(:,3);
  for j=1:size(Xseg,1)-1
     if Xseg(j+1)-Xseg(j)>20 && Zseg(j)> shoulder(3)
       % if we found an x gap greater thatn 20 mm and greater than elbow joint,
       % record the indices of the segment and the internal corner point
       
       intCorn=j;
       segment= i;
       break
     end
  end
  if intCorn~= 0
      % if we find our point, no need to keep looping
      break
  end
end

% Extracting coordinates of internal corner
point1=segments(segment).pts(intCorn+1,:);

% Get external corner

% Cut at 5 mm offset from Xmax( can be increased. Trial and error is used, but in any case, 
% would not make much differnce in the elbow approximation) 
Xmax= max(x);
Xs=Xmax-5;
secVert=findXSection(mesh,Xs);
% External corner is approximated as the lowest vertex among the section
% points
[val,I]= min(secVert(:,3));
point2= [Xs,secVert(I,2),secVert(I,3)];
% Elbow joint lies on the line joining the internal and external corners of
% arm ﬂexion at approximately 1/3 from the external corner
elbow=0.33*point1+0.66*point2;


% scatter plot of mesh vertices in 3D
scatter3(vertices(:,1),vertices(:,2),vertices(:,3),'Marker','.','MarkerFaceColor','b');
axis('image');
view([11 11]);
title('3D Scan of Upper Arm')
xlabel('X(mm)')
ylabel('Y(mm)')
zlabel('Z(mm)')

% plotting spheres in the place of elbow and shoulder joints

[x1,y1,z1] = sphere;
radius= 10;
x1 = x1*radius;
y1 = y1*radius;
z1 = z1*radius;
hold on

% % plot internal corner
% x2= point1(1);
% y2= point1(2);
% z2= point1(3);
% hSurface=surf(x1+x2,y1+y2,z1+z2);
% set(hSurface, 'FaceColor',[1 1 0], 'EdgeAlpha', 0);  
%          
% 
% % plot external corner 
% x2= point2(1);
% y2= point2(2);
% z2= point2(3);
% hSurface=surf(x1+x2,y1+y2,z1+z2);
% set(hSurface, 'FaceColor',[1 1 0], 'EdgeAlpha', 0);      




hSurface=surf(x1+elbow(1),y1+elbow(2),z1+elbow(3));
set(hSurface, 'FaceColor',[1 0 0], 'EdgeAlpha', 0); 


hSurface=surf(x1+shoulder(1),y1+shoulder(2),z1+shoulder(3));
set(hSurface, 'FaceColor',[1 0 0], 'EdgeAlpha', 0);

% plotting humerus
plot3( [shoulder(1),elbow(1)],[shoulder(2),elbow(2)],[shoulder(3),elbow(3)], 'Color','g','LineWidth',5);
% calculating humerus in cm
 humerus= 0.1*sqrt((shoulder(1)-elbow(1))^2+(shoulder(2)-elbow(2))^2+(shoulder(3)-elbow(3))^2)
 

% determine the biceps brachii
 x=vertices(:,1);
 y=vertices(:,2);
 z=vertices(:,3);
%  On the line joining the approximated shoulder and elbow joints, the 
%  biceps brachii is 1/2 away from the elbow
 biceps_br= 0.5*elbow+0.5*shoulder;
 % Cutting at the x of the identified point
 Xs= biceps_br(1);
 secVert=findXSection(mesh,Xs);
 % finding the max point of the section. That would be the max of the
 % biceps bulge
 [V,I]= max(secVert(:,3));
 biceps_br= [Xs,secVert(I,2),secVert(I,3)];

 % plotting a sphere in place of the biceps brachii approximation
 figure
 title('Biceps Brachii');
 patch(mesh,'FaceColor',[0,1,1]);
 axis([min(x)-30 max(x)+30 min(y)-30 max(y)+30  min(z)-30 max(z)+30 ])
 material dull
 view([1 25])
 hold on
 hSurface=surf(x1+biceps_br(1),y1+biceps_br(2),z1+biceps_br(3));
 set(hSurface, 'FaceColor',[1 0 0], 'EdgeAlpha', 0);
 
end