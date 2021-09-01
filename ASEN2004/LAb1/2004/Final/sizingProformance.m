function [outputArg1] = sizingProformance(wingspan,Foil,AR,e,e0,Cfe,rho,hight,massCam,rhoFoam)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

b = wingspan;
c = 2*b/AR;

sWet = (3.28*b*c)+(4*b*sqrt((0.0324*(c^2))+(9)))+(1.2*b)+(134.92*c)+(72*sqrt((c^2)-(144*c)+7888))+31650; %mm^2
sWet = sWet/1000000; %mm^2 to m^2

sRef = (b*c*2)/1000000; %m^2

sMass = ((22520+72*((sqrt(((c-72)^2)+2704))+c))+(2*b*c))/1000000;%m^2 About how much foam we will need, so only counting the top of the wing type deal.
massDry = (sMass*rhoFoam)+0.00377; %The 2 dowels should add about 3.77 grams
mass = massDry + massCam; %kg



[~,~,CL] = convert2dFoilTo3dWing(Foil(:,1),Foil(:,3),Foil(:,2),AR,e,1,9);

[CL,WholeAircraftDrag] = wholeCraftDrag(Foil(:,3),CL,AR,e,e0,sWet,sRef,Cfe,1,9,0.01,Foil(:,1));

weight = mass * 9.81;

[range,vRangeMax,rangeEndurance,cl] = glideRange(WholeAircraftDrag,weight,sRef,rho,hight,e0,AR);

[vEndurance,clEndure,endureTime] = glideEndurance(CL,WholeAircraftDrag,weight,rho,sRef,e0,AR,hight);

%% Stall V
CLmax = max(CL);
vStall = sqrt((2*weight)/(CLmax*rho*sRef));

%% Outputs
outputArg1.endurance = vEndurance;
outputArg1.CLendurance = clEndure;
outputArg1.enduranceTime = endureTime;
outputArg1.range = range;
outputArg1.vRangeMax = vRangeMax;
outputArg1.rangeTime = rangeEndurance;
outputArg1.CLrange = cl;
outputArg1.weight = weight;
outputArg1.winglength = b;
outputArg1.sref = sRef;
outputArg1.massDry = massDry;
outputArg1.vStall = vStall;

end

