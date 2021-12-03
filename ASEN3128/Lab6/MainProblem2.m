%By Ben Arnold, Brian Trybus, Ryan Jones, Zach Rochman, 
%Date 11/14/2021
%Lab6 problem 2
clear
close all


recuv_tempest;

Va_trim = 22;
h_trim = 2438.5;

wind_inertial = [0;0;0];

trim_definition = [Va_trim; h_trim];


%%% Determine trim
[trim_variables, fval] = CalculateTrimVariables(trim_definition, aircraft_parameters);
[trim_state, trim_input]= TrimStateAndInput(trim_variables, trim_definition);


%%% Linear matrices
[Alon, Blon, Alat, Blat] = AircraftLinearModel(trim_definition, trim_variables, aircraft_parameters);

[eigVLon, eigDLon] = eig(Alon);
[eigVLat, eigDLat] = eig(Alat);

%%%%% Set initial condition
% STUDENTS COMPLETE

% Longitudinal Eigenvector Scaling:
for i = 3:6
    theta = eigVLon(4,i);
    scale = (90/pi)*real(theta);
    eigVLon(:,i) = eigVLon(:,i)/scale;
end

%% 2b
%figure(1)
tMax = 2;
ssLon = ss(Alon, Blon, eye(6), []);
ssLon.OutputName = {'u','w','q','theta','xE','zE'};
[~,t,Ot2b] = initial(ssLon, real(eigVLon(:,3)), 2);

[~,state] = ode45(@(t,y) AircraftEOM(t,y,trim_input,wind_inertial,aircraft_parameters),t,trim_state,[]);
control = zeros(length(t),4);
for i = 1:length(t)
    state(i,:) = state(i,:)+([Ot2b(i,5),0,Ot2b(i,6),0,Ot2b(i,4),0,Ot2b(i,1),0,Ot2b(i,2),0,Ot2b(i,3),0]);
    control(i,:) = trim_input;
end


