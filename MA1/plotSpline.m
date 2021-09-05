function plotSpline(segment,secVert)
% This function plots the spline fitted into a square grid containing all 
% secVert


Xsec= secVert(:,1);
Ysec= secVert(:,2);
Zsec= secVert(:,3);
% define gridlines
Yscale= linspace(min(Ysec),max(Ysec),5);
Zscale= linspace(min(Zsec),max(Zsec),5);
figure 
hold on
xlabel('Y(mm)');
ylabel('Z(mm)');
title('Spline Fitting Sample')
% draw gridlines
    for j=1:5
        plot(linspace(min(Ysec),max(Ysec)), Zscale(j)*ones(1,100),'-');
    end
    for j=1:5
        plot( Yscale(j)*ones(1,100),linspace(min(Zsec),max(Zsec)),'-');
    end
% draw polynomials in each square
    for j=1:16
        plot(segment.dataSet1(j,:),segment.dataSet2(j,:),'r');
    end
    scatter(Ysec,Zsec,'Marker','.');
    axis([min(Ysec)-5 max(Ysec)+5 min(Zsec)-5 max(Zsec)+5]);
end