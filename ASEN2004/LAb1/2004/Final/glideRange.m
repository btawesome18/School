function [range,vRangeMax,endurance,cl] = glideRange(CDvec,weight,sRef,rho,hight,e0,AR)
%Find max range, and velocity for max range
%   Detailed explanation goes here

%Using SUF assumptions and small angle assumption



CD_min = min(CDvec);

k = 1/(pi*e0*AR);

CL = sqrt(CD_min/k);

CD = (CD_min+ k*(CL).^2);

LDmax = CL/CD;

range = hight*(LDmax);

%set L=W and solve for v given CL(i)
%W=CL*A*(p*V^2)/2
vRangeMax = sqrt(((2*weight)/(CL*sRef*rho)));

glideangle = atan(1/(LDmax));

sinkRate = vRangeMax*sin(glideangle);

endurance = hight/sinkRate;

cl = CL;

end

