%Thrust Interpolation Model 
%By Brian Trybus 4-11-2021 - ID: 109538512

%% Define Inputs

%Inital Inputs
bottleDia = 0.105; %m
massDry = 0.160; %kg
massProp = .6; %kg
launchAngle = 45;
coDrag = 0.3;
windSpeed = 8; %mph ahh
windDriction = 185; %11.25; 
rhoAmb = 0.961;%kg/m^3

%% Find ISP 

    g = 9.81;

    sampleRate = 1652; %[Hz]
    
    thrustTemp = load('LA_Demo_S013_test2_600g');
    thrust = thrustTemp(:,3);
    lowerBound = 3484;
    upperBound = 3880;
    thrustUsed = thrust(lowerBound:upperBound);
    time = (upperBound-lowerBound)*sampleRate;
    
    I = trapz(thrustUsed)/(upperBound-lowerBound);
    
    Isp = I/g;
    

%% Define Intial Conditions

g = -9.81; %m/s^2

% Calculate deltaV

deltaV = Isp*g*log(massDry/(massDry+massProp));
Vint = deltaV*[0,cosd(launchAngle),sind(launchAngle)];
pos = [0,0,0];
state = [pos,Vint];

initalCon.wind = (windSpeed/ 2.237)*[sind(windDriction),cosd(windDriction),0];
initalCon.cd = coDrag;
initalCon.launchAngle = launchAngle;
initalCon.mass = massDry;
initalCon.g = g;
initalCon.rho = rhoAmb;
initalCon.bottleDie = bottleDia;

%% Run ODE45

options = odeset('Events', @myEvent);

[~,s1] = ode45(@(t,u) RocketFlight(u,initalCon),[0,5],state,options);

smaples = 200;

impact = zeros(smaples,2);

for n = 1:smaples 
    
    
    massDry = massDry+normrnd(0,0.001); %kg
    massProp = massProp+normrnd(0,0.001); %kg
    launchAngle = launchAngle+normrnd(0,1);
    coDrag = coDrag+normrnd(0,0.03);
    windSpeed = windSpeed + normrnd(0,0.5); %mph ahh
    windDriction = windDriction + normrnd(0,11.25); %11.25; 
    
    deltaV = Isp*g*log(massDry/(massDry+massProp));
    Vint = deltaV*[0,cosd(launchAngle),sind(launchAngle)];
    pos = [0,0,0];
    state = [pos,Vint];

    initalCon.wind = (windSpeed/ 2.237)*[sind(windDriction),cosd(windDriction),0];
    initalCon.cd = coDrag;
    initalCon.launchAngle = launchAngle;
    initalCon.mass = massDry;
    
    
    [~,s] = ode45(@(t,u) RocketFlight(u,initalCon),[0,5],state,options);
    
    
    
    impact(n,1) = s(length(s),1);
    impact(n,2) = s(length(s),2);
    
    
end
%% Plot error

x = impact(:,1);
y = impact(:,2);
figure; plot(x,y,'k.','markersize',6)
grid on; xlabel('x [m]'); ylabel('y [m]'); hold on;
 
% Calculate covariance matrix
P = cov(x,y);
mean_x = mean(x);
mean_y = mean(y);
 
% Calculate the define the error ellipses
n=100; % Number of points around ellipse
p=0:pi/n:2*pi; % angles around a circle
 
[eigvec,eigval] = eig(P); % Compute eigen-stuff
xy_vect = [cos(p'),sin(p')] * sqrt(eigval) * eigvec'; % Transformation
x_vect = xy_vect(:,1);
y_vect = xy_vect(:,2);
 
% Plot the error ellipses overlaid on the same figure
plot(1*x_vect+mean_x, 1*y_vect+mean_y, 'b')
plot(2*x_vect+mean_x, 2*y_vect+mean_y, 'g')
plot(3*x_vect+mean_x, 3*y_vect+mean_y, 'r')
title('200 Flight Impacts(Downrange 28.3m with 0.25 degrees drift)');



%% ODE setup

function [value, isterminal, direction] = myEvent(t, A)
    %Stop ODE at ground
    value      = (A(3) <= 0);
    isterminal = 1;   % Stop the integration
    direction  = 0;

end

% Fuction for ODE

function [out] = RocketFlight(state,initalCon)

    % State = [posx,y,z,volx,y,z]
    
    vAbs = [state(4),state(5),state(6)];
    
    g = initalCon.g;
    mass = initalCon.mass;
    rho = initalCon.rho;
    Cd = initalCon.cd;
    Area = pi*(initalCon.bottleDie/2)^2;

    %% Force Drag
    
    vRel = vAbs - initalCon.wind;
    
    vRelMag = sqrt((vRel(1)^2)+(vRel(2)^2)+(vRel(3)^2));
    
    heading = vRel./vRelMag;
    
    Drag = -(1/2)*rho*(vRelMag^2)*Cd*Area;
    
    forceDrag = heading*Drag;
    
    %% Force Grav
    
    forceG = [0,0,(g*mass)];
    
    %% End Condisions
    
    force = forceG + forceDrag;
    
    a = force./mass;
    
    out = [vAbs,a]';
end

