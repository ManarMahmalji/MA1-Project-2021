function spline=fitSpline(secVert)
% This function fits a cubic spline into a set of random points. The function 
% divides the smallest square containing all points into square regions and
% fits a cubic polynomial into each region. The final curve is piecewisely 
% continuous

% Input
% secVert: nx3 matrix, where n is the number of section points
% Output 
% spline: struct with 3 fields:
% * circumf: float ,spline circumfernece
% * dataSet1:16xm float matrix
% * dataSet2:16xm float matrix
% dataSet1 and dataSet2 are used to plot the spline

Ysec=secVert(:,2);
Zsec=secVert(:,3);

% Dividing the smallest square around the section points into 16 squares 
% where the points inside each square will be fitted to a cubic polynomial
% and the final curve will be peiecwisely continuous
Yscale=linspace(min(Ysec), max(Ysec),5);
Zscale=linspace(min(Zsec), max(Zsec),5);
Ny= size(Yscale,2);
Nz= size(Zscale,2);

%Creating a counter for storing the fitting curves for each square in the grid
counter=1;
% gridmatrix will be used to help the polynomials of each square
% connect to each other at the joints of the spline
gridmatrix=zeros(16,5);
% Intitializing cirumference
circumf=0;
% fitting a cubic spline for the points inside each square region
    
for k=1:Ny-1
    for j=1:Nz-1
        % loop through each square and find the number of points it
        % contains and store it to gridmatrix
        filter= Ysec>= Yscale(k) & Ysec<= Yscale(k+1) & Zsec>= Zscale(j) & Zsec<= Zscale(j+1);
        gridmatrix(counter,5)= sum(filter);
        counter=counter+1;
    end
