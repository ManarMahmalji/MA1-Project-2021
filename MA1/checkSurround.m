function [k1,j1, isInterp1, k2,j2,isInterp2]=checkSurround(k,j, gridmatrix)
% This fucnction is used to tell the fitSpline function  the squares that are 
% to be connected to a given square, so that a smooth conncetion can be 
% obtained.
% Input:
% -k: float 
% -j: float
% k and j are the coordiantes of a square in gridmatrix
% -grifmatrix: 16x5 matrix of floats
% Output:
% k1, j1, k2,j2 :float
% These are the coordiantes that the given square should 
% be vconntected to 
% isInterp1, isInterp2: bool
% These boolean varaibles indicate whether the return squares have been
% interpolated ( curve-fitted) or not


isInterp1=0;
isInterp2=0;

% first priority square are the one forming a cross centered at the given square
s1= 4*(k-1)+j+1;
s2= 4*(k-1)+j-1;
s3= 4*((k+1)-1)+j;
s4= 4*((k-1)-1)+j;
squares=[s1,s2,s3,s4];
indices=[k j+1;k j-1; k+1 j; k-1 j];
% filtering the squares that exceed matrix dimensions
filter= indices<5 & indices >0;
filter= filter(:,1)== filter(:,2);
indices=indices(find(filter),:);
squares= squares(find(filter));
% filtering the squares that are empty of points
filter= gridmatrix(squares',5)>3;
indices=indices(find(filter),:);
squares= squares(find(filter));
% filtering the squares that have highest number of points
if sum(filter)>2
    temp1= gridmatrix(squares',5);
    temp2=sort( temp1, 'descend' )
   ind1= find(temp1==temp2(1));
   ind2= find(temp1==temp2(2));
   indices=indices([ind1,ind2],:);
   squares= squares([ind1,ind2]);
end

% filter must always return two points
if size(squares,2)~=2
    % this means that there is only one point found
    % shifting to look in sqaures  which were not taken by first priority
    % filtering
    s1= 4*((k+1)-1)+j+1;
    s2= 4*((k+1)-1)+j-1;
    s3= 4*((k-1)-1)+j+1;
    s4= 4*((k-1)-1)+j-1;
    new_squares=[s1,s2,s3,s4];
    new_indices=[k+1 j+1;k+1 j-1; k-1 j+1; k-1 j-1];
    % filtering the squares that exceed matrix dimensions
    filter= new_indices<5 & new_indices >0;
    filter= filter(:,1)== filter(:,2);
    new_indices=new_indices(find(filter),:);
    new_squares= new_squares(find(filter));
    % filtering the squares that are empty of points
    filter= gridmatrix(new_squares',5)>3;
    new_indices=new_indices(find(filter),:);
    new_squares= new_squares(find(filter));
    indices= [indices; new_indices];
    squares= [squares, new_squares];
end
 % finally, only two squares should be returned
k1=indices(1,1);
j1=indices(1,2);
k2=indices(2,1);
j2=indices(2,2);



% knowning if there are squares that were already interpolated among the
% filtered squares
filter= gridmatrix(squares, 1)~=0;
if size(filter,1)~=2
   print(' Error in checkSurround!!!!!!');
end
if  filter(1)== 1
    isInterp1=1;
end
if  filter(2)== 1
    isInterp2= 1;
end


end