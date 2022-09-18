% For 80m launch:
% Angle = 45 [deg], Pgage = 70 [psi] or 482633 [Pa], 
% P0(gage + ambient) = 82.1 [psi] or 566059 [Pa],
% Volume of Water = 0.0007 [m^3] (35% of bottle), 
% Drag Coefficient = 0.5

Db = .105;              % Diamter of bottle [m]
Dt = 0.021;             % Diameter of throat [m]
Mbottle = 0.15;         % Mass of bottle [kg]
gravity = 9.81;         % Gravity [m/s^2]
Vbottle = 0.002;        % Volume of bottle [m^3]
Vwater = 0.0007;        % Initial volume of water in bottle [m^3]
p_amb = 83426.56;       % Ambient pressure [Pa] (12.1 [psi])
p0 = 482633 + p_amb;    % Initial pressure of air in bottle (gage + ambient) [Pa] 
rhoW = 1000;            % Density of water [kg/m^3]
rhoA = 0.961;           % Density of ambient air [kg/m^3]
Cd = 0.8;               % Discharge coefficient
CD = 0.5;               % Drag Coefficient
R = 287;                % Gas Constant [J/(kg*K)]
T0air = 300;            % Initial Temperature of Air [K]
ls = 0.5;               % Length of test stand [m]
g = 1.4;                % Specific heat ratio
theta = 45;             % Angle of Launch [degrees]
Windspeed = 2;
WindHeading = 0;        

%Errors in
sigmaVwater = 0.001;
sigmaT = 1;
sigmap0 = 10;
sigmaCD = 0.01;
sigmaTheta = 2;
WindspeedSigma = 0.5;
WindHeadingSigma = 5;

V0air = Vbottle - Vwater; % Inital volume of air [m^3]
M0air = (p0 * V0air) / (R * T0air); % Intial mass of air in bottle [kg]
Ab = (pi/4)*(Db)^2; % Cross-Sectional Area of bottle [m^2]
At = (pi/4)*(Dt)^2; % Cross-Sectional Area of throat [m^2]
windX = Windspeed*cosd(WindHeading);
windY = Windspeed*sind(WindHeading);

% Constants to be passed to ODE45
C = [gravity; Vbottle; p0; p_amb; rhoW; rhoA; Ab; At; Cd; CD; V0air; R; theta; ls; g; M0air;0;1;0];

r = [0;0; 0.25]; % Initial position
vx = 0; % Initial velocity in the x-dir
vy = 0; % Initial velocity in the y-dir
vz = 0; % Initial velocity in the z-dir
Vair = V0air; % Volume of air in bottle
Mair = M0air; % Mass of air in bottle
Mrocket = Mbottle + (rhoW * Vwater) + Mair; % Total mass of rocket

X = [r; vx;vy; vz; Mrocket; Mair; Vair]; % Initial state vector for ODE45
tspan = [0 5]; % time span

%% ODE 45


options = odeset('Events', @myEvent); % Set ode to stop when we hit the ground

N = 100;
Impact = zeros(N,2);

Cr = C;

for i = 1:N
    
    Cr(3) = normrnd(p0, sigmap0 ); %Add normal dist to pressure at start
    Cr(10) = normrnd(CD, sigmaCD); %Add normal dist to CD
    Cr(13) = normrnd(theta, sigmaTheta); %Add normal dist to theta
    VwaterN = normrnd(Vwater,sigmaVwater); %Add normal dist to water volume
    WindspeedR = normrnd(Windspeed,WindspeedSigma);
    WindHeadingR = normrnd(WindHeading,WindHeadingSigma);

    V0air = Vbottle - VwaterN; % Inital volume of air [m^3]
    M0air = (p0 * V0air) / (R * normrnd(T0air,sigmaT)); % Intial mass of air in bottle [kg]
    
    Vair = V0air; % Volume of air in bottle
    Mair = M0air; % Mass of air in bottle
    Mrocket = Mbottle + (rhoW * VwaterN) + Mair; % Total mass of rocket
    
    windX = WindspeedR*cosd(WindHeadingR);
    windY = WindspeedR*sind(WindHeadingR);
    Cr(17) = windX;
    Cr(18) = windY;
    

    [t, y] = ode45(@(t, y, F) odefunc(t, y, Cr), tspan, X,options);

    Impact(i,1) = y(end,1);
    Impact(i,2) = y(end,2);
end

%% Plot error thing

x = Impact(:,1);
y = Impact(:,2);

figure; plot(x,y,'k.','markersize',6)
axis equal; grid on; xlabel('x [m]'); ylabel('y [m]'); hold on;
 
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



function [value, isterminal, direction] = myEvent(t, A)
    %Stop ODE at ground
    value      = (A(3) <= 0);
    isterminal = 1;   % Stop the integration
    direction  = 0;

end