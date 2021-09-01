function [aoa,Cd,CL] = convert2dFoilTo3dWing(aoa,Cd,Cl,AR,e,n1,n2)
%Take a airfoil and extimate a 3d wing

 %Finding a0:
 slope = polyfit(aoa(n1:n2), Cl(n1:n2),1);
 m = slope(1);
 %will assume the average of the polyfit line will be a0. To make it more
 %specific get the values of two points and get the slope that way later.
 a0 = m; %(a0 is basically the slope of the polyfit that we found.)
 
 %Get a1 (3D Lift curve slope)
 a1 = a0 / (1 + ((57.3*a0)/(pi*e*AR)));
 %Find Cl = 0;
 [~,indexL0] = min(Cl.^2);
 
 CL = a1*(aoa(:)-aoa(indexL0)); %Iterated through all of the AoAs in the dataset.  

 
 
end

