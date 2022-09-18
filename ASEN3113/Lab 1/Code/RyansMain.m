%% ASEN 3113 Lab 1 Matlab Code - Group 5
% By Jarrett Bartson, Ryan Jones, Rishi Mayekar, Cannon Palmer, Brian Trybus 
clear;
clc;
close all;

%% Constants
P_atm = 101325; % Pa
psi2pa = 6894.76; % Pa/psi
V_heater = 48; % V
R_air = 0.287; % kJ/kgK
Cv_air = 0.718; % kJ/kgK
Vol_disp = 174322/1e9; % m^3

%%

%load data
load("Engine3_Temp8")
load("Engine3_Temp9")
load("Engine3_Temp10")
load("Engine3_Temp11")
load("Engine3_Temp12")

load("Group5_Temp8")
load("Group5_Temp10")
load("Group5_Temp12")

rpm60 = xlsread("Small_60rpm_150fps.xlsx");
rpm90 = xlsread("Small_90rpm_150fps.xlsx");
rpm114 = xlsread("Small_114rpm_150fps.xlsx");

% 1. Elapsed time [s]
% 2. Change in internal pressure [psi]
% 3. Electrical current to the heater [A]
% 4. Optical switch reading
% 5. Temperature of top surface of top (cold) plate [°C]
% 6. Temperature of bottom surface of top (cold) plate [°C]
% 7. Temperature of top surface of bottom (hot) plate [°C]
% 8. Temperature of bottom surface of bottom (hot) plate [°C]

%% Temp 8 - 60 rpm
i = 1;
while ~Group5_Temp8(i,4)
    i = i + 1;
end
j= i;
while Group5_Temp8(j,4)
    j = j + 1;
end

st = floor((j + i)/2);

Group5_Temp8 = Group5_Temp8(st:end, :);
Group5_Temp8(:, 1) = Group5_Temp8(:, 1) - Group5_Temp8(1, 1);
time1 = Group5_Temp8(:,1);

Group5_Temp8(:,2) = psi2pa*Group5_Temp8(:,2) + P_atm; % Gauge Pressure in Pa

figure(1)
title('Temperature Difference = 8 Degrees C')
subplot(2,2,1)
%plot(time1,Group5_Temp8(:,2))
plot(1:length(Group5_Temp8(:,2)),Group5_Temp8(:,2))
ylabel('Pressure (psi)')
title("Pressure Over Time")

subplot(2,2,2)
plot(time1,Group5_Temp8(:,6))
hold on
plot(time1,Group5_Temp8(:,5))
plot(time1,Group5_Temp8(:,8))
plot(time1,Group5_Temp8(:,7))
ylabel('Temperature (C)')
hold off
title("Temperatures of Channels")
legend("Top of Top","Bottom of Top","Top of Bottom","Bottom of Bottom")

subplot(2,2,3)
plot(time1,Group5_Temp8(:,8) - Group5_Temp8(:,5))
title("Temperature Difference Between Top and Bottom")
ylabel('Temperature (C)')
xlabel('Time (s)')

subplot(2,2,4)
plot(time1,Group5_Temp8(:,4))
title("Encoder Cycle")
xlabel('Time (s)')

%% Temp 10 - 90 rpm

i = 1;
while ~Group5_Temp10(i,4)
    i = i + 1;
end
j= i;
while Group5_Temp10(j,4)
    j = j + 1;
end

st = floor((j + i)/2);

Group5_Temp10 = Group5_Temp10(st:end, :);
Group5_Temp10(:, 1) = Group5_Temp10(:, 1) - Group5_Temp10(1, 1);
time2 = Group5_Temp10(:,1);

Group5_Temp10(:,2) = 6894.76*Group5_Temp10(:,2); % Pressure in Pa

figure(2)
title('Temperature Difference = 10 Degrees C')
subplot(2,2,1)
%plot(time2,Group5_Temp10(:,2))
plot(1:length(Group5_Temp10(:,2)),Group5_Temp10(:,2))
ylabel('Pressure (Pa)')
title("Pressure Over Time")

subplot(2,2,2)
plot(time2,Group5_Temp10(:,6))
hold on
plot(time2,Group5_Temp10(:,5))
plot(time2,Group5_Temp10(:,8))
plot(time2,Group5_Temp10(:,7))
ylabel('Temperature (C)')
hold off
title("Temperatures of Channels")
legend("Top of Top","Bottom of Top","Top of Bottom","Bottom of Bottom")

