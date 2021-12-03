function [stateChanges] = LinEOM(t,state,f_motor,r,k_m,nu,mu,m,I_B,g)
    %{
        Inputs: 
                t, time in seconds
                state, current state values
                f_motor, 4x1 vector containing scalar force output of each motor
                r, radius of motors from center of mass, meters
                k_m, control moment coefficient
                nu, aerodynamic force coefficient
                mu, aerodynamic moment coefficient
                m, drone mass
                I_B, drone moment of inertial tensor, body comp
                g, acceleration due to gravity
                perturbance, small number used to express a flight
                    distruption, nominally 0
        Outputs:
                stateChanges, how each state value will change in the next
                instant of time
        Methodology:
                This function for use exclusively inside of ODE45; it takes
                advantage of the Quadrotor Equations of Motion to determine
                how a simulated quadrotor aircraft with behave given
                its current state and the current forces and moments on it
                (control, aerodynamic)
    %}
%%% Breaking down the state vector into easier-to-use vectors
    pos = state(1:3); % m; position
    EA = state(4:6); %  radians for crying out loud; Euler angle
    vel = state(7:9) ; % m/s, velocity
    omega = state(10:12) ; % rad/s
    
%%% Calculating Control and Aerodynamic Forces
    %Zc = -sum(f_motor); % The only control force %Comment out for Part 4
    Zc = 0; % Comment out For Part 5
    
    
%%% Calculating Control and Aerodynamic Moments (Comment out for part 4)
    Gc = [(r/sqrt(2))*(-f_motor(1)-f_motor(2)+f_motor(3)+f_motor(4)); ...
          (r/sqrt(2))*(f_motor(1)-f_motor(2)-f_motor(3)+f_motor(4)); ...  % Control moments based on motor output
          (k_m)*(f_motor(1)-f_motor(2)+f_motor(3) - f_motor(4))];
      
    G = -mu * sqrt(omega(1)^2 + omega(2)^2 + omega(3)^2) * omega; % Aerodynamic moments based on drag, rotational velocities

% Gc = [0,0,0]; % (Comment out for part 5)

% %%% Adds in a disturbance force to help analyze stability
%     if (0.5 < t) && (t < 2.1) % adding a "perturbance" for pt 3: like flicking the drone, or a gust of wind
% %         G = G + perturbance*cos(10*t); %sinusoidal
%         G = G + perturbance; % impulse (kinda)
%     end
   
%%% Forming stateChanges components, using Linearized Quadrotor Equations of Motion         
    xyz_dot = [vel(1); vel(2); vel(3)];
    EA_dot = [omega(1); omega(2); omega(3)];
    vel_dot = [-g*EA(2); g*EA(1); 1/m* Zc];
    omega_dot = [1/I_B(1,1) * Gc(1); 1/I_B(2,2) * Gc(2); 1/I_B(3,3) * Gc(3)];
    
    stateChanges = [ xyz_dot; EA_dot; vel_dot; omega_dot];
              
end