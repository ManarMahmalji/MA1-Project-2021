% Université Libre de Bruxelles-Vrije Universiteit Brussel
% Brussels Faculty of Engineering - BRUFACE
% Electromechanical Engineering - Module Mechatronics and Construction
% -------------------------------------------------------------------------------------
% =====================================MA1 PROJECT=====================================
% *** Rapid Design of Sensorized Interfaces for Upper Arm Exoskeletons: Benchmarked on EMG Sensors ***
% Author: 
% Manar MAHMALJI,  manar.mahmalji@ulb.be
% Supervisors: 
% ing. Kevin LANGLOIS, kevin.langlois@vub.be
% Prof. dr. ir. Tom VERSTRATEN, Tom.Verstraten@vub.be
% Date:03-09-2021 , version (1) 
% -------------------------------------------------------------------------------------
% Abstract:
% Exoskeletons, with their many shapes and uses, have been a fertile ground for research
% since the dawn of the 21st century. One novel area of research is the development of a
% sensorized and customized interface within an exoskeleton for the sake of improving the
% assistance it provides as well as its wearability. Therefore, in the aim of facilitating
% the integration of sensors into upper arm exoskeletons, this study proposes a MATLAB
% algorithm that takes a 3D scan of a healthy arm and outputs, without markers, certain 
% upper arm measurements that makes the design process less time-consuming and sets an
% additional iteration in the effort of making the design process of an exoskeleton more
% data-driven.
%% find circumference and area of a body part
close all
clear all

meshName='arm8.stl';% could be a leg ( leg10.stl , for example)  
% or an arm stl( arm3.stl, for example) 

% prepareMesh makes sure there are no vertices with negative coordinates
mesh= prepareMesh(meshName);
vertices=mesh.vertices;
x=vertices(:,1);
% specify the offset form the rightmost side of the body part. Sectioning
% will occur at Xmax-offset
offset=30;
Xmax=max(x);
Xs=Xmax-offset;
% Find section points of the x-section at x=Xs
secVert=findXSection(mesh,Xs);
% Order the section points and obtain the resulting circumference and area
[circumf,area]= findCurve(secVert,vertices,offset);
circumf
area

% To use  cubic spline fitting method 
% It is worth noting that this method works for the majority of sections 
% but it could have some problems because its algorithm is complex to optimize 

% spline =fitSpline(secVert);
% plotSpline(spline, secVert);

%% Processing a stretched arm 
clear all
close all
meshName='arm3.stl'; % For proper results, choose only  arm1, arm3, arm6, arm7 or arm8
mesh= prepareMesh(meshName);
humerus=processStrArm(mesh);
humerus

 %% Plotting humerus lenghth vs body length
 % listed in the order of samples [1 , 3 , 6, 7, 8]
 figure
 % scatter plot
 body_length= [161  162  178 187 172 ]; 
 humerus_length= [258.969, 244.974, 266.75 281.024 262.513];
 plot(humerus_length, body_length,'ro', 'LineWidth',10);
 ylabel('Body Length (cm)');
 xlabel('Humerus Length (mm)');
 title('Body Length vs Humerus Length')
 hold on
 % plotting linear regression obtained from the tools tab of the scatter
 % plot figure
  p1 = 0.76071;
  p2 = -27.95;
  x= linspace(200,300);
  y = p1*x + p2 ;
  plot(x,y,'b','LineWidth',2);
  
 %% Processing a flexed arm 
close all
clear all 
meshName='flexed1.stl'; 
mesh= prepareMesh(meshName);
humerus=processFlxArm(mesh);
humerus