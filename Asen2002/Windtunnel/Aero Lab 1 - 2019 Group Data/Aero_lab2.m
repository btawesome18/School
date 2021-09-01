clc
clear
close all


% %Read Position Data 
% %positions_raw = readtable('Airfoil_pressure.csv');
% positions = table2array(positions_raw);
% Airspeed = positions(:,4);
% AOA =  positions(:,23);
% %finding the pressure at the tailing edge (port 11) using both ports 10 and
% %8 on the top of the air foil and 12 and 14 on the bottom of the air foil.
% 
% Port10p = positions(:,16);
% Port8p = positions(:,14);
% Top_P = [Port10p,Port8p];
% Port14p = positions(:,20);
% Port12p = positions(:,18);
% Bottom_P = [Port14p,Port12p];

PortLocations = [0,0.14665;0.175,0.33075;0.35,0.4018;0.7,0.476;1.05,0.49;1.4,0.4774;1.75,0.4403;2.1,0.38325;2.45,0.308;2.8,0.21875;3.5,0;2.8,0;2.45,0;2.1,0;1.75,0;1.4,0;1.05,0;0.7,0.0014;0.35,0.0175;0.175,0.03885];