end
counter=1;
for k=1:Ny-1
    for j=1:Nz-1
        
        polynom_length=0;
        % Extract the points a square region
        filter= Ysec>= Yscale(k) & Ysec<= Yscale(k+1) & Zsec>= Zscale(j) & Zsec<= Zscale(j+1);
        Ysec_grid= nonzeros(filter.*Ysec);
        Zsec_grid= nonzeros(filter.*Zsec);
        key=3;
        % key refers to the degree of fitted polynomial. It could sometimes be 2 if the 
        % the number of points is low
        if ~isempty(Ysec_grid) && size(Ysec_grid,1)>=3 

            % checkSurround takes a certain square and returns the two
            % squares to be connected to the current squares.  gridmatrix
            % records for each square the coordiantes of the two points
            % where the fitted curve ends and starts. These points are used
            % as boundary conditions when fitting a polynomial for the
            % adjacent squares
            [k1,j1,isInterp1,k2,j2,isInterp2]=checkSurround(k,j,gridmatrix);
            index1= 4*(k1-1)+j1;
            index2= 4*(k2-1)+j2;
            indices= [index1, index2];
            isInterp=[isInterp1, isInterp2];
            js=[j1,j2];
            ks=[k1,k2];
            pts=zeros(2,2);
            
            % At j==2 or j==3 , the points from a bell shape that is hard
            % to capture with normal fitting: abscissa=y and
            % ordiante=z. To solve this issue, the fitting is inverted 
            % meaning abscissa=z and orindate = y
            if j==2 || j==3
            P=polyfit(Zsec_grid,Ysec_grid,3);    
            else
            P=polyfit(Ysec_grid,Zsec_grid,3);
            end
            
            for r=1:2
                %two iteration because two adjacent squares.
                %The aim of this loop is to be able to get out with two
                % points that will be used as boundary conditions for the 
                % cubic polynomial fitting
                
                % dealing with square in case it is interpolated and it has
                % one edge adjacent to square of interst
                if isInterp(r)== 1 && (ks(r)== k || js(r)==j)
                    % Since it is already interpolated two points of the 
                    % assigned square are extracted from grid matrix
                    tempt1= gridmatrix(indices(r), 1:2);
                    tempt2= gridmatrix(indices(r), 3:4);
                    
                    % Among the two points, only one should be chosen to be
                    % connected to our square of interest
                    if js(r)==j
                       filter= [tempt1(1) tempt2(1)] == Yscale(k);
                    elseif ks(r)==k
                       filter= [tempt1(2) tempt2(2)] == Zscale(j);
                    end
       
                    index= find(filter);
                   switch index
                       case 1
                           pts(r,:)=tempt1;
                       case 2
                           pts(r,:)=tempt2;
                   end
                   
                   if j==2 || j==3
                       pts(r,:)= flip(pts(r,:));
                   end
                   % dealing with square in case it is not interpolated and
                   % it has one edge adjacent to square of interest
                elseif isInterp(r)==0 && (ks(r)== k || js(r)==j)
                   % In this case, polyfit function is used to fit a cubic 
                   % polynomial inside our square of interest. Then, the
                   % point of intersection with the adjacent square given
                   % in this loop is recorded and taken as the boundary
                   % point of this square
                   if j==1 || j==4
                       if js(r)==j
                           pts(r,:)= [Yscale(k+1), polyval(P, Yscale(k+1))];
                       elseif ks(r)==k
                           inter=roots([P(1) P(2) P(3) P(4)-Zscale(j+1)]);
                           filter= inter<Yscale(k+1) & inter>Yscale(k);
                           if sum(filter)==1
                           pts(r,:)=[nonzeros(filter.*inter), Zscale(j+1)];
                           else
                           % find closest point to Zscale(j+1)
                           [ dis,ind]= min(Zscale(j+1)- Zsec_grid);
                           pts(r,:)=[Ysec_grid(ind), Zscale(j+1)];
                           end    
                           
                       end
                   elseif j==2 || j==3
                       if ks(r)==k
                           pts(r,:)= [Zscale(j+1), polyval(P, Zscale(j+1))];
                       elseif js(r)==j
                           inter=roots([P(1) P(2) P(3) P(4)-Yscale(k+1)]);
                           filter= inter<Zscale(j+1) & inter>Zscale(j);
                           %pts(r,:)=[nonzeros(filter.*inter), Yscale(k+1)];
                           if sum(filter)==1
                           pts(r,:)=[nonzeros(filter.*inter), Yscale(k+1)];
                           else
                           % find closest point to Yscale(k+1)
                           [ dis,ind]= min(Yscale(k+1)- Ysec_grid);
                           pts(r,:)=[Zsec_grid(ind),Yscale(k+1),];
                           end
                       end
                   end
                   % in case the square doesn't have a common edege with
                   % square of interest, rather just one point, record this
                   % point as the boundary point
                elseif ks(r)~= k && js(r)~=j
                  if ks(r)>k && js(r)>j
                    pts(r,:)=[Yscale(k+1), Zscale(j+1)];  
                  elseif ks(r)<k && js(r)>j
                    pts(r,:)=[Yscale(k), Zscale(j+1)]; 
                  elseif ks(r)<k && js(r)<j
                    pts(r,:)=[Yscale(k), Zscale(j)];   
                  elseif ks(r)>k && js(r)<j
                    pts(r,:)=[Yscale(k+1), Zscale(j)];   
                  end
                  
                  if j==2 || j==3 
                      pts(r,:) =flip(pts(r,:));
                  end
                  
                end
            end
            pt1=pts(1,:);
            pt2=pts(2,:);
            
            % if number of points less than 10 , go to parabola fitting
            if gridmatrix(4*(k-1)+j,5)<10
                key=2;
            end
            % findPolynom returns a cubic polynomial that passes through the two
            % boundary points( 2 condtions) and has the same derivative as the polyfit
            % function polynomil would have at these points( 2 conditions)
            [P,scale]=findPolynom(pt1,pt2,P,key);
            polynom=polyval(P,scale);
            
            % recording data of each square to be plotted
            if j==2 || j==3
                gridmatrix(counter,1:4)= [flip(pt1), flip(pt2)];
                spline.dataSet1(counter,:)= polynom;
                spline.dataSet2(counter,:)= scale;
                % determining arclength of polynomial 
                D=polyder(P);
                firstder=polyval(D, scale);
                polynom_length=abs(trapz(scale,sqrt(1+firstder.^2)));
            else
                gridmatrix(counter,1:4)= [pt1, pt2];
                spline.dataSet1(counter,:)= scale;
                spline.dataSet2(counter,:)= polynom;
                % determining arclength of polynomial
                D=polyder(P);
                firstder=polyval(D, scale);
                polynom_length=abs(trapz(scale,sqrt(1+firstder.^2)));
            end   
                   
        end
        % cirumfernce is summation of arclength 
        circumf=circumf+polynom_length;
        counter=counter+1;
    end
end

 spline.circumf= circumf;
 
end

