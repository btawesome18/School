%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CODE CHALLENGE 7 - Template Script
%
% The purpose of this challenge is to estimate the velocity and kenitic
% energy profile of a falling object. 
%
% To complete the challenge, execute the following steps:
% 1) Set an initial condition velocity
% 2) Set values for constants
% 3) Propagate freefall w/ drag for 20 seconds
% 4) Plot the velocity vs. time
% 5) Calculate the change kinetic energy vs. time
% 6) Plot the change in kinetic energy vs. time
%
% NOTE: DO NOT change any variable names already present in the code.
% 
% Upload your team's script to Gradescope when complete.
% 
% NAME YOUR FILE AS Challenge7_Sec{section number}_Group{group breakout #}.m 
% ***Section numbers are 1 or 2*** 
% EX File Name: Challenge7_Sec1_Group15.m 
%
% STUDENT TEAMMATES
% 1) Tinie Doan tido3408@colorado
% 2) Ben Helfant behe9902@colorado.edu
% 3) Cali Greenbaum cagr8401@colorado.edu
% 4) Henri Wessels hewe8928@colorado.edu
% 5) Brian Trybus brtr7823@colorado.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Housekeeping
clear variables; close all; clc;

%% Set up
m = .3; % [kg]
g = 9.81; % [m/s^2]
rho = 1.225; % [kg/m^3]
Cd = 1.2; % coefficient of drag
A = .0046; % [m^2]
v0 = 0; % [m/s]
v = 0;
%% Propagate with ode45

[t,v] = ode45(@(t,v) Accel(t,v, m, g, rho, Cd, A) , [0,20], v0);

%% Plot Velocity vs. Time
figure(1);
plot(t,v);
title('Velocity vs. Time');
xlabel('Time (seconds)');
ylabel('Velocity(m/s)');

%% Calculate Kinetic Energy 
kE = ((1/2)*m).*(v.^2);

%% Plot Kinetic Energy vs. Time
figure(2);
plot(t,kE);
title('Kinetic Energy vs. Time');
xlabel('Time (seconds)');
ylabel('Kinetic Energy(J)');

%% Functions
function [accelOut] = Accel(t,vLast, mass,gravity, rho, Cd, area)
% Summary of this function goes here
%   Detailed explanation goes here
%   Used F=Ma to solve for a 
%   D = CD*.5(p*(V^2))*A
%   F =ma = gm- (CD*.5(p*(V^2))*A)
%   a = g - ((CD*.5(p*(V^2))*A)/m)
accelOut = -gravity + ((Cd*.5*(rho*area*(vLast^2)))/mass);
end