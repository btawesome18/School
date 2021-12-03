% Eric W. Frew
% ASEN 3128
% AeroCostForTrim.m
% Created: 10/15/20
% STUDENTS COMPLETE THIS FUNCTION

function cost = AeroCostForTrim(trim_variables, trim_definition, aircraft_parameters)
%
%
% INPUT:    trim_definition = [V0; h0]
%
%           trim_variables = [alpha0; de0; dt0];
%
% OUTPUT:   cost = norm(total_force) + norm(total_moment)
%
% 
% METHOD:   Determines the total force acting on the aircraft from the
%           aerodynamics and weight. Then takes the norm of both to create 
%           a single cost function that can be minimized.


%%% Calculate the state and control input vectors from the trim_variables
%%% and trim_definition
[aircraft_state_trim, control_surfaces_trim] = stateControlInputs(trim_variables,trim_definition); %STUDENTS COMPLETE (HINT: WRITE A FUNCTION)
rho0=stdatmo(trim_definition(2));

[aero_forces, aero_moments, ~] = AeroForcesAndMoments_BodyState_WindCoeffs(aircraft_state_trim, control_surfaces_trim, [0,0,0]', rho0, aircraft_parameters);

cost = (norm(aero_forces+(aircraft_parameters.W*[-sin(aircraft_state_trim(5));0;cos(aircraft_state_trim(5))]))) + norm(aero_moments); 

% S=aircraft_parameters.S;%planform area
% Va= trim_variables(1);%airspeed
% CL_trim=aircraft_parameters.W/(0.5*rho0*(Va^2)*S);
% 
% Cd_trim= aircraft_parameters.CDmin + (aircraft_parameters.K*(CL_trim-aircraft_parameters.CLmin)^2);

%%% Determine the TOTAL force 'forces_trim' and TOTAL moment 'moments_trim
%%% acting on the aircraft based on 'aicraft_state_trim' and
%%% 'control_surfaces_trim'
%force components
% lift=CL_trim*(0.5*rho0*(Va^2)*S);
% drag=Cd_trim*(0.5*rho0*(Va^2)*S);
% weight=aircraft_parameters.W;
% thrust= drag;
% %moment components
% m_aero= (rho*(Va^2)*S*c)*(Cm0+(Cmalpha*alpha)+(Cmq*q*(c/(2*Va)))+(Cmde*de));
% m_control= 0;
% %net forces and moments
% forces_trim=lift+drag+weight+thrust;
% moments_trim=m_aero+m_control;


%%% Final cost is calculated from total force and moment vectors
