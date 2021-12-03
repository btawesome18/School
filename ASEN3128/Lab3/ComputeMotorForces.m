function motor_forces = ComputeMotorForces(Zc, Lc, Mc, Nc, R, km)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
A = R/sqrt(2);
motor_forces = ([-1,-1,-1,-1;-A,-A,A,A;A,-A,-A,A;km,-km,km,-km]^-1)*[Zc;Lc;Mc;Nc];
end

