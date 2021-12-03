%Code by Trayana Athannassova, Brian Trybus, Lucas Pereira, Benji Brandenburger
%Main code for lab4 velocity controlled quatrotor control loop.
close all;
clear;

%Given Variblaes:

m = 0.068; %(kg) mass of craft
r = 0.06; %(m) distance from rotor to cg
k_m = 0.0024; % (N*m/N) Control moment coeff
I_x = 5.8*(10^-5); %(kg*(m^2))
I_y = 7.2*(10^-5); %(kg*(m^2))
I_z = 1.0*(10^-4); %(kg*(m^2))
nu = 1*(10^-3); %(N/(m/s)^2)
mu = 2*(10^-6); % (N*m/(rad/s)^2)
g = 9.81; % m/s^2
constants = [m;r;k_m;I_x;I_y;I_z;nu;mu;0;0;0;0;g];%Constants


k = [0,0,0.004];%gains for input k3 is the given from lab 3
target = [0,0,0,0,0,0,0,0,0]'; %(angle,rate,velocity)

%finding k from the roots
b= 2; %negative invers of time response target
c = 25; %negative invers of time response target %42 as value tested %improved was 25

k(1) = (c+b)*I_x;%K1 in x
k(2) = (c*b)*I_x;%K2 in x
%K(3) is K1 yaw
k(4) = (c+b)*I_y;%K1 in y
k(5) = (c*b)*I_y;%K2 in y

k(6) = 0.002378; %k3 in x %0.0002378 was tested Improved was .00048
k(7) = -(k(6)/I_x)*I_y; %k3 in y

%% Roll 5 degree
% ODE45
% tSpan = [0,2];
% state_0 = [0;0;0;5*pi/180;0;0;0;0;0;0;0;0];%Inital condisions of the aircraft
% 
% [t,state] = ode45(@(t,state)closedLoopEOMLinAttitude(t,state,constants,target,k),tSpan,state_0);
% 
% %Reverse Motor Forces
% Fm = zeros(length(t),4);
% for i = 1:length(t)
%     controlMoments = controlLawLinPitch(state(i,:),target,k);
%     Zc = -constants(1)*constants(13);
%     Fm(i,:) = ComputeMotorForces(Zc, controlMoments(1), controlMoments(2), controlMoments(3), constants(2), constants(3));
% end
% %Plot
% PlotAircraftSim(t,state,Fm,'-k');
% clear t state
%% Pitch 5 degree
%ODE45
% tSpan = [0,2];
% state_0 = [0;0;0;0;5*pi/180;0;0;0;0;0;0;0];%Inital condisions of the aircraft
% 
% [t,state] = ode45(@(t,state)closedLoopEOMLinAttitude(t,state,constants,target,k),tSpan,state_0);
% 
% %Reverse Motor Forces
% Fm = zeros(length(t),4);
% for i = 1:length(t)
%     controlMoments = controlLawLinPitch(state(i,:),target,k);
%     Zc = -constants(1)*constants(13);
%     Fm(i,:) = ComputeMotorForces(Zc, controlMoments(1), controlMoments(2), controlMoments(3), constants(2), constants(3));
% end
% %Plot
% PlotAircraftSim(t,state,Fm,'-b');
% clear t state
%% Roll Rate 0.1 rad/s
%ODE45
% tSpan = [0,2];
% state_0 = [0;0;0;0;0;0;0;0;0;0.1;0;0];%Inital condisions of the aircraft
% 
% [t,state] = ode45(@(t,state)closedLoopEOMLinAttitude(t,state,constants,target,k),tSpan,state_0);
% 
% %Reverse Motor Forces
% Fm = zeros(length(t),4);
% for i = 1:length(t)
%     controlMoments = controlLawLinPitch(state(i,:),target,k);
%     Zc = -constants(1)*constants(13);
%     Fm(i,:) = ComputeMotorForces(Zc, controlMoments(1), controlMoments(2), controlMoments(3), constants(2), constants(3));
% end
% %Plot
% PlotAircraftSim(t,state,Fm,'-r');
% clear t state
%% Pitch Rate 0.1 rad/s
%ODE45
% tSpan = [0,2];
% state_0 = [0;0;0;0;0;0;0;0;0;0;0.1;0];%Inital condisions of the aircraft
% 
% [t,state] = ode45(@(t,state)closedLoopEOMLinAttitude(t,state,constants,target,k),tSpan,state_0);
% 
% %Reverse Motor Forces
% Fm = zeros(length(t),4);
% for i = 1:length(t)
%     controlMoments = controlLawLinPitch(state(i,:),target,k);
%     Zc = -constants(1)*constants(13);
%     Fm(i,:) = ComputeMotorForces(Zc, controlMoments(1), controlMoments(2), controlMoments(3), constants(2), constants(3));
% end
% %Plot
% PlotAircraftSim(t,state,Fm,'-g');
% clear t state
% 
% %% Add Legend
% for i = 1:4 
%     figure(i)
%     subplot(3,1,1)
%     legend(["Roll", "Pitch", "Roll Rate","Pitch Rate"]);
% end
% figure(5)
% subplot(4,1,1)
% legend(["Roll", "Pitch", "Roll Rate","Pitch Rate"]);
% figure(6)
% legend(["Roll", "Pitch", "Roll Rate","Pitch Rate"]);
% figure(6)
% xlim([-3,3])
% ylim([-3,3])
% zlim([-1,1])
% grid on
% 
% % Save Plots
% for i = 1:6
%    name = "F"+i+"Linear.png";
%    saveas(figure(i),name); 
% end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%% Problem 4
% 
% k1 = k(1);
% k2 = k(2);
% k3span = [0,0.2];
% k3n = 10000;
% figure(7);
% PlotEigen(k1,k2,k3span,k3n,I_x,g,100)

%% Problem 5
%give 2 targets and a time it will change targets at that time.

%fFCEOMLoop(t,state,constants,target1,k,switchTime,target2)

%ODE45
tSpan = [0,13];
state_0 = [0;0;0;0;0;0;0;0;0;0;0;0];%Inital condisions of the aircraft
switchTime = 1;

target1 = [0,0,0,0,0,0,0,1,0]';
target2 = [0,0,0,0,0,0,0,0,0]';


[t,state] = ode45(@(t,state)fFCEOMLoop(t,state,constants,target1,k,switchTime,target2),tSpan,state_0);

%Reverse Motor Forces
Fm = zeros(length(t),4);
for i = 1:length(t)
    if(t<switchTime)
       controlMoments = feedForwardControl(state(i,:),target1,k); 
    else
       controlMoments = feedForwardControl(state(i,:),target2,k);
    end
    Zc = -constants(1)*constants(13);
    Fm(i,:) = ComputeMotorForces(Zc, controlMoments(1), controlMoments(2), controlMoments(3), constants(2), constants(3));
end
%Plot
PlotAircraftSim(t,state,Fm,'-k');
%plotty(t,state);
clear t state
figure(6)
xlim([-3,3])
ylim([-3,3])
zlim([-1,1])
grid on

for i = 1:6
   name = "F"+i+"ImprovedK.png";
   saveas(figure(i),name); 
end
