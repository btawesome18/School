function [out] = RocketFlight(state,initalCon)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    % State = [posx,y,z,volx,y,z]
    
    vAbs = [state(4),state(5),state(6)];
    
    g = initalCon.g;
    mass = initalCon.mass;
    rho = initalCon.rho;
    Cd = initalCon.cd;
    Area = pi*(initalCon.bottleDie/2)^2;

    %% Force Drag
    
    vRel = vAbs - initalCon.wind;
    
    vRelMag = sqrt((vRel(1)^2)+(vRel(2)^2)+(vRel(3)^2));
    
    heading = vRel./vRelMag;
    
    Drag = -(1/2)*rho*(vRelMag^2)*Cd*Area;
    
    forceDrag = heading*Drag;
    
    %% Force Grav
    
    forceG = [0,0,(g*mass)];
    
    %% End Condisions
    
    force = forceG + forceDrag;
    
    a = force./mass;
    
    out = [vAbs,a]';
end

