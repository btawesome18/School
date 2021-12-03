% Brian Trybus, Ben Arnold, Matt Davis, Andrew Peterson
% ASEN 3128
% Created: 10/26/20
clear
close all
clc

h = 2000; % m
V = 21; %m/s

recuv_tempest;

tfinal = 150;
TSPAN = [0 tfinal];

trim_definition = [V,h];

wind_inertial = [0;0;0];

[trim_variables, fval] = CalculateTrimVariables(trim_definition, aircraft_parameters);

[aircraft_state0, control_input0] = stateControlInputs(trim_variables,trim_definition);


%%% Full sim in ode45
[TOUT,YOUT] = ode45(@(t,y) AircraftEOM(t,y,control_input0,wind_inertial,aircraft_parameters),TSPAN,aircraft_state0,[]);

for i=1:length(TOUT)
    UOUT(i,:) = control_input0';
end

%%% plot results
PlotAircraftSim(TOUT,YOUT,UOUT,[0;0;0],'b')