subplot(2,2,3)
plot(time2,Group5_Temp10(:,8) - Group5_Temp10(:,5))
title("Temperature Difference Between Top and Bottom")
ylabel('Temperature (C)')
xlabel('Time (s)')

subplot(2,2,4)
plot(time2,Group5_Temp10(:,4))
title("Encoder Cycle")
xlabel('Time (s)')

 
%% Temp 12 - 114 rpm

i = 1;
while ~Group5_Temp12(i,4)
    i = i + 1;
end
j= i;
while Group5_Temp12(j,4)
    j = j + 1;
end

st = floor((j + i)/2);

Group5_Temp12 = Group5_Temp12(st:end, :);
Group5_Temp12(:, 1) = Group5_Temp12(:, 1) - Group5_Temp12(1, 1);
time2 = Group5_Temp12(:,1);

Group5_Temp12(:,2) = 6894.76*Group5_Temp12(:,2); % Pressure in Pa

figure(3)
title('Temperature Difference = 12 Degrees C')
subplot(2,2,1)
%plot(time2,Group5_Temp12(:,2))
plot(1:length(Group5_Temp12(:,2)),Group5_Temp12(:,2))
ylabel('Pressure (Pa)')
title("Pressure Over Time")

subplot(2,2,2)
plot(time2,Group5_Temp12(:,6))
hold on
plot(time2,Group5_Temp12(:,5))
plot(time2,Group5_Temp12(:,8))
plot(time2,Group5_Temp12(:,7))
ylabel('Temperature (C)')
hold off
title("Temperatures of Channels")
legend("Top of Top","Bottom of Top","Top of Bottom","Bottom of Bottom")

subplot(2,2,3)
plot(time2,Group5_Temp12(:,8) - Group5_Temp12(:,5))
title("Temperature Difference Between Top and Bottom")
ylabel('Temperature (C)')
xlabel('Time (s)')

subplot(2,2,4)
plot(time2,Group5_Temp12(:,4))
title("Encoder Cycle")
xlabel('Time (s)')


%% P-V 60 rpmp
pistonA = 176.71*((1e-3)^2); %piston head area in mm^2

rpm60(:,3) = (1e-3)*rpm60(:,3);

% Aligning time axes of solidworks data with experimental data
    rpm60T(:,1) = 1:length(Group5_Temp8(1:end-2500,1));
    rpm60T(:,2) = Group5_Temp8(1:end-2500,1);
    rpm60T(:,3) = sampleAtTimes(Group5_Temp8(1:end-2500,1), rpm60(:,2), rpm60(:,3));  
% Scaling SW data to fit Experimental data
    rpm60S(:,3) = scaleSWdata(20000 * Group5_Temp8(1:end-2500,2) + 1000, rpm60T(:,3));
    rpm60S(:,2) = rpm60T(1:(length(rpm60S(:,3))),2);
    rpm60S(:,1) = 1:length(rpm60S(:,3));

rpm60 = rpm60S;

figure(4)
vol60 = (rpm60(:,3)-min(rpm60(:,3))) * pistonA;
plot(rpm60(:,2),vol60)
title('Volume of Piston Cylinder over Time - 8C Temp Difference')
xlabel('Time (s)')
ylabel('Piston Volume (mm^3)')

figure(5) % plotting vol (x) vs pressure (y)
plot(vol60,Group5_Temp8(1:length(vol60),2))

figure(6)
plot(rpm60(:,2),vol60 - vol60(1))
hold on
plot(rpm60(:,2),(1e-9)*(Group5_Temp8(1:length(vol60),2)))
legend('Solidworks','Experimental')
hold off

%% P-V 90 rpm
pistonA = 176.71*((1e-3)^2); %piston head area in mm^2

rpm90(:,3) = (1e-3)*rpm90(:,3);

% Aligning time axes of solidworks data with experimental data
    rpm90T(:,1) = 1:length(Group5_Temp10(1:end-2500,1));
    rpm90T(:,2) = Group5_Temp10(1:end-2500,1);
    rpm90T(:,3) = sampleAtTimes(Group5_Temp10(1:end-2500,1), rpm90(:,2), rpm90(:,3));  
% Scaling SW data to fit Experimental data
    rpm90S(:,3) = scaleSWdata(20000 * Group5_Temp10(1:end-2500,2) + 1000, rpm90T(:,3));
    rpm90S(:,2) = rpm90T(1:(length(rpm90S(:,3))),2);
    rpm90S(:,1) = 1:length(rpm90S(:,3));

rpm90 = rpm90S;

