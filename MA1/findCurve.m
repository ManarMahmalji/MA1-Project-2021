function [circumf,area]=findCurve(secVert,vertices,offset)
% This function finds a curve of a set of unordered vertices 'secVert' by ordering them and 
% returning the circumfernce and area of the resulting polygon. It also plots the vertices in 3D.
% 
% Input:
% secVert: nx3 matrix , unordered vertices
% vertices: mxn matrix, global set of vertices
% offset: float , the offset at which the secVert was chosen with respect to vertices
% Output:
% circumf: float
% area: float

Xsec=secVert(:,1);
Ysec=secVert(:,2);
Zsec=secVert(:,3);

% Ordering secVert

% sort wrt z direction
secVert=[Xsec,Ysec,Zsec];
[temp,I]=sort(Zsec,'descend');
secVert= secVert(I,:);
startpt= secVert(1,:);
temp=zeros(500,3);


counter=1;
temp(1,:)= startpt; % first point in ordered vertices
thr=4; % threshold in mm
tol=1e-3; % tolerance in mm
% /!\ threshold value has to do with the mesh density of the scans
% A trial and error approach was used to set it. It was observed that 
% changing the could induce some errors, so it is good to investigate its
% value when an error is encounterd

   while 1
       
       record=counter; % record the counter at the beginning
     
%        Note that the currnet point over which the frame of refernce is construced is
%        the point with index = counter in matrix temp. This point will be donoted
%        as the instantaneous orign. For each quadrant
%        direction, only the points that are less than a certain threshold
%        are taken. This thresold is used for faster exectuion so that not
%        all points in a certain quadrant are taken
       
      % 4th quadrant direction
      
      % 4th quadrant conditons
      filter= Ysec-temp(counter,2)<thr & Ysec-temp(counter,2)>0  & temp(counter,3)-Zsec<thr & temp(counter,3)-Zsec>0;
      % filter2 is for the points that are almost on the same horizontal or vertical
      % axes as the instantaneous origin. This is helpful when the points
      % form a horizontal or vertical ine due to a plane cut.
      filter2= abs(temp(counter,3)-Zsec)<tol | abs(temp(counter,2)-Ysec)<tol;
      filter= filter | filter2;
      % Do not enter if there are no points resulting from filtering
      while sum(filter)~=0 
     % Extract the filterd poitns out of secVert
      points= [nonzeros( filter.*Xsec) , nonzeros( filter.*Ysec), nonzeros( filter.*Zsec)];
     % check if there are any poitns aleardy taken
       filter= ismembertol(temp,points,'ByRows',true);
       repetition=[nonzeros(filter.*temp(:,1)),nonzeros(filter.*temp(:,2)),nonzeros(filter.*temp(:,3))];
