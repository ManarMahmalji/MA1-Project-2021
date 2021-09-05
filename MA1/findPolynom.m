function [polynom,scale]= findPolynom(pt1, pt2,P,key)
% This function returns a polynomial that passes through the two
% boundary points pt1 and pt2 and has the same derivative as the polyfit
% function polynomial would have at these points.



    der=polyder(P);
    der1=polyval(der,pt1(1));
    der2=polyval(der,pt2(1));
    x1=pt1(1);
    y1=pt1(2);
    x2=pt2(1);
    y2=pt2(2);
   
        if key==3 % 3rd degree polynomial
        b=[y1 ; y2 ; der1; der2];% Boundary conditions 
        A=[x1^3, x1^2, x1, 1; x2^3, x2^2, x2, 1; 3*x1^2, 2*x1, 1, 0; 3*x2^2, 2*x2, 1, 0 ];
        P= A\b;
        end
        if key==2 % 2nd degree polynomial
         b=[y1 ; y2 ; der1];% Boundary conditions 
         A=[x1^2 x1 1;x2^2 x2 1; 2*x1 1 0];
         P= A\b;
        end
         if key==1% 1st degree polynomial
         b=[y1 ; y2];% Boundary conditions
         A=[x1 1;x2 1];
         P= A\b;
         end
   
    scale=linspace(x1,x2);
    polynom=P';
end
