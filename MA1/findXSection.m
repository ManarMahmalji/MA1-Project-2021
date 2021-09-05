function secVert=findXSection(mesh,Xs)
% This function cuts a patch struct 'mesh' at certian x_coordiante 'Xs' with a plane
% parallel to YZ plane and outputs the resulting interesection vertices 'secVert' with mesh's
% faces 
% Input: 
% mesh : patch struct with fields: vertices,faces
% Xs : float 
% Output:
% secVert: nx3 matrix where n is the number of intersection vertices

vertices= mesh.vertices;
faces=mesh.faces;
secVert=zeros(1000,3);
Nf= size(faces,1);
counter=1;

 for j=1:Nf
     % loop through each face and compute the relative distacne between
     % each face's vertex and the cutting plane 
    
     ind1= faces(j,1);
     ind2= faces(j,2);
     ind3= faces(j,3);
     pt1= vertices(ind1,:);
     pt2= vertices(ind2,:);
     pt3= vertices(ind3,:);
     pts=[pt1;pt2;pt3];
     
     d1= Xs- pt1(1);
     d2= Xs- pt2(1);
     d3= Xs- pt3(1);
     d=[d1 d2 d3];
%      filtering criteria:
%      * for faster execution and for not choosing all the faces, choose only 
%        the face whose vertices are within 10 cm from the cutting plane
%      * Choose only the faces whose vertices have differnet signs of distnces  
%      * don't choose the face that has whose relative distances are all negative
%      * don't choose the face that has whose relative distances are all postivive
   
     filter= abs(d)>10;

     if sum(filter)<3 && sum(sign(d))~=3 && sum(sign(d))~=-3 
        % there is intersection hence find the negative distance vertices 
        % and the positive distnace vertices
        negpts= find(sign(d)==-1);
        pospts= find(sign(d)==1);
   
        % An edge is formed between each two vertices with differnent signs
        % this edge intersects the plane. Loop through each edge
        for m=1:size(negpts,2)
            for n=1:size(pospts,2)
            % find the intersection using a scaling factor     
            t= (0-d(negpts(m)))/(d(pospts(n))- d(negpts(m)));
            secVert(counter,:) = pts(negpts(m),:) + t*(pts(pospts(n),:) - pts(negpts(m),:));
            counter=counter+1;

            end
        end

     end

 end
 secVert= unique( secVert,'rows');
 Yseg= nonzeros(secVert(:,2));
 Zseg= nonzeros(secVert(:,3));
 Xseg= nonzeros(secVert(:,1));
 secVert= [Xseg Yseg Zseg];

 
 
%     To plot a section plane on the assigned Xs
%     figure
%     scatter3(vertices(:,1),vertices(:,2),vertices(:,3),'Marker','.','MarkerFaceColor','b');
%     axis image
%     view([22 23]);
%     title(['3D Scan of Upper Arm, Section at x= ',num2str(Xs),' mm'])
%     xlabel('X(mm)')
%     ylabel('Y(mm)')
%     zlabel('Z(mm)')
%     hold on
%     scatter3(Xseg,Yseg,Zseg,'Marker','x','MarkerFaceColor','r', 'lineWidth',2);% scatter diagram of segment
%     Yminsec=min(secVert(:,2))-20;
%     Ymaxsec=max(secVert(:,2))+20;
%     Zminsec=min(secVert(:,3))-20;
%     Zmaxsec=max(secVert(:,3))+20;
%     patch([Xs, Xs,Xs, Xs],[Yminsec, Yminsec, Ymaxsec, Ymaxsec],[Zminsec,Zmaxsec,Zmaxsec,Zminsec],[1,0,0])
%     figure
%     scatter(secVert(:,2),secVert(:,3),'Marker','.');
%     axis image
%      title(['3D Scan of Upper Arm, Section at x= ',num2str(Xs),' mm'])
%     xlabel('Y(mm)')
%     ylabel('Z(mm)')
%     hold on

end