%        remove the points that are repeated meaning they are already taken
       if ~isempty(repetition)
           % filtering 
           filter= ~ismembertol(points,repetition,'ByRows',true);
           % Extraction 
           points= [nonzeros(filter.*points(:,1)),nonzeros(filter.*points(:,2)),nonzeros(filter.*points(:,3))];
          % if after removing repetitions, no points remain, get out of the
          % loop and go for the second while loop
           if isempty(points)
               break
           end
       end
       % calculationg distance to instananeous origin and  
      diff= [abs(points(:,2)-temp(counter,2)), abs(points(:,3)-temp(counter,3))];
      dist= sqrt(diff(:,1)+diff(:,2));
      % extracting the point with the minimum ditance and adding it to
      % temp. This point becomes the new instantaneous origin
      [val,I]= min(dist);
      temp(counter+1,:)= points(I,:);
      counter=counter+1;
      % Repeating the same filtering procedure for the new instantaous
      % origin
      filter= Ysec-temp(counter,2)<thr & Ysec-temp(counter,2)>0  & temp(counter,3)-Zsec<thr & temp(counter,3)-Zsec>0; 
      filter2= abs(temp(counter,3)-Zsec)<tol | abs(temp(counter,2)-Ysec)<tol;
      filter= filter | filter2;
      end
      
     % For the other quadrants, the same procedures apply
      
      % 3rd quadrant direction
      filter= temp(counter,2)-Ysec<thr & temp(counter,2)-Ysec>0  & temp(counter,3)-Zsec<thr & temp(counter,3)-Zsec>0; 
      filter2= abs(temp(counter,3)-Zsec)<tol | abs(temp(counter,2)-Ysec)<tol;
      filter= filter | filter2;
      while sum(filter)~=0 
      points= [nonzeros( filter.*Xsec) , nonzeros( filter.*Ysec), nonzeros( filter.*Zsec)];
      filter= ismembertol(temp,points,'ByRows',true);
       repetition=[nonzeros(filter.*temp(:,1)),nonzeros(filter.*temp(:,2)),nonzeros(filter.*temp(:,3))];
       if ~isempty(repetition)
           filter= ~ismembertol(points,repetition,'ByRows',true);
           points= [nonzeros(filter.*points(:,1)),nonzeros(filter.*points(:,2)),nonzeros(filter.*points(:,3))];
           if isempty(points)
               break
           end
       end
      diff= [abs(points(:,2)-temp(counter,2)), abs(points(:,3)-temp(counter,3))];
      dist= sqrt(diff(:,1)+diff(:,2));
      [val,I]= min(dist);
      temp(counter+1,:)= points(I,:);
      counter=counter+1;
      filter=  temp(counter,2)-Ysec<thr & temp(counter,2)-Ysec>0  & temp(counter,3)-Zsec<thr & temp(counter,3)-Zsec>0; 
      filter2= abs(temp(counter,3)-Zsec)<tol | abs(temp(counter,2)-Ysec)<tol;
      filter= filter | filter2;
      end

        % 2nd quadrant direction
      filter= temp(counter,2)-Ysec<thr & temp(counter,2)-Ysec>0  & Zsec-temp(counter,3)<thr & Zsec-temp(counter,3)>0; 
      filter2= abs(temp(counter,3)-Zsec)<tol | abs(temp(counter,2)-Ysec)<tol;
      filter= filter | filter2;
      while sum(filter)~=0 
   
 
      points= [nonzeros( filter.*Xsec) , nonzeros( filter.*Ysec), nonzeros( filter.*Zsec)];
     
       filter= ismembertol(temp,points,'ByRows',true);
       repetition=[nonzeros(filter.*temp(:,1)),nonzeros(filter.*temp(:,2)),nonzeros(filter.*temp(:,3))];
       if ~isempty(repetition)
           filter= ~ismembertol(points,repetition,'ByRows',true);
           points= [nonzeros(filter.*points(:,1)),nonzeros(filter.*points(:,2)),nonzeros(filter.*points(:,3))];
           if isempty(points)
               break
           end
       end
      diff= [abs(points(:,2)-temp(counter,2)), abs(points(:,3)-temp(counter,3))];
      dist= sqrt(diff(:,1)+diff(:,2));
      [val,I]= min(dist);
      temp(counter+1,:)= points(I,:);
      counter=counter+1;
      filter=  temp(counter,2)-Ysec<thr & temp(counter,2)-Ysec>0  & Zsec-temp(counter,3)<thr & Zsec-temp(counter,3)>0;
      filter2= abs(temp(counter,3)-Zsec)<tol | abs(temp(counter,2)-Ysec)<tol;
      filter= filter | filter2;
      end
      
      
         % 1st quadrant direction
      filter= Ysec-temp(counter,2)<thr & Ysec-temp(counter,2)>0  & Zsec-temp(counter,3)<thr & Zsec-temp(counter,3)>0; 
      filter2= abs(temp(counter,3)-Zsec)<tol | abs(temp(counter,2)-Ysec)<tol;
      filter= filter | filter2;
      while sum(filter)~=0 
       
      points= [nonzeros( filter.*Xsec) , nonzeros( filter.*Ysec), nonzeros( filter.*Zsec)];
    
       filter= ismembertol(temp,points,'ByRows',true);
       repetition=[nonzeros(filter.*temp(:,1)),nonzeros(filter.*temp(:,2)),nonzeros(filter.*temp(:,3))];
       if ~isempty(repetition)
           filter= ~ismembertol(points,repetition,'ByRows',true);
           points= [nonzeros(filter.*points(:,1)),nonzeros(filter.*points(:,2)),nonzeros(filter.*points(:,3))];
           if isempty(points)
               break
           end
       end
      diff= [abs(points(:,2)-temp(counter,2)), abs(points(:,3)-temp(counter,3))];
      dist= sqrt(diff(:,1)+diff(:,2));
      [val,I]= min(dist);
      temp(counter+1,:)= points(I,:);
      counter=counter+1;
      filter=  Ysec-temp(counter,2)<thr & Ysec-temp(counter,2)>0  & Zsec-temp(counter,3)<thr & Zsec-temp(counter,3)>0;
      filter2= abs(temp(counter,3)-Zsec)<tol | abs(temp(counter,2)-Ysec)<tol;
      filter= filter | filter2;
      end
      
     
      % if the algorithm passed all quadrants and counter was not changed
      % , meaning that no vertices were appended, then ordering is done
      if counter-record==0 
          break
      end
   end
  


secVert=[nonzeros(temp(:,1)),nonzeros(temp(:,2)),nonzeros(temp(:,3))];
% appending the last point so that the curve finally becomes closed 
secVert=[secVert;secVert(1,:)];
% area of the polygon formed by ordered vertices
area=polyarea(secVert(:,2),secVert(:,3));
% Getting circumfernce by adding the length of the edges formed by
% each two successive vertices
circumf=0;
 for j=1:size(secVert,1)-1

     y1= secVert(j,2);
     z1= secVert(j,3);
     y2= secVert(j+1,2);
     z2= secVert(j+1,3);
     dist= sqrt((y1-y2)^2 +(z1-z2)^2);
     circumf= circumf+  dist; 
 end
 
 
 
 % plotting section vertices wrt vertices in 3D
    figure
    scatter3(vertices(:,1),vertices(:,2),vertices(:,3),'Marker','.','MarkerFaceColor','b');
    axis image
    view([22 23]);
    title(['3D Scan of Upper Arm, Section at offset= ',num2str(offset),' mm'])
    xlabel('X(mm)')
    ylabel('Y(mm)')
    zlabel('Z(mm)')
    hold on
    scatter3(Xsec,Ysec,Zsec,'Marker','x','MarkerFaceColor','r', 'lineWidth',2);% scatter diagram of segment
  
  % plotting secVert in 2D
     figure
     plot(secVert(:,2),secVert(:,3),'r');
     string= [' Area= ',num2str(area),' mm^2',', Circumfernce= ',num2str(circumf),' mm'];
     title(string); 
     xlabel('Y(mm)')
     ylabel('Z(mm)')
     
  % plotting the polygon formed by orderdd vertices   
     hold on
     pgon = polyshape(secVert(:,2),secVert(:,3));
     plot(pgon)
end