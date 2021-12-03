%% ASEN 3112 Lab 1
% Created by: Steven Young
% September 25, 2021


%% Housekeeping

clear all
close all
warning('off')
clc



%% Reading in data

OTW_Data = table2array(readtable('Torsion20inlbf_146.txt'));
CTW_Data = table2array(readtable('Torsion400inlbf_143.txt'));

% Column 1: Time
% Column 2: Total twist angle applied to the specimen, in degrees. It is recorded by an encoder in the grip.
%           In order to convert it into strain, you will need to specimen the total length of your specimen, i.e. the distance
%           between grips.
% Column 3: Shear strain, γ, as measured by the extensometer. The units are degrees. It represents the average
%           strain over the instrument’s gauge length (Lext = 1 inch).
% Column 4: Applied torque, T, in in-lb.
OTW_Data(:,2) = deg2rad(OTW_Data(:,2));   % Converting to Radians
OTW_Data(:,3) = deg2rad(OTW_Data(:,3));   % Converting to Radians
CTW_Data(:,2) = deg2rad(CTW_Data(:,2));   % Converting to Radians
CTW_Data(:,3) = deg2rad(CTW_Data(:,3));   % Converting to Radians


%% Constants Needed

% CTW 
CTW_De = 3/4;                               % [in] Exterior Diameter
CTW_Re = 3/8;                               % [in] Exterior Radius
CTW_t = 1/16;                               % [in] Thickness
CTW_Ri = CTW_Re - CTW_t;                    % [in] Interior Radius
CTW_G = 3.75E6;                             % [psi] Shear Modulus
CTW_L = 10;                                 % [in] Length Between Grips
CTW_Lext = 1;                               % [in] Length of Extensometer
CTW_Ae = pi * ((CTW_Re + CTW_Ri)/2)^2;      % [sq-in] Area Enclosed
CTW_p = 2 * pi * ((CTW_Re + CTW_Ri)/2);     % [in] Perimeter

% OTW
OTW_De = 3/4;                               % [in] Exterior Diameter
OTW_Re = 3/8;                               % [in] Exterior Radius
OTW_t = 1/16;                               % [in] Thickness
OTW_Ri = OTW_Re - OTW_t;                    % [in] Interior Radius
OTW_G = 3.75E6;                             % [psi] Shear Modulus
OTW_L = 10;                                 % [in] Length Between Grips
OTW_Lext = 1;                               % [in] Length of Extensometer
OTW_p = 2 * pi * ((OTW_Re + OTW_Ri)/2);     % [in] Perimeter
% The cut width is to be assumed negligible compared to the cross section
% radial dimension.



%% Section IV.2.1

% Zeroing Angle
CTW_Data(:,2) = CTW_Data(:,2) - CTW_Data(1,2);

% Calculating Gamma for CTW
CTW_Gamma = CTW_Data(:,2) * CTW_Re / CTW_L;

% Extensometer Least Squares Fit
[CTWcoef,S] = polyfit(-CTW_Data(:,3),-CTW_Data(:,4),1);
[CTWregr,delta] = polyval(CTWcoef,-CTW_Data(:,3),S);

% Least Squares from gamma calculation
[CTWcoef2,S2] = polyfit(-CTW_Gamma,-CTW_Data(:,4),1);
[CTWregr2,delta2] = polyval(CTWcoef2,-CTW_Gamma,S2);

% G*J = slope * R
mid_R = (CTW_Re-0.5 * CTW_t);

% Extensometer
CTW_GJExtens = CTWcoef(1)* mid_R;
% From gamma calculation
CTW_GJCalc = CTWcoef2(1)*mid_R;

% Exact Hollow Tube
CTW_J = (pi/2)*((CTW_Re^4) - ((CTW_Re-CTW_t)^4)); % Polar Moment of Inertia
CTW_GJExact = CTW_G * CTW_J; 

% CTW Theory
CTW_Ae = pi * mid_R^2; % Area Enclosed
J_CTW = (4 * CTW_Ae^2 * CTW_t) / (2 * pi * mid_R); % Polar Moment of Inertia
CTW_GJctwTheory = CTW_G * J_CTW; 


%% Section IV2.2

% Extensometer GJ
[OTW_GJ1,~] = polyfit(OTW_Data(:,4),OTW_Data(:,3),1);
OTW_GJ1 = OTW_GJ1(1)*OTW_Re;
% Twist Angle GJ
[OTW_GJ2,~] = polyfit(OTW_Data(:,4),OTW_Data(:,2),1);
OTW_GJ2 = OTW_GJ2(1);
% Thin Wall Theory GJ
beta = 1/3;
alpha = 1/3;
OTW_ThinJ = beta * OTW_p * OTW_t^3;
OTW_GJ4 = OTW_G * OTW_ThinJ;




%% Plotting

figure(1)
plot(-CTW_Data(:,3),-CTW_Data(:,4),'k','Linewidth',1.5);
hold on
grid on
plot(-CTW_Gamma,-CTW_Data(:,4),'r','Linewidth',1.5);
plot(-CTW_Data(:,3),CTWregr,'b','Linewidth',1.5);
plot(-CTW_Gamma,CTWregr2,'m','Linewidth',1.5);
% Uncertainty Analysis
plot(-CTW_Data(:,3), CTWregr + delta,':','Color','g');
plot(-CTW_Data(:,3), CTWregr - delta,':','Color','g');

plot(-CTW_Gamma, CTWregr2 + delta2,':','Color','g');
plot(-CTW_Gamma, CTWregr2 - delta2,':','Color','g');
legend('Extensometer','Twist Angle','Extensometer Least Squares Regression','Calculated Least Squares','Error Bounds','Location', 'SouthEast')
title('CTW Torque vs. Shear Strain')
ylabel('Torque [in-lb]')
xlabel('Shear Strain [rad]')


figure(2)
plot(OTW_Data(:,3),OTW_Data(:,4));
hold on
grid on
plot(OTW_Data(:,2)/10,OTW_Data(:,4));
legend('Extensometer','Twist Angle')
title('OTW Torque vs. Shear Strain')
ylabel('Torque [in-lb]')
xlabel('Shear Strain [rad]')













