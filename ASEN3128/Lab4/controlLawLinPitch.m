function controlMoments = controlLawLinPitch(state,target,k)
    
    %delta = act-desired
    %implided delta in fron of phi and p
    %roll first
    controlMoments = [0,0,0];
    %Roll
    p_r = state(10);
    phi_r = state(4);
    p_d = target(4);
    phi_d = target(1);
    p = p_r-p_d;
    phi = phi_r - phi_d;

    %Pitch
    q_r = state(11);
    theta_r = state(5);
    q_d = target(5);
    theta_d = target(2);
    q = q_r-q_d;
    theta = theta_r - theta_d;

    
    %Find Moments using control law
    controlMoments(1) = (-k(1)*p)-(k(2)*phi);
    controlMoments(2) = (-k(4)*q)-(k(5)*theta);
    controlMoments(3) = state(12)*(-k(3));
    
end