aircraft_state0 = trim_state+([Ot2b(1,5),0,Ot2b(1,6),0,Ot2b(1,4),0,Ot2b(1,1),0,Ot2b(1,2),0,Ot2b(1,3),0]');

TSPAN = [0 tMax];

[TOUT,YOUT] = ode45(@(t,y) AircraftEOM(t,y,trim_input,wind_inertial,aircraft_parameters),TSPAN,aircraft_state0,[]);

for i = 1:length(TOUT)
    controlODE(i,:) = trim_input;
end


PlotAircraftSim(t,state,control,wind_inertial,'b');
PlotAircraftSim(TOUT,YOUT,controlODE,wind_inertial,'k');

for i = 1:4
    figure(i)
    subplot(3,1,1);
    legend('Initial','ODE45');
    subplot(3,1,2);
    legend('Initial','ODE45');
    subplot(3,1,3);
    legend('Initial','ODE45');
end
figure(5)
legend('Initial','ODE45');

for i = 1:5
   name = "F"+i+"Problem2b.png";
   saveas(figure(i),name); 
end

close all;

clear t state TOUT YOUT controlODE;

%% 2a

tMax = 250;
[~,t,Ot2a] = initial(ssLon, real(eigVLon(:,5)), tMax);

[~,state] = ode45(@(t,y) AircraftEOM(t,y,trim_input,wind_inertial,aircraft_parameters),t,trim_state,[]);
control = zeros(length(t),4);
for i = 1:length(t)
    state(i,:) = state(i,:)+([Ot2a(i,5),0,Ot2a(i,6),0,Ot2a(i,4),0,Ot2a(i,1),0,Ot2a(i,2),0,Ot2a(i,3),0]);
    control(i,:) = trim_input;
end


aircraft_state0 = trim_state+([Ot2a(1,5),0,Ot2a(1,6),0,Ot2a(1,4),0,Ot2a(1,1),0,Ot2a(1,2),0,Ot2a(1,3),0]');

TSPAN = [0 tMax];

[TOUT,YOUT] = ode45(@(t,y) AircraftEOM(t,y,trim_input,wind_inertial,aircraft_parameters),TSPAN,aircraft_state0,[]);

for i = 1:length(TOUT)
    controlODE(i,:) = trim_input;
end


PlotAircraftSim(t,state,control,wind_inertial,'b');
PlotAircraftSim(TOUT,YOUT,controlODE,wind_inertial,'k');

for i = 1:4
    figure(i)
    subplot(3,1,1);
    legend('Initial','ODE45');
    subplot(3,1,2);
    legend('Initial','ODE45');
    subplot(3,1,3);
    legend('Initial','ODE45');
end
figure(5)
legend('Initial','ODE45');

for i = 1:5
   name = "F"+i+"Problem2a.png";
   saveas(figure(i),name); 
end

close all;

clear t state TOUT YOUT controlODE;


%% 2c
% figure(3)
ssLon = ss(Alon, Blon, eye(6), []);
ssLon.OutputName = {'u','w','q','theta','xE','zE'};
[~,t,Ot2c] = initial(ssLon, real(eigVLon(:,3)), 25);
% title('Tempest Short Period Response')

tMax = 25;

[~,state] = ode45(@(t,y) AircraftEOM(t,y,trim_input,wind_inertial,aircraft_parameters),t,trim_state,[]);
control = zeros(length(t),4);
for i = 1:length(t)
    state(i,:) = state(i,:)+([Ot2c(i,5),0,Ot2c(i,6),0,Ot2c(i,4),0,Ot2c(i,1),0,Ot2c(i,2),0,Ot2c(i,3),0]);
    control(i,:) = trim_input;
end


aircraft_state0 = trim_state+([Ot2c(1,5),0,Ot2c(1,6),0,Ot2c(1,4),0,Ot2c(1,1),0,Ot2c(1,2),0,Ot2c(1,3),0]');

TSPAN = [0 tMax];

[TOUT,YOUT] = ode45(@(t,y) AircraftEOM(t,y,trim_input,wind_inertial,aircraft_parameters),TSPAN,aircraft_state0,[]);

for i = 1:length(TOUT)
    controlODE(i,:) = trim_input;
end


PlotAircraftSim(t,state,control,wind_inertial,'b');
PlotAircraftSim(TOUT,YOUT,controlODE,wind_inertial,'k');

for i = 1:4
    figure(i)
    subplot(3,1,1);
    legend('Initial','ODE45');
    subplot(3,1,2);
    legend('Initial','ODE45');
    subplot(3,1,3);
    legend('Initial','ODE45');
end
figure(5)
legend('Initial','ODE45');

for i = 1:5
   name = "F"+i+"Problem2c.png";
   saveas(figure(i),name); 
end

close all;

clear t state TOUT YOUT controlODE;


%% 2di
for i = 3:6
    theta = eigVLon(4,i);
    scale = 5*(180/pi)*real(theta);
    eigVLon(:,i) = eigVLon(:,i)/scale;
end


% figure(4)
ssLon = ss(Alon, Blon, eye(6), []);
ssLon.OutputName = {'u','w','q','theta','xE','zE'};
[~,t,Ot2di] = initial(ssLon, real(eigVLon(:,5)), 250);
% title('Tempest Short Period Response 5 Degree Pertibation')
tMax = 250;

[~,state] = ode45(@(t,y) AircraftEOM(t,y,trim_input,wind_inertial,aircraft_parameters),t,trim_state,[]);
control = zeros(length(t),4);
for i = 1:length(t)
    state(i,:) = state(i,:)+([Ot2di(i,5),0,Ot2di(i,6),0,Ot2di(i,4),0,Ot2di(i,1),0,Ot2di(i,2),0,Ot2di(i,3),0]);
    control(i,:) = trim_input;
end


aircraft_state0 = trim_state+([Ot2di(1,5),0,Ot2di(1,6),0,Ot2di(1,4),0,Ot2di(1,1),0,Ot2di(1,2),0,Ot2di(1,3),0]');

TSPAN = [0 tMax];

[TOUT,YOUT] = ode45(@(t,y) AircraftEOM(t,y,trim_input,wind_inertial,aircraft_parameters),TSPAN,aircraft_state0,[]);

for i = 1:length(TOUT)
    controlODE(i,:) = trim_input;
end


PlotAircraftSim(t,state,control,wind_inertial,'b');
PlotAircraftSim(TOUT,YOUT,controlODE,wind_inertial,'k');

for i = 1:4
    figure(i)
    subplot(3,1,1);
    legend('Initial','ODE45');
    subplot(3,1,2);
    legend('Initial','ODE45');
    subplot(3,1,3);
    legend('Initial','ODE45');
end
figure(5)
legend('Initial','ODE45');

for i = 1:5
   name = "F"+i+"Problem2di.png";
   saveas(figure(i),name); 
end

close all;

clear t state TOUT YOUT controlODE;



%% 2dii
for i = 3:6
    theta = eigVLon(4,i);
    scale = 10*(180/pi)*real(theta);
    eigVLon(:,i) = eigVLon(:,i)/scale;
end


% figure(5)
ssLon = ss(Alon, Blon, eye(6), []);
ssLon.OutputName = {'u','w','q','theta','xE','zE'};
[~,t,Ot2dii] = initial(ssLon, real(eigVLon(:,5)), 250);
% title('Tempest Short Period Response 10 Degree Pertibation')

tMax = 250;

[~,state] = ode45(@(t,y) AircraftEOM(t,y,trim_input,wind_inertial,aircraft_parameters),t,trim_state,[]);
control = zeros(length(t),4);
for i = 1:length(t)
    state(i,:) = state(i,:)+([Ot2dii(i,5),0,Ot2dii(i,6),0,Ot2dii(i,4),0,Ot2dii(i,1),0,Ot2dii(i,2),0,Ot2dii(i,3),0]);
    control(i,:) = trim_input;
end


aircraft_state0 = trim_state+([Ot2dii(1,5),0,Ot2dii(1,6),0,Ot2dii(1,4),0,Ot2dii(1,1),0,Ot2dii(1,2),0,Ot2dii(1,3),0]');

TSPAN = [0 tMax];

[TOUT,YOUT] = ode45(@(t,y) AircraftEOM(t,y,trim_input,wind_inertial,aircraft_parameters),TSPAN,aircraft_state0,[]);

for i = 1:length(TOUT)
    controlODE(i,:) = trim_input;
end


PlotAircraftSim(t,state,control,wind_inertial,'b');
PlotAircraftSim(TOUT,YOUT,controlODE,wind_inertial,'k');

for i = 1:4
    figure(i)
    subplot(3,1,1);
    legend('Initial','ODE45');
    subplot(3,1,2);
    legend('Initial','ODE45');
    subplot(3,1,3);
    legend('Initial','ODE45');
end
figure(5)
legend('Initial','ODE45');

for i = 1:5
   name = "F"+i+"Problem2dii.png";
   saveas(figure(i),name); 
end

close all;

clear t state TOUT YOUT controlODE;




