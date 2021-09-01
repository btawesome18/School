function [accelOut] = Accel(t,vLast, mass,gravity, rho, Cd, area)
% Summary of this function goes here
%   Detailed explanation goes here
%   Used F=Ma to solve for a 
%   D = CD*.5(p*(V^2))*A
%   F =ma = gm- (CD*.5(p*(V^2))*A)
%   a = g - ((CD*.5(p*(V^2))*A)/m)
accelOut = gravity - ((Cd*.5*(rho*area*(vLast^2)))/mass);
end

