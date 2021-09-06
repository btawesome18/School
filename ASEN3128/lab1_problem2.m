% Rachael Carreras, Luca Herlein, Samuel Hatton, Brian Trybus
% ASEN 3128
% lab1_problem2
% Created: 8/31/21

%% Housekeeping
clear; clc; close all;

%% Initial Run

% ic = [x,y,z,vx,vy,vz]
% x = north
% y = east
% z = down into the earth

mass = 0.03; %kg
dist = .03; % meters
Cd = 0.6; % coeff of drag
grav = 9.81; % m/s
area_ball = pi * (dist/2)^2; % m^2
wind = [5;10;0]; % m/s
rho = 1.225; % kg/m^3 (assuming sea level)


IC = [0; 0; 0; 0; 20; -20];
tspan = [0 10];

options = odeset('Events', @impactEvent);
[tout, stateOut] = ode45(@(t,stateVec)objectEOM(t,stateVec,rho,Cd,area_ball,mass,grav,wind), tspan, IC, options);

figure
plot3(stateOut(:,1),stateOut(:,2),-stateOut(:,3))
grid on

%% Part C, Wind Analysis

landingArray = varyWind(0,50,11);



%% Functions

function xdot = objectEOM(t,stateVec,rho,Cd,A,m,g,wind)
%
% Inputs: t = time in seconds, unused. 
%           stateVec = position x,y,z is in index 1,2,3. Velociy is in
%           index 4,5,6.
%           rho = air density (kg/m^3).
%           Cd = coefficient of drag.
%           A = crossectional area of the ball (m^2).
%           m = mass of the ball (kg).
%           g = gravity force(m/s^2).
%           wind = wind velocity relative to the inertial frame.
%
% Outputs: xdot, velocity v_x, v_y, v_z in index 1,2,3. Acceleration a_x,
% a_y, a_z is in index 4,5,6.
%
% Methodology: ode45 driver for the trajectory of the ball affected by wind
% speed. 
xdot = zeros(6,1);
vel = stateVec(4:6,1);

xdot(1) = stateVec(4);
xdot(2) = stateVec(5); 
xdot(3) = stateVec(6);
air_rel_vel = vel - wind;
air_speed = norm(air_rel_vel);

drag_force = -0.5 * rho * Cd * A * (air_speed^2);

drag_vec =  drag_force * (air_rel_vel/air_speed);

grav = [0;0;m*g];


acc = (drag_vec + grav)/m;



xdot(4) = acc(1);
xdot(5) = acc(2);
xdot(6) = acc(3);



end 

function landingArray = varyWind(minWind,maxWind,n)
%
% Inputs: minWind = lower bound of windspeeds to be iterated through
%           maxWind = upper bound for windspeed iteration
%           n = number of windspeeds inbetween bounds
%
% Outputs: none, produces a plot
%
% Methodology: runs ode45 multiple times, changing wind variable each run

    windVec = linspace(minWind,maxWind,n);

    landingArray = zeros(6,n);
    landing_distance = zeros(1,n);
    
    for i = 1:n
        windVel = zeros(1,3);
        windVel = [windVec(i),0,0]';

        m = 0.03; %kg
        d = .03; % meters
        Cd = 0.6; % coeff of drag
        g = 9.81; % m/s
        A = pi * (d/2)^2; % m^2
    %     wind = [0;-20;0]; % m/s
        rho = 1.225; % kg/m^3 (assuming sea level)


        IC = [0; 0; 0; 0; 20; -20];
        tspan = [0 10];
        
        
        
        options = odeset('Events', @impactEvent);
        [~,stateout1] = ode45(@(t,stateVec)objectEOM(t,stateVec,rho,Cd,A,m,g,windVel), tspan, IC, options);
        endCondition = stateout1(end,:);
        
        landingArray(:,i) = endCondition'; % saving end conditions 
        landing_distance(i) = norm(landingArray(1:2,i));%sqrt((landingArray(1,i)^2)+(landingArray(2,i)^2));
        
%         figure(3)
%         hold on
%         plot3(stateout1(:,1),stateout1(:,2),-stateout1(:,3))
%         grid off
    end

    
    figure(2)
    scatter(windVec,landing_distance)
    title('Wind Speed vs Landing Distance');
    xlabel('Wind Speed')
    ylabel('Landing Distance')

end


function [zPos, isterminal, direction] = impactEvent(t,stateVec)
    zPos = stateVec(3);
    isterminal = 1;
    direction = 0;
end
