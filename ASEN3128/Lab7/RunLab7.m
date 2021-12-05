

clear all;
close all;


recuv_tempest;

Va_trim = 21;
h_trim = 1800;

wind_inertial = [0;0;0];

trim_definition = [Va_trim; h_trim];


%%% Use full minimization to determine trim
[trim_variables, fval] = CalculateTrimVariables(trim_definition, aircraft_parameters);
[trim_state, trim_input]= TrimStateAndInput(trim_variables, trim_definition);
[Alon, Blon, Alat, Blat] = AircraftLinearModel(trim_definition, trim_variables, aircraft_parameters);

[eigvec eigval] = eig(Alat, 'vector');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper code for Problem 3. Look inside the AircraftEOMControl function
% for hints on how to set up controllers for Problem 2 and Problem 4.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 2a
[num_yaw2rudder, den_yaw2rudder] = ss2tf(Alat(1:4,1:4), Blat(1:4,2), [0 0 1 0],0);
f111 = figure(111)
rlocus( -num_yaw2rudder, den_yaw2rudder ) 
hold on

%% Question 2b
k_r = -2;%5.45; %corresponds to dutch roll zeta FROM 0.14 TO 0.251
%increase zeta  of + 79.29 %
% pay attention to negative sign

%% Question 2c
delta_r = 0.2; % reccomendation from Rafi
temp_t = 1;
fullStateChange = AircraftEOMControl(temp_t,trim_state,trim_input,wind_inertial,aircraft_parameters, 2) ; 

%% Question 2d (ODE) for non linear and then linear separate
tspan = [0 200];
[time2d,  NewStateFull2d] = ode45(@(t,y)AircraftEOMControl(t,y,trim_input,wind_inertial,aircraft_parameters, 2), tspan, trim_state, []); %nonLinear
xlat2d = [0 0 0.2 0 0 0]' ; 
bigK2d = [ 0 0 k_r 0 0 0] ;
   Anew = (Alat - (Blat(:,2)*bigK2d));
%Sys2d = ss(Anew, [0 0 0 0 0 0]', eye(6), 0 );  Frew
Sys2d = ss(Anew, [0 0 0 0 0 0]', eye(6), 0);
eigVecReal_Dutch = real( (eigvec(:,4)));
eigVecReal_DutchNorm = eigVecReal_Dutch%/eigVecReal_Dutch(5);
 [lin_respond2d, lin_time2d] = initial(Sys2d,eigVecReal_DutchNorm, 200);
 for i = 1:length(lin_time2d)
     control_nonLind2(1:4,i) = trim_input';
 end
 lin_responedPadded = zeros(length(lin_time2d),12);
 lin_responedPadded(:,2)=lin_respond2d(:,6);
 lin_responedPadded(:,4)=lin_respond2d(:,4);
 lin_responedPadded(:,6)=lin_respond2d(:,5);
 lin_responedPadded(:,8)=lin_respond2d(:,1);
 lin_responedPadded(:,10)=lin_respond2d(:,2);
 lin_responedPadded(:,12)=lin_respond2d(:,3);
 %[0;IC_dutch(6);0;IC_dutch(4);0;IC_dutch(5);0;IC_dutch(1);0;IC_dutch(2);0;IC_dutch(3)];

%plot this rubbish
trimINvector = ones(4, length(time2d)) .* trim_input ; 
PlotAircraftSim(time2d, NewStateFull2d, trimINvector', wind_inertial, 'r-') % nonlinear plot
PlotAircraftSim(lin_time2d, lin_responedPadded, control_nonLind2', wind_inertial, 'b-') % Linear plot


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Transfer function from elevator to pitch angle
[num_elev2pitch, den_elev2pitch] = ss2tf(Alon(1:4,1:4), Blon(1:4,1), [0 0 0 1],0);

%%% Controller
kq = 1; %NOT REASONABLE VALUES
kth = 1; %NOT REASONABLE VALUES
num_c = [kq kth];
den_c = 1;

f111 = figure(112)
rlocus( -num_elev2pitch, den_elev2pitch ) 
hold on
% f111.CurrentAxes.LineWidth = 2;
% f111.CurrentAxes. = 2;
%rlocus( num_elev2pitch, den_elev2pitch) 
% f111.CurrentAxes.LineWidth = 2;

%%% Closed loop transfer function
pitch_cl = feedback(1, tf(conv(num_c, num_elev2pitch), conv(den_c, den_elev2pitch)));
[num_cl, den_cl] = tfdata(pitch_cl,'v');

%%% Poles of the closed loop (linear) system. Now do the same with the
%%% state stpace model.
roots(den_cl);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Full sim in ode45
aircraft_state0 = trim_state;
control_input0 = trim_input;

tfinal = 200;
TSPAN = [0 tfinal];
[TOUT2,YOUT2] = ode45(@(t,y) AircraftEOMControl(t,y,control_input0,wind_inertial,aircraft_parameters),TSPAN,aircraft_state0,[]);


for i=1:length(TOUT2)
    UOUT2(i,:) = control_input0';
end

PlotAircraftSim(TOUT2,YOUT2,UOUT2,wind_inertial,'b')



