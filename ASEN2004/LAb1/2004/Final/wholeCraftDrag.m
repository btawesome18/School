function [CL,WholeAircraftDrag] = wholeCraftDrag(Cd,CL,AR,e,e0,sWet,sRef,Cfe,n1,n2,n3,aoa)
%Takes 2d wing drag, 3d lift, aspect ratio, span effiency, oswalds, Wet
%area, and planform area, and skin friction coeffcent
%   Detailed explanation goes here

CD_wing = Cd + (CL.^2)/(pi*e*AR);

CD_min = Cfe*(sWet/sRef);

[~,i] = min(CD_wing);

CL_minD = CL(i);

k1 = 1/(pi*e0*AR);

slope = polyfit(aoa(n1:n2), CL(n1:n2),1);
m = slope(1);

aoa = -8:n3:8;

CL = m*(aoa(:));

WholeAircraftDrag = (CD_min+ k1*(CL - CL_minD).^2); 

end

