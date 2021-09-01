%By Brian Trybus - ID: 109538512
%Made 11-28-2020 Edited 12-6-2020

%Main: Sets conditions for rocket flight and plots bottle rocket flight

clear
close all;

%% Inputs:
%Inital Pressure 0-80psi 
g = 9.81; %Gravity m/s^2
Cd = 0.8; %Discharge
rho_Amb = 0.961; %kg/m^3
Vol_bottle = 0.002; %m^3
P_atmo = 12.1; %PSI
gamma = 1.4; %Gamma
rho_water = 1000; % kg/m^3
D_throat = 2.1; %cm
D_bottle = 10.5; %cm
R = 287; %J/kgK gas const air
T_air = 300; %K inital temp of all;
x0 = 0; %m start pos
y0 = 0.25; %m start pos
l_s = 0.5; %m guide rail for launch
v0 = 0; %starting veliocity
M_Bottle = 0.15; %kg empty bottle
Vx = 0; %m/s 
Vy = 0; %m/s


%Change Variables

theta = 30; % launch angle % Only goes down from here
P_gage = 76; % PSI of bottle %76 works %50 Default
Vol_water = 0.001; %m^3 water to start %opt 0.00075 never reaches 80 alone
CD = 0.5; %drag 0.3-0.5 %gets to 75 at 0.3

%unit conversions

P_atmoP = 6894.76*P_atmo; %pascals
P_bottle = 6894.76*P_gage; %pascals
D_throat_m = D_throat / 100; %m
D_bottle_m = D_bottle / 100; %m

%setting Constant arry
Vol_airI = Vol_bottle-Vol_water;
mass_air = ((((P_bottle+P_atmoP)*((Vol_bottle-Vol_water)))/(R*T_air)));
Constants = [g,Cd,rho_Amb,Vol_bottle,P_atmoP,gamma,rho_water,D_throat_m,D_bottle_m,R,CD,T_air,l_s,M_Bottle,theta,Vol_airI,mass_air];

%State vector
Thrust = 0;
TotalMass = M_Bottle + (rho_water* Vol_water) + mass_air;
State = [x0,y0,Vx,Vy,Vol_airI,mass_air,TotalMass,0];

%Set ODE45 to stop when rocket hits ground
options = odeset('Events', @myEvent);

[t,u] = ode45(@(t,u) Force(u,Constants),[0,5],State,options);

%Loop all of the ODE outputs to get Thrust
for i = 1:length(t)
    temp = [u(i,1),u(i,2),u(i,3),u(i,4),u(i,5),u(i,6),0];
    f = Force(temp,Constants);
    F(i,1) = f(8); %#ok<*SAGROW>
end
%Thrust Graph
plot(t,F(:,1));
xlim([0,0.45]);
title('Thrust vs Time');
xlabel('Time(s)');
ylabel('Thrust(N)');
figure();
%Trojectory
plot(u(:,1),u(:,2))
title('Trojectory');
xlabel('X distance (m)');
ylabel('Y distance (m)');
figure();
%Graph V vs t
plot(t,u(:,3))
title('X velocity vs Time');
xlabel('Time(s)');
ylabel('Velocity (m/s)');
figure();
plot(t,u(:,4))
title('Y velocity vs Time');
xlabel('Time(s)');
ylabel('Velocity (m/s)');
figure();
%Volume of air over time
plot(t,u(:,5))
title('Volume of Air vs Time');
xlabel('Time(s)');
ylabel('Volume (m^3)');
xlim([0,.25])


function [value, isterminal, direction] = myEvent(t, A)
    %Stop ODE at ground
    value      = (A(2) <= 0);
    isterminal = 1;   % Stop the integration
    direction  = 0;

end