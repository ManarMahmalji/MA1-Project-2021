function secVert=findZSection(mesh,Zs)
% This function cuts a patch struct 'mesh' at certian z_coordiante 'Zs' with a plane
% parallel to XY plane and outputs the resulting interesection vertices 'secVert' with mesh's
% faces 
% Input: 
% mesh : patch struct with fields: vertices,faces
% Zs : float 
% Output:
% secVert: nx3 matrix where n is the number of intersection vertices

% The same algorithm is used as in findXSextion
vertices= mesh.vertices;
faces=mesh.faces;
secVert=zeros(1000,3);


Nf= size(faces,1);

 c=1;
 for j=1:Nf
     ind1= faces(j,1);
     ind2= faces(j,2);
     ind3= faces(j,3);
     pt1= vertices(ind1,:);
     pt2= vertices(ind2,:);
     pt3= vertices(ind3,:);
     pts=[pt1;pt2;pt3];

     d1= Zs- pt1(3);
     d2= Zs- pt2(3);
     d3= Zs- pt3(3);
     d=[d1 d2 d3];
     filter= abs(d)>10;

     if sum(filter)<3 && sum(sign(d))~=3 && sum(sign(d))~=-3 
        % there is intersection
        % there exist 2 cases: 
        % first case: one positive pt and 2 negative pts
        negpts= find(sign(d)==-1);
        pospts= find(sign(d)==1);
   

        for m=1:size(negpts,2)
            for n=1:size(pospts,2)
            t= (0-d(negpts(m)))/(d(pospts(n))- d(negpts(m)));
            secVert(c,:) = pts(negpts(m),:) + t*(pts(pospts(n),:) - pts(negpts(m),:));
            c=c+1;

            end
        end

     end

 end
 secVert= unique( secVert,'rows');
 Yseg= nonzeros(secVert(:,2));
 Zseg= nonzeros(secVert(:,3));
 Xseg= nonzeros(secVert(:,1));
 secVert= [Xseg Yseg Zseg];



end