figure(7)
vol90 = (rpm90(:,3)-min(rpm90(:,3))) * pistonA;
plot(rpm90(:,2),vol90)
title('Volume of Piston Cylinder over Time - 8C Temp Difference')
xlabel('Time (s)')
ylabel('Piston Volume (mm^3)')

figure(8) % plotting vol (x) vs pressure (y)
plot(vol90,Group5_Temp10(1:length(vol90),2))

figure(9)
plot(rpm90(:,2),vol90 - vol90(1))
hold on
plot(rpm90(:,2),(1e-9)*(Group5_Temp10(1:length(vol90),2)))
legend('Solidworks','Experimental')
hold off


%% P-V 114 rpm

rpm114(:,3) = (1e-3)*rpm114(:,3);

% Aligning time axes of solidworks data with experimental data
    rpm114T(:,1) = 1:length(Group5_Temp12(1:end-2500,1));
    rpm114T(:,2) = Group5_Temp12(1:end-2500,1);
    rpm114T(:,3) = sampleAtTimes(Group5_Temp12(1:end-2500,1), rpm114(:,2), rpm114(:,3));  
% Scaling SW data to fit Experimental data
    rpm114S(:,3) = scaleSWdata(20000 * Group5_Temp12(1:end-2500,2) + 1000, rpm114T(:,3));
    rpm114S(:,2) = rpm114T(1:(length(rpm114S(:,3))),2);
    rpm114S(:,1) = 1:length(rpm114S(:,3));

rpm114 = rpm114S;

figure(10)
vol114 = (rpm114(:,3)-min(rpm114(:,3))) * pistonA;
plot(rpm114(:,2),vol114)
title('Volume of Piston Cylinder over Time - 8C Temp Difference')
xlabel('Time (s)')
ylabel('Piston Volume (mm^3)')

figure(11) % plotting vol (x) vs pressure (y)
plot(vol114,Group5_Temp12(1:length(vol114),2))

figure(12)
plot(rpm114(:,2),vol114 - vol114(1))
hold on
plot(rpm114(:,2),(1e-9)*(Group5_Temp12(1:length(vol114),2)))
legend('Solidworks','Experimental')
hold off



%% Finding Values for 60 RPM

[Win60, Wout60, Wnet60, INDEX60] = findWork(Group5_Temp8, vol60);

% [Win60, Wout60, Wnet60, INDEX60] = findWorkTV(Group5_Temp8, vol60);


m = mean(vol60) * mean(Group5_Temp8(:,2)) /...
    (R_air * mean((Group5_Temp8(:, 6) + Group5_Temp8(:, 7))/2));

% Finding Q_in using P = VI
I_avg = mean(Group5_Temp8(INDEX60(1):INDEX60(2),3));
P_cyc = V_heater * I_avg;
dt60 = Group5_Temp8(INDEX60(2),1) - Group5_Temp8(INDEX60(1),1); % Should be roughly 1s
Qin_60 = P_cyc * dt60;

% Finding Q_net_in using mcvdt
T_H = mean(Group5_Temp8(INDEX60(1):INDEX60(2),7)) + 273.15;
T_L = mean(Group5_Temp8(INDEX60(1):INDEX60(2),6)) + 273.15;
Q_net_in_60 = 2*m*Cv_air*(T_H - T_L);

% Carnot efficiency
n_carn_60 = 1 - T_L/T_H;

% Ideal efficiency
V1 = Vol_disp;
[V2, ~] = max(vol60); 
V2 = V2 + V1;
n_ideal_60 = R_air * (T_H + T_L) * log(V2/V1) / (Cv_air * (T_H - T_L));


%% Finding Values for 90 RPM

[Win90, Wout90, Wnet90, INDEX90] = findWork(Group5_Temp10, vol90);

m = mean(vol90) * mean(Group5_Temp10(:,2)) /...
    (R_air * mean((Group5_Temp10(:, 6) + Group5_Temp10(:, 7))/2));

% Finding Q_in using P = VI
I_avg = mean(Group5_Temp10(INDEX90(1):INDEX90(2),3));
P_cyc = V_heater * I_avg;
dt90 = Group5_Temp10(INDEX90(2),1) - Group5_Temp10(INDEX90(1),1); % Should be roughly 2/3s
Qin_90 = P_cyc * dt90;

% Finding Q_net_in using mcvdt
T_H = mean(Group5_Temp10(INDEX90(1):INDEX90(2),7)) + 273.15;
T_L = mean(Group5_Temp10(INDEX90(1):INDEX90(2),6)) + 273.15;
Q_net_in_90 = 2*m*Cv_air*(T_H - T_L);

