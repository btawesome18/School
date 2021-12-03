%Code by Trayana Athannassova, Brian Trybus, Lucas Pereira, Benji Brandenburger
%Main code for lab4 velocity controlled quatrotor control loop.
close all;
clear;

%Given Variblaes:

m = 0.068; %(kg) mass of craft
r = 0.06; %(m) distance from rotor to cg
k_m = 0.0024; % (N*m/N) Control moment coeff
I_x = 5.8*(10^-5); %(kg*(m^2))
I_y = 7.2*(10^-5); %(kg*(m^2))
I_z = 1.0*(10^-4); %(kg*(m^2))
nu = 1*(10^-3); %(N/(m/s)^2)
mu = 2*(10^-6); % (N*m/(rad/s)^2)
g = 9.81; % m/s^2
constants = [m;r;k_m;I_x;I_y;I_z;nu;mu;0.261;0.261;0.261;0.261;g];%Constants




%ODE45
tSpan = [0,20];
state_0 = [100;100;-1600;.2047;0.2091;0;9.7822;9.3693;-4.0652;0;0;0];%Inital condisions of the aircraft

[t,state] = ode45(@(t,state)EOMQuad(t,state,constants),tSpan,state_0);

PlotAircraftSim(t,state,ones(length(t),4),'');


%% Part 2



k1 = 0.01;
k2 = 0.05;
k3 = 0.01;
k4 = 1;

Ak = [0,1,0,0;0,0,g,0;0,0,0,1;-(k3*k4)/I_x,-k3/I_x,-k2/I_x,-k1/I_x];

eig(Ak)
