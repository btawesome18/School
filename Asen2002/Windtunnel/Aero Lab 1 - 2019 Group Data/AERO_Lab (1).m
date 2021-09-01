%% AERO LAB
clear;
clc

%% Part 5
% Calculate airspeed from four different data files using the steps outlined in Appendix B. These four data files
% should cover the four measurement methods: Pitot-Static Probe to Pressure Transducer, Venturi Tube to Pressure
% Transducer, Pitot-Static Probe to Water Manometer, and Venturi Tube to Water Manometer. Include data for five
% different voltage values for a total of 20 airspeed measurements.

%% Pitot-Static Probe to Pressure Transducer
% Get data and assign values
files = dir('VelocityVoltageData\PitotProbetoPressureTransducer\');
V1 = strcat(files(3).folder,'\',files(3).name);
Pitot = load(V1);
R = 287;
dP = Pitot(:,3);
P_atm = Pitot(:,1);
T_atm = Pitot(:,2);

% Calculate airspeed and airspeed error
V_pitot = (2*dP.*(R.*T_atm./P_atm)).^.5;
P_atm_err =  230 * 1000 * .015;
P_err = 6894.76*.01;
T_atm_err = .25;

dVdP = R.*T_atm ./ (P_atm.*sqrt(2.*dP.*R.*T_atm ./ P_atm));
dVdP_atm = dP.*R.*T_atm ./ (P_atm.^2.*sqrt(2.*dP.*R.*T_atm ./ P_atm));
dVdT_atm = dP.*R./(P_atm.*sqrt(2.*dP.*R.*T_atm ./ P_atm));

V_pitot_err = sqrt((dVdP .* P_err).^2 + (dVdP_atm .* P_atm_err).^2 + (dVdT_atm .* T_atm_err).^2);

voltage_p = Pitot(:,7);
P_coeff = polyfit(voltage_p, V_pitot,1);
P_line = polyval(P_coeff,voltage_p);    %Line of best fit for pitot

% Plot
figure(1);
hold on;
plot(voltage_p,V_pitot);
errorbar(voltage_p, V_pitot, V_pitot_err);
title("Pitot Velocity vs Voltage");
xlabel("Voltage (V)");
ylabel("Velocity (m/s)");
hold off;


%% Venturi Tube to Pressure Transducer
% Get data and assign values
files = dir('VelocityVoltageData\VenturiTubeToPressureTransducer\');
V2 = strcat(files(3).folder,'\',files(3).name);
Venturi = load(V2);
dP_v = Venturi(:,3);
P_atm_v = Venturi(:,1);
T_atm_v = Venturi(:,2);
A1 = 42.5^2;
A2 = 12^2;

% Calculate airspeed and error
V_venturi = (2 * dP_v .* R .* T_atm_v ./ (P_atm_v .* (1 - (A2/A1).^2))).^.5;

dVdP_venturi = R.*T_atm_v ./ (P_atm_v.*(1 - (A2/A1).^2).* sqrt(2.*dP_v.*R.*T_atm_v ./ (P_atm_v.*(1 - (A2/A1).^2))));
dVdP_atm_venturi = dP_v.*R.*T_atm_v ./ ((P_atm_v.^2.*(1 - (A2/A1).^2)).*sqrt(2.*dP_v.*R.*T_atm_v ./ (P_atm_v.*(1 - (A2/A1).^2))));
dVdT_atm_venturi = dP_v.*R./(P_atm_v.*(1 - (A2/A1).^2).*sqrt(2.*dP_v.*R.*T_atm_v ./ (P_atm_v.*(1 - (A2/A1).^2))));

V_venturi_err = sqrt((dVdP_venturi .* P_err).^2 + (dVdP_atm_venturi .* P_atm_err).^2 + (dVdT_atm_venturi .* T_atm_err).^2);

voltage_v = Venturi(:,7);

V_coeff = polyfit(voltage_v, V_venturi,1);
V_line = polyval(V_coeff,voltage_v);        %Line of best fit for venturi

% Plot
figure(2);
hold on;
plot(voltage_v, V_venturi);
errorbar(voltage_v, V_venturi, V_venturi_err);
title("Venturi Velocity vs Voltage");
xlabel("Voltage (V)");
ylabel("Velocity (m/s)");
hold off;

%% Pitot Static and Venturi Tube to Water Manometer
% Get data and assign values
files = dir('VelocityVoltageData\Water manometer readings (Responses).xlsx');
V3 = strcat(files(1).folder,'\',files(1).name);
Mano = readtable(V3);

type = Mano.WasTheManometerConnectedToTheVenturiTubeOrPitotStaticProbe_;
index = zeros(length(type),1);
indexv = zeros(length(type),1);
for i = 1:length(type)
        index(i) = type{i} == "Pitot Static Probe";
        indexv(i) = type{i} == "Venturi tube";
end

index = logical(index);
indexv = logical(indexv);
voltage1 = Mano{:,4};
voltage2 = Mano{:,6};
voltage3 = Mano{:,8};
voltage4 = Mano{:,10};
voltage5 = Mano{:,12};
dh1 = Mano{:,5};
dh2 = Mano{:,7};
dh3 = Mano{:,9};
dh4 = Mano{:,11};
dh5 = Mano{:,13};

pitotv1 = voltage1(index);
pitotv2 = voltage2(index);
pitotv3 = voltage3(index);
pitotv4 = voltage4(index);
pitotv5 = voltage5(index);

pitotmv = [pitotv1;pitotv2;pitotv3;pitotv4;pitotv5];

pitoth1 = dh1(index);
pitoth2 = dh2(index);
pitoth3 = dh3(index);
pitoth4 = dh4(index);
pitoth5 = dh5(index);

vv1 = voltage1(indexv);
vv2 = voltage2(indexv);
vv3 = voltage3(indexv);
vv4 = voltage4(indexv);
vv5 = voltage5(indexv);

venturimv = [vv1;vv2;vv3;vv4;vv5];

vh1 = dh1(indexv);
vh2 = dh2(indexv);
vh3 = dh3(indexv);
vh4 = dh4(indexv);
vh5 = dh5(indexv);

rho = 1000; % [kg/m^3]
g = 9.81;
IntoM = 1/39.37;
dP_mp1 = rho * g * pitoth1 * IntoM;
dP_mp2 = rho * g * pitoth2 * IntoM;
dP_mp3 = rho * g * pitoth3 * IntoM;
dP_mp4 = rho * g * pitoth4 * IntoM;
dP_mp5 = rho * g * pitoth5 * IntoM;

array_dP_mp = [dP_mp1;dP_mp2;dP_mp3;dP_mp4;dP_mp5];

dP_mv1 = rho * g * vh1 * IntoM;
dP_mv2 = rho * g * vh2 * IntoM;
dP_mv3 = rho * g * vh3 * IntoM;
dP_mv4 = rho * g * vh4 * IntoM;
dP_mv5 = rho * g * vh5 * IntoM;

array_dP_mv = [dP_mv1;dP_mv2;dP_mv3;dP_mv4;dP_mv5];

T_atm_mean = mean(T_atm);
P_atm_mean = mean(P_atm);

% Calculate airspeed and error
V_pitot_mano1 = (2*dP_mp1.*(R.*T_atm_mean./P_atm_mean)).^.5;
V_pitot_mano2 = (2*dP_mp2.*(R.*T_atm_mean./P_atm_mean)).^.5;
V_pitot_mano3 = (2*dP_mp3.*(R.*T_atm_mean./P_atm_mean)).^.5;
V_pitot_mano4 = (2*dP_mp4.*(R.*T_atm_mean./P_atm_mean)).^.5;
V_pitot_mano5 = (2*dP_mp5.*(R.*T_atm_mean./P_atm_mean)).^.5;

V_pitot_mano = [V_pitot_mano1; V_pitot_mano2; V_pitot_mano3; V_pitot_mano4; V_pitot_mano5];

V_venturi_mano1 = (2 * dP_mv1 .* R .* T_atm_mean ./ (P_atm_mean .* (1 - (A2/A1).^2))).^.5;
V_venturi_mano2 = (2 * dP_mv2 .* R .* T_atm_mean ./ (P_atm_mean .* (1 - (A2/A1).^2))).^.5;
V_venturi_mano3 = (2 * dP_mv3 .* R .* T_atm_mean ./ (P_atm_mean .* (1 - (A2/A1).^2))).^.5;
V_venturi_mano4 = (2 * dP_mv4 .* R .* T_atm_mean ./ (P_atm_mean .* (1 - (A2/A1).^2))).^.5;
V_venturi_mano5 = (2 * dP_mv5 .* R .* T_atm_mean ./ (P_atm_mean .* (1 - (A2/A1).^2))).^.5;

V_venturi_mano = [V_venturi_mano1;V_venturi_mano2;V_venturi_mano3;V_venturi_mano4;V_venturi_mano5];

mano_err = rho * g * .1 * IntoM;

dVdP_manop = R.*T_atm_mean ./ (P_atm_mean.*sqrt(2.*array_dP_mp.*R.*T_atm_mean ./ P_atm_mean));
dVdP_atm_manop = array_dP_mp.*R.*T_atm_mean ./ (P_atm_mean.^2.*sqrt(2.*array_dP_mp.*R.*T_atm_mean ./ P_atm_mean));
dVdT_atm_manop = array_dP_mp.*R./(P_atm_mean.*sqrt(2.*array_dP_mp.*R.*T_atm_mean ./ P_atm_mean));

V_manop_err = sqrt((dVdP_manop .* mano_err).^2 + (dVdP_atm_manop .* P_atm_err).^2 + (dVdT_atm_manop .* T_atm_err).^2);

% Sort the vectors in ascending voltage order
[pmvsort, pmvorder] = sort(pitotmv);
pmsort = V_pitot_mano(pmvorder);
pmerror = V_manop_err(pmvorder);
index = zeros(1,length(pmvsort));
%Remove outliers
temp = 0;
index(1) = 1;
for i = 1:length(pmvsort)
    if(pmvsort(i) ~= temp)
        index(i) = 1;
        temp = pmvsort(i);
    end
end
index = logical(index);
pmvplot = pmvsort(index);
pmplot = pmsort(index);

Pm_coeff = polyfit(pmvplot, pmplot,1);
Pm_line = polyval(Pm_coeff,pmvplot);        %Line of best fit for pitot mano

% Plot
figure(3);
hold on;
plot(pmvplot,pmplot);
errorbar(pmvplot,pmplot, pmerror(index));
title("Pitot Manometer Velocity vs Voltage");
xlabel("Voltage (V)");
ylabel("Velocity (m/s)");
hold off;


dVdP_manov = R.*T_atm_mean ./ (P_atm_mean.*(1 - (A2/A1).^2).* sqrt(2.*array_dP_mv.*R.*T_atm_mean ./ (P_atm_mean.*(1 - (A2/A1).^2))));
dVdP_atm_manov = array_dP_mv.*R.*T_atm_mean ./ ((P_atm_mean.^2.*(1 - (A2/A1).^2)).*sqrt(2.*array_dP_mv.*R.*T_atm_mean ./ (P_atm_mean.*(1 - (A2/A1).^2))));
dVdT_atm_manov = array_dP_mv.*R./(P_atm_mean.*(1 - (A2/A1).^2).*sqrt(2.*array_dP_mv.*R.*T_atm_mean ./ (P_atm_mean.*(1 - (A2/A1).^2))));

V_manov_err = sqrt((dVdP_manov .* mano_err).^2 + (dVdP_atm_manov .* P_atm_err).^2 + (dVdT_atm_manov .* T_atm_err).^2);


%Sort the vectors in ascending voltage order
[vmvsort, vmvorder] = sort(venturimv);
vmsort = V_venturi_mano(vmvorder);
vmerror = V_manov_err(vmvorder);
indexv = zeros(1,length(vmvsort));
%Remove outliers
temp = 0;
indexv(1) = 1;
for i = 1:length(vmvsort)
    if(vmvsort(i) ~= temp)
        indexv(i) = 1;
        temp = vmvsort(i);
    end
end
indexv = logical(indexv);
vmvplot = vmvsort(indexv);
vmplot = vmsort(indexv);

Vm_coeff = polyfit(vmvplot, vmplot,1);
Vm_line = polyval(Vm_coeff,vmvplot);        %Line of best fit for pitot mano

% Plot
figure(4);
hold on;
plot(vmvplot,vmplot);
errorbar(vmvplot,vmplot, vmerror(indexv));
title("Venturi Manometer Velocity vs Voltage");
xlabel("Voltage (V)");
ylabel("Velocity (m/s)");
hold off;


%% Part 6

%Get data and assign values
x = [];
portNum = [];
port = ["Port 1","Port 2","Port 3","Port 4","Port 5","Port 6","Port 7","Port 8","Port 9","Port 10","Port 11"];
Vb = strings(1,length(port));
for i = 1:length(port)
    files = dir('BoundaryLayerData\'+port(i)+'\');
    for j = 1:length(files)
        if(files(j).name ~= ".." && files(j).name ~= ".")
            Vb = strcat(files(3).folder,'\',files(j).name);
            x = [x;readmatrix(Vb)];
        end
    end
end

%port 9 and 11 have extra 500 
P_atm_port = x(:,1);
T_atm_port = x(:,2);
dp_port_air = x(:,3);
dp_port_aux = abs(x(:,4));
yvalues = x(:,6);
%yvalues = yvalues*.001;
xvalues = x(:,5);

freestream = yvalues > 100;
boundary = yvalues < 100;

rho = P_atm_port./(R.*T_atm_port);
v_inf_port = (2 .* dp_port_air ./ rho).^(.5);

v_inf_port_aux = (2 .* dp_port_aux ./ rho).^(.5);

x_loc = [9.05,10.3,11.01,11.99,12.97,13.95,14.93,15.91,16.89,17.87,18.85];
x_loc = x_loc / 39.37;  % Convert to correct units
port_loc = zeros(length(v_inf_port),1);

%% Port1
y1 = yvalues(1:12000);
yvalues1 = freestream(1:12000);
v_inf_port1 = v_inf_port(1:12000);
yvalues1aux = boundary(1:12000);
v_inf_port_aux1 = v_inf_port_aux(1:12000);
v_inf_port_aux1 = v_inf_port_aux1(yvalues1aux);
width = zeros(length(port),1);
figure(5);
hold on;
%scatter(yvalues(yvalues1),v_inf_port(yvalues1));
scatter(y1(yvalues1aux),v_inf_port_aux1);
v_boundary1 = mean(v_inf_port1(yvalues1)) * .95;
yline(v_boundary1);
hold off;
One = y1(yvalues1aux);
for i = 1:length(v_inf_port_aux1)
    if(v_boundary1 < v_inf_port_aux1(i))
        index1 = i;
        break
    end
end
width(1) = One(index1);

%% Port 2
y2 = yvalues(12001:24000);
yvalues2 = freestream(12001:24000);
v_inf_port2 = v_inf_port(12001:24000);
yvalues2aux = boundary(12001:24000);
v_inf_port_aux2 = v_inf_port_aux(12001:24000);
v_inf_port_aux2 = v_inf_port_aux2(yvalues2aux);
figure(6);
hold on;
%scatter(yvalues(yvalues2),v_inf_port(yvalues2));
scatter(y2(yvalues2aux),v_inf_port_aux2);
v_boundary2 = mean(v_inf_port2(yvalues2)) * .95;
yline(v_boundary2);
hold off;
Two = y2(yvalues2aux);
for i = 1:length(v_inf_port_aux2)
    if(v_boundary2 < v_inf_port_aux2(i))
        index2 = i;
        break
    end
end
width(2) = Two(index2);

%% Port 3
y3 = yvalues(24001:36000);
yvalues3 = freestream(24001:36000);
v_inf_port3 = v_inf_port(24001:36000);
yvalues3aux = boundary(24001:36000);
v_inf_port_aux3 = v_inf_port_aux(24001:36000);
v_inf_port_aux3 = v_inf_port_aux3(yvalues3aux);
figure(7);
hold on;
scatter(y3(yvalues3aux),v_inf_port_aux3); %%%%%%%
v_boundary3 = mean(v_inf_port3(yvalues3)) * .95;
yline(v_boundary3);
hold off;
Three = y3(yvalues3aux);
for i = 1:length(v_inf_port_aux3)
    if(v_boundary3 < v_inf_port_aux3(i))
        index3 = i;
        break
    end
end
width(3) = Three(index3);

%% Port 4
y4 = yvalues(36001:48000);
yvalues4 = freestream(36001:48000);
v_inf_port4 = v_inf_port(36001:48000);
yvalues4aux = boundary(36001:48000);
v_inf_port_aux4 = v_inf_port_aux(36001:48000);
v_inf_port_aux4 = v_inf_port_aux4(yvalues4aux);
figure(8);
hold on;
%scatter(yvalues(yvalues4),v_inf_port(yvalues4));
scatter(y4(yvalues4aux),v_inf_port_aux4);
v_boundary4 = mean(v_inf_port4(yvalues4)) * .95;
yline(v_boundary4);
hold off;
Four = y4(yvalues4aux);
for i = 1:length(v_inf_port_aux4)
    if(v_boundary4 < v_inf_port_aux4(i))
        index4 = i;
        break
    end
end
width(4) = Four(index4);

%% Port 5
y5 = yvalues(48001:72000);
yvalues5 = freestream(48001:72000);
v_inf_port5 = v_inf_port(48001:72000);
yvalues5aux = boundary(48001:72000);
v_inf_port_aux5 = v_inf_port_aux(48001:72000);
v_inf_port_aux5 = v_inf_port_aux5(yvalues5aux);
figure(9);
hold on;
%scatter(yvalues(yvalues5),v_inf_port(yvalues5));
scatter(y5(yvalues5aux),v_inf_port_aux5);
v_boundary5 = mean(v_inf_port5(yvalues5)) * .95;
yline(v_boundary5);
hold off;
Five = y5(yvalues5aux);
for i = 1:length(v_inf_port_aux5)
    if(v_boundary5 < v_inf_port_aux5(i))
        index5 = i;
        break
    end
end
width(5) = Five(index5);

%% Port 6
y6 = yvalues(72001:84000);
yvalues6 = freestream(72001:84000);
v_inf_port6 = v_inf_port(72001:84000);
yvalues6aux = boundary(72001:84000);
v_inf_port_aux6 = v_inf_port_aux(72001:84000);
v_inf_port_aux6 = v_inf_port_aux6(yvalues6aux);
figure(10);
hold on;
%scatter(yvalues(yvalues6),v_inf_port(yvalues6));
scatter(y6(yvalues6aux),v_inf_port_aux6);
v_boundary6 = mean(v_inf_port6(yvalues6)) * .95;
yline(v_boundary6);
hold off;
Six = y6(yvalues6aux);
for i = 1:length(v_inf_port_aux6)
    if(v_boundary6 < v_inf_port_aux6(i))
        index6 = i;
        break
    end
end
width(6) = Six(index6);

%% Port 7
y7 = yvalues(84001:102000);
yvalues7 = freestream(84001:102000);
v_inf_port7 = v_inf_port(84001:102000);
yvalues7aux = boundary(84001:102000);
v_inf_port_aux7 = v_inf_port_aux(84001:102000);
v_inf_port_aux7 = v_inf_port_aux7(yvalues7aux);
figure(11);
hold on;
%scatter(yvalues(yvalues7),v_inf_port(yvalues7));
scatter(y7(yvalues7aux),v_inf_port_aux7);
v_boundary7 = mean(v_inf_port7(yvalues7)) * .95;
yline(v_boundary7);
hold off;
Seven = y7(yvalues7aux);
for i = 1:length(v_inf_port_aux7)
    if(v_boundary7 < v_inf_port_aux7(i))
        index7 = i;
        break
    end
end
width(7) = Seven(index7);

%% Port 8
y8 = yvalues(102001:114000);
yvalues8 = freestream(102001:114000);
v_inf_port8 = v_inf_port(102001:114000);
yvalues8aux = boundary(102001:114000);
v_inf_port_aux8 = v_inf_port_aux(102001:114000);
v_inf_port_aux8 = v_inf_port_aux8(yvalues8aux);
figure(12);
hold on;
%scatter(yvalues(yvalues8),v_inf_port(yvalues8));
scatter(y8(yvalues8aux),v_inf_port_aux8);
v_boundary8 = mean(v_inf_port8(yvalues8)) * .95;
yline(v_boundary8);
hold off;
Eight = y8(yvalues8aux);
for i = 1:length(v_inf_port_aux8)
    if(v_boundary8 < v_inf_port_aux8(i))
        index8 = i;
        break
    end
end
width(8) = Eight(index8);

%% Port 9
y9 = yvalues(114001:126500);
yvalues9 = freestream(114001:126500);
v_inf_port9 = v_inf_port(114000:126500);
yvalues9aux = boundary(114001:126500);
v_inf_port_aux9 = v_inf_port_aux(114001:126500);
v_inf_port_aux9 = v_inf_port_aux9(yvalues9aux);
figure(13);
hold on;
%scatter(yvalues(yvalues9),v_inf_port(yvalues9));
scatter(y9(yvalues9aux),v_inf_port_aux9);
v_boundary9 = mean(v_inf_port9(yvalues9)) * .95;
yline(v_boundary9);
hold off;
Nine = y9(yvalues9aux);
for i = 1:length(v_inf_port_aux9)
    if(v_boundary9 < v_inf_port_aux9(i))
        index9 = i;
        break
    end
end
width(9) = Nine(index9);

%% Port 10
y10 = yvalues(126501:138500);
yvalues10 = freestream(126501:138500);
v_inf_port10 = v_inf_port(126501:138500);
yvalues10aux = boundary(126501:138500);
v_inf_port_aux10 = v_inf_port_aux(126501:138500);
v_inf_port_aux10 = v_inf_port_aux10(yvalues10aux);
figure(14);
hold on;
%scatter(yvalues(yvalues10),v_inf_port(yvalues10));
scatter(y10(yvalues10aux),v_inf_port_aux10);
v_boundary10 = mean(v_inf_port10(yvalues10)) * .95;
yline(v_boundary10);
hold off;
Ten = y10(yvalues10aux);
for i = 1:length(v_inf_port_aux10)
    if(v_boundary10 < v_inf_port_aux10(i))
        index10 = i;
        break
    end
end
width(10) = Ten(index10);

%% Port 11
y11 = yvalues(138501:151000);
yvalues11 = freestream(138501:151000);
v_inf_port11 = v_inf_port(138501:151000);
yvalues11aux = boundary(138501:151000);
v_inf_port_aux11 = v_inf_port_aux(138501:151000);
v_inf_port_aux11 = v_inf_port_aux11(yvalues11aux);
figure(15);
hold on;
%scatter(yvalues(yvalues11),v_inf_port(yvalues11));
scatter(y11(yvalues11aux),v_inf_port_aux11);
v_boundary11 = mean(v_inf_port11(yvalues11)) * .95;
yline(v_boundary11);
hold off;
Elev = y11(yvalues11aux);
for i = 1:length(v_inf_port_aux11)
    if(v_boundary11 < v_inf_port_aux11(i))
        index11 = i;
        break
    end
end
width(11) = Elev(index11);

figure(16);
scatter(1:11,width);

%% Part 7

files = dir('2002 Aero Lab 2 - Group Data/');
AirFoilPressure = [];
for i = 1:length(files)
    if(files(i).name ~= ".." && files(i).name ~= "." && files(i).name ~= "Archive")
        V4 = strcat(files(3).folder,'/',files(i).name);
        temp = readmatrix(V4);
        AirFoilPressure = [AirFoilPressure; temp];
    end
end

%New speed every 20
%New angle every 60
%1 file every 240;
%File s3023 has 239 so i deleted that one
newAirfoil = zeros(300,28);
for i = 1:300
    newAirfoil(i,:) = mean(AirFoilPressure((20*i-19):(20*i),:));
end
newAirfoil = sortrows(newAirfoil,23);

xAxis = newAirfoil(:,27);
Airspeed = newAirfoil(:,4);
DynP = newAirfoil(:,5);
%Top
Port10 = newAirfoil(:,15);
Port8 = newAirfoil(:,14);

%Bottom
Port12 = newAirfoil(:,16);
Port14 = newAirfoil(:,17);

Port11 = zeros(length(Port10),1);

for i = 1:length(Port10)
    U11 = interp1([2.1,2.8],[Port8(i),Port10(i)],3.5,'linear','extrap');
    L11 = interp1([2.8,2.1],[Port12(i),Port14(i)],3.5,'linear','extrap');
    Port11(i) = (U11+L11)/2;
end

Cp1 = newAirfoil(:,7)./DynP;
Cp2 = newAirfoil(:,8)./DynP;
Cp3 = newAirfoil(:,9)./DynP;
Cp4 = newAirfoil(:,10)./DynP;
Cp5 = newAirfoil(:,11)./DynP;
Cp6 = newAirfoil(:,12)./DynP;
Cp7 = newAirfoil(:,13)./DynP;
Cp8 = newAirfoil(:,14)./DynP;
Cp10 = newAirfoil(:,15)./DynP;
Cp11 = Port11./DynP;
Cp12 = newAirfoil(:,16)./DynP;
Cp14 = newAirfoil(:,17)./DynP;
Cp16 = newAirfoil(:,18)./DynP;
Cp17 = newAirfoil(:,19)./DynP;
Cp18 = newAirfoil(:,20)./DynP;
Cp19 = newAirfoil(:,21)./DynP;
Cp20 = newAirfoil(:,22)./DynP;

Cp = [Cp1,Cp2,Cp3,Cp4,Cp5,Cp6,Cp7,Cp8,Cp10,Cp11,Cp12,Cp14,Cp16,Cp17,Cp18,Cp19,Cp20];

totallength = 3.5;
XLoc = [0;.175;.35;.7;1.05;1.4;1.75;2.1;2.8;3.5;2.8;2.1;1.4;1.05;.7;.35;.175];
YLoc = [.14665;.33075;.4018;.476;.49;.4774;.4403;.38325;.21875;0;0;0;0;0;.0014;.0175;.03885];

chord = XLoc/totallength;
figure(17);
for i = 283:285
    hold on;
    plot(chord,Cp(i,:));
    set(gca,"Ydir","Reverse");
end
xlabel('Normalized Chord Length');
ylabel('Coefficient of Pressure');
legend('Angle of Attack @','','');
hold off;

figure(18);
for i = 163:165
    hold on;
    plot(chord,Cp(i,:));
    set(gca,"Ydir","Reverse");
end
xlabel('Normalized Chord Length');
ylabel('Coefficient of Pressure');
legend('Airspeed of ~9 m/s','Airspeed of ~`17 m/s','Airspeed of ~34 m/s');

hold off

Angle = newAirfoil(:,23);
n = zeros(300,16);
a = zeros(300,16);
for j = 1:300
    for i = 1:16
        n(j,i) = (1/2)*(Cp(j,i)+Cp(j,i+1))*((XLoc(i+1)-XLoc(i))/3.5);
        a(j,i) = (1/2)*(Cp(j,i)+Cp(j,i+1))*((YLoc(i+1)-YLoc(i))/3.5);
    end
end
Cn = -1*sum(n(:,1:16),2);
Ca = sum(a(:,1:16),2);
Cd = zeros(300,1);
Cl = zeros(300,1);

for i = 1:300
    Cl(i) = Cn(i)*cosd(Angle(i))-Ca(i)*sind(Angle(i));
    Cd(i) = Cn(i)*sind(Angle(i))+Ca(i)*cosd(Angle(i));
end

aMat = [Airspeed,Angle,Cl,Cd];
aMat = sortrows(aMat,1);
figure(19);
scatter(aMat(1:100,2),aMat(1:100,3));
xlabel('Angle of Attack');
ylabel('Coefficient of Lift');
figure(20);
scatter(aMat(1:100,2),aMat(1:100,4));
xlabel('Angle of Attack');
ylabel('Coefficient of Drag');