% Carnot efficiency
n_carn_90 = 1 - T_L/T_H;


%% Finding Values for 114 RPM

[Win114, Wout114, Wnet114, INDEX114] = findWork(Group5_Temp12, vol114);

m = mean(vol114) * mean(Group5_Temp12(:,2)) /...
    (R_air * mean((Group5_Temp12(:, 6) + Group5_Temp12(:, 7))/2));

% Finding Q_in using P = VI
I_avg = mean(Group5_Temp12(INDEX114(1):INDEX114(2),3));
P_cyc = V_heater * I_avg;
dt114 = Group5_Temp12(INDEX114(2),1) - Group5_Temp12(INDEX114(1),1); % Should be roughly 1/2s
Qin_114 = P_cyc * dt114;

% Finding Q_net_in using mcvdt
T_H = mean(Group5_Temp12(INDEX114(1):INDEX114(2),7)) + 273.15;
T_L = mean(Group5_Temp12(INDEX114(1):INDEX114(2),6)) + 273.15;
Q_net_in_114 = 2*m*Cv_air*(T_H - T_L);

% Carnot efficiency
n_carn_114 = 1 - T_L/T_H;

%% Stirling Ideal Efficiency 

Th = mean(Group5_Temp8(INDEX60(1):INDEX60(2),7)) + 273.15; %Temp of resivoers 
Tl = mean(Group5_Temp8(INDEX60(1):INDEX60(2),6)) + 273.15;
nStriIdeal60 = 100*(  R_air*(Th -Tl)*log(V2/V1)  )/( (Cv_air*(Th -Tl )) +(R_air*Th*log(V2/V1)) );

Th = mean(Group5_Temp10(INDEX60(1):INDEX60(2),7)) + 273.15;%Temp of resivoers 
Tl = mean(Group5_Temp10(INDEX60(1):INDEX60(2),6)) + 273.15;
nStriIdeal90 = 100*(  R_air*(Th -Tl)*log(V2/V1)  )/( (Cv_air*(Th -Tl )) +(R_air*Th*log(V2/V1)) );

Th = mean(Group5_Temp12(INDEX60(1):INDEX60(2),7)) + 273.15;%Temp of resivoers 
Tl = mean(Group5_Temp12(INDEX60(1):INDEX60(2),6)) + 273.15;
nStriIdeal114 = 100*(  R_air*(Th -Tl)*log(V2/V1)  )/( (Cv_air*(Th -Tl )) +(R_air*Th*log(V2/V1)) );


%% Function to find work PV

function [W_in, W_out, W_net, INDEX] = findWork(Data, Vol)
    % Isolating one cycle
    IND = findCycleIndex(Data(:,4),8);

    % Indexing into a cycle
    N = 5;
    st = IND(N,1);
    endTime = IND(N+1,1);
    range = st:endTime;

    % Plotting said cycle
    plot(Vol(range),Data(range,2));
    %plot(Vol(range),(Data(range,6) + Data(range,5))/2)

    % Isolating ellipse
    vol_1 = Vol(range);
    press_1 = Data(range,2);

    % Net Work
    Area_1 = polyarea([vol_1; vol_1(1)], [press_1; press_1(1)])

    [V_min, left_end] = min(vol_1);
    [V_max, right_end] = max(vol_1);

    [P_max, top_end] = max(press_1);
    [P_min, bottom_end] = min(press_1);
    
    % Splitting area into three sections
    Sec_1 = cumtrapz(vol_1(1:top_end), press_1(1:top_end) - P_min);
    Sec_2 = cumtrapz(vol_1(top_end:bottom_end), press_1(top_end:bottom_end) - P_min);
    Sec_3 = cumtrapz(vol_1(bottom_end:end), press_1(bottom_end:end) - P_min);
    
    % Extra area to remove
    Extra = P_min * (V_max-V_min);

    W_out = Sec_2(end);
    W_in = -Sec_1(end) -Sec_3(end);
    W_net = W_out - W_in;
    
    % returning time of one cycle
    dt = Data(endTime,1) - Data(st,1);
    
    % Returning the cycle that was calculated
    INDEX = [st endTime];
    
end

%% Function to isolate cycle

function index = findCycleIndex(arry,numCycles)

    index = ones(numCycles+1,2);
    
    i = 1;
    
    for loop = 1:(numCycles+1)
    
        while ~arry(i)
            i = i + 1;
        end

        j= i;
        index(loop,1) = i;

        while arry(j)
            j = j + 1;
        end

        index(loop,2) = j;
        i = j+1;
        
    end

end


