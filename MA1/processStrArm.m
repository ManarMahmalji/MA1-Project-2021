function humerus =processStrArm(mesh)
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
z=vertices(:,3);


% Get shoulder point

% Finding the vertex with max z-coordiante
[Zmax,I]=max(z);
Xs= x(I);
% Cutting with an x-section at this vertex 
secVert=findXSection(mesh,Xs);
% Shouler joint is approximated to be the center of gravity of the section
shoulder= [Xs,mean(secVert(:,2)),mean(secVert(:,3))];

% Get elbow point

% cutting at Xmax could possibly not give homogenous section points.
Xs= max(x)-1;
secVert=findXSection(mesh,Xs);
% Elbow joint is the center of gravity of the x-section
elbow= [Xs,mean(secVert(:,2)),mean(secVert(:,3))];

% plotting mesh vertices in 3D 
figure
scatter3(vertices(:,1),vertices(:,2),vertices(:,3),'Marker','.','MarkerFaceColor','b');
axis('image');
view([0 0]);
title('3D Scan of Upper Arm')
xlabel('X(mm)')
ylabel('Y(mm)')
zlabel('Z(mm)')
hold on

% plotting spheres in the place of the elbow and shoulder joints
[x1,y1,z1] = sphere;
radius= 10;
x1 = x1*radius;
y1 = y1*radius;
z1 = z1*radius;
hold on

hSurface=surf(x1+shoulder(1),y1+shoulder(2),z1+shoulder(3));
set(hSurface, 'FaceColor',[1 1 0], 'EdgeAlpha', 0);

 hSurface=surf(x1+elbow(1),y1+elbow(2),z1+elbow(3));
set(hSurface, 'FaceColor',[1 1 0], 'EdgeAlpha', 0);

% plotting humerus
plot3( [shoulder(1),elbow(1)],[shoulder(2),elbow(2)],[shoulder(3),elbow(3)], 'Color','r','LineWidth',5);
% calulating humerus in cm
humerus= 0.1*sqrt((shoulder(1)-elbow(1))^2+(shoulder(2)-elbow(2))^2+(shoulder(3)-elbow(3))^2);


% determine the biceps brachii

% It was not used because there was no consistent way to find them for
% stretched arms unlike flexed arm where the biceps bulge is always
% pointing upwards

% biceps_br= 0.6*elbow+0.4*shoulder;
% Xs= biceps_br(1);
% secVert=findXSection(mesh,Xs);
% [V,I]= max(secVert(:,2));
% biceps_br= [Xs,secVert(I,2),secVert(I,3)];
% figure
% patch(mesh,'FaceColor',[0,1,1]);
% axis([min(x)-100 max(x)+100 min(y)-100 max(y)+100  min(z)-100 max(z)+100 ])
% material dull
% view([0 80])
% hold on
% hSurface=surf(x1+biceps_br(1),y1+biceps_br(2),z1+biceps_br(3));
% set(hSurface, 'FaceColor',[1 0 0], 'EdgeAlpha', 0)
end