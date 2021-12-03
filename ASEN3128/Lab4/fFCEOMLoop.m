function dsdt = fFCEOMLoop(t,state,constants,target1,k,switchTime,target2)

    %Checks time for changing command at a set time.
    if(t<switchTime)
        
       target = target1;
        
    else
        
        target = target2;
        
    end

% target = target1;

    %Unroll constants for readability
    R = constants(2);
    km = constants(3);
    Zc = -constants(1)*constants(13);
    
    conM = feedForwardControl(state,target,k);
    motor_forces = ComputeMotorForces(Zc, conM(1), conM(2), conM(3), R, km);
    
    constants(9:12) = motor_forces;
    %dsdt = EOMQuad(t,state,constants);
    I_B = [constants(4),0,0;0,constants(5),0;0,0,constants(6)];
    dsdt = LinEOM(t,state,motor_forces,R,km,constants(7),constants(8),constants(1),I_B,constants(13));
%LinEOM(t,state,f_motor,r,k_m,nu,mu,m,I_B,g)
%constants = [m;r;k_m;I_x;I_y;I_z;nu;mu;0;0;0;0;g];
end