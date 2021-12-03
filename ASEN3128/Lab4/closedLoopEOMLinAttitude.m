function dsdt = closedLoopEOMLinAttitude(t,state,constants,target,k)

    R = constants(2);
    km = constants(3);
    Zc = -constants(1)*constants(13);

    conM = controlLawLinPitch(state,target,k);
    motor_forces = ComputeMotorForces(Zc, conM(1), conM(2), conM(3), R, km);
    
    constants(9:12) = motor_forces;
    dsdt = EOMLinearized(t,state,constants);
    
end