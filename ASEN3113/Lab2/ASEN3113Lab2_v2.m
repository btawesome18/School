%% ASEN 3113 Lab 2 Heat Conduction Lab
% By Cannon Palmer, Brian Trybus, Ryan Jones, Jarrett Bartson, Rishi
% Mayekar

clear
clc
close all

Samp1 = load('Aluminum_25V_240mA');
Samp2 = load('Aluminum_28V_269mA');
Samp3 = load('Brass_26V_245mA');
Samp4 = load('Brass_29V_273mA');
Samp5 = load('Steel_21V_192mA');

%%%%%%%%%%
% Columns
% 1 = time
% 2 = Th0
% 3 = Th1
% 4 = Th2
% 5 = Th3
% 6 = Th4
% 7 = Th5
% 8 = Th6
% 9 = Th7
% 10 = Th8
%%%%%%%%%%

%% Question 1

positions = [0,1.375,1.875,2.375,2.875,3.375,3.875,4.375,4.875] * 0.0254;

ss_vec1 = Samp1(end,3:10);
ss_vec2 = Samp2(end,3:10);
ss_vec3 = Samp3(end,3:10);
ss_vec4 = Samp4(end,3:10);
ss_vec5 = Samp5(end,3:10);

% index = 10;
% ss_vec1 = Samp1(index,3:10);
% ss_vec2 = Samp2(index,3:10);
% ss_vec3 = Samp3(index,3:10);
% ss_vec4 = Samp4(index,3:10);
% ss_vec5 = Samp5(index,3:10);

samp_vec = {Samp1, Samp2, Samp3, Samp4, Samp5};

for j = 1:5
    sample = samp_vec{j};
    figure(1)
    subplot(2,3,j)
    plot(sample(:,1),sample(:,3))
    hold on
    plot(sample(:,1),sample(:,4))
    plot(sample(:,1),sample(:,5))
    plot(sample(:,1),sample(:,6))
    plot(sample(:,1),sample(:,7))
    plot(sample(:,1),sample(:,8))
    plot(sample(:,1),sample(:,9))
    plot(sample(:,1),sample(:,10))
    hold off
end

figure(2)
plot(positions(2:end),ss_vec1,'bo')
hold on
A = polyfit(positions(2:end),ss_vec1,1);
plot(positions,A(1)*positions + A(2),'b')

plot(positions(2:end),ss_vec2,'ro')
B = polyfit(positions(2:end),ss_vec2,1);
plot(positions,B(1)*positions + B(2),'r')

plot(positions(2:end),ss_vec3,'go')
C = polyfit(positions(2:end),ss_vec3,1);
plot(positions,C(1)*positions + C(2),'g')

plot(positions(2:end),ss_vec4,'ko')
D = polyfit(positions(2:end),ss_vec4,1);
plot(positions,D(1)*positions + D(2),'k')

plot(positions(2:end),ss_vec5,'mo')
E = polyfit(positions(2:end),ss_vec5,1);
plot(positions,E(1)*positions + E(2),'m')
%hold off

Area = (0.5 * 0.0254).^2 * pi; %area in m^2
kAl = 130;
kBr = 115;
kSt = 16.2;
Qin1 = 25 * 0.24;
Qin2 = 28 * 0.269;
Qin3 = 26 * 0.245;
Qin4 = 29 * 0.273;
Qin5 = 21 * 0.192;

slope1 = (Qin1 / (Area * kAl));%/ 1.5;
slope2 = (Qin2 / (Area * kAl));% / 1.5;
slope3 = Qin3 / (Area * kBr);
slope4 = Qin4 / (Area * kBr);
slope5 = (Qin5 / (Area * kSt));% / 1.8;

%T0 = 12;

%As seen from data files - only for comparison
% T01 = 12.3;
% T02 = 12.4;
% T03 = 12.3;
% T04 = 13;
% T05 = 12.1;
%%%%%%

plot(positions, A(2) + positions * slope1,'b--')
plot(positions, B(2) + positions * slope2,'r--')
plot(positions, C(2) + positions * slope3,'g--')
plot(positions, D(2) + positions * slope4,'k--')
plot(positions, E(2) + positions * slope5,'m--')
hold off

%% Question 2
%The analytical and experimental steady state temperatures should be within
%approximately 1 °C of each other. If they are not, how could you adjust
%your analytical solution implementation? What parameters could
%realistically be adjusted? Justify those changes with engineering reasons

% alphaAl = 4.819 * 10^-5; %units in m^2 / s
% alphaBr = 4.05 * 10^-6; %units in m^2 / s
% alphaSt = 3.564 * 10^-5; %units in m^2 / s
alphaAl = kAl / (2810 * 960); %units in m^2 / s
alphaBr = kBr / (8500 * 380); %units in m^2 / s
alphaSt = kSt / (8000 * 500); %units in m^2 / s
alpha_vec = [alphaAl, alphaAl, alphaBr, alphaBr, alphaSt];
alpha_vec2 = [alphaAl/2.5, alphaAl/2.5, alphaBr/4, alphaBr/4, alphaSt/1.5];
slope_vec = [slope1, slope2, slope3, slope4, slope5];
slope_vec2 = [slope1/1.7, slope2/1.7, slope3, slope4, slope5/1.75];
slope_vec3 = [slope1/1.6, slope2/1.6, slope3, slope4, slope5/2.1];
L = 5 * 0.0254; %units in m
T0_vec = [A(2),B(2),C(2),D(2),E(2)];
%T0_vec = [12,12,12,12,12];
name_vec = {'Aluminum 25V 240mA','Aluminum 28V 269mA','Brass 26V 245mA',...
    'Brass 29V 273mA','Steel 21V 192mA'};

error_SS = zeros(5,8);
error_SS_percent = zeros(5,8);

for j = 1:5
    num = 100;
    x = positions(2:end);
    T0 = T0_vec(j);
    sample = samp_vec{j};
    temp_vec = zeros(num,length(positions(2:end)));
    temp_vec2 = zeros(num,length(positions(2:end)));
    temp_vec3 = zeros(num,length(positions(2:end)));
    temp_vec4 = zeros(num,length(positions(2:end)));
    t_vec = linspace(sample(1,1),sample(end,1),num);
    for i = 1:num
        temp_vec(i,:) = u_xt(slope_vec(j),alpha_vec(j),L,x,T0,10,t_vec(i));
        
        temp_vec2(i,:) = u_xt(slope_vec2(j),alpha_vec(j),L,x,T0,10,t_vec(i));
        %only adjusts the analytical slope in order to get the steady
        %states within 1 degree of the experimental
        
        temp_vec3(i,:) = u_xt(slope_vec3(j),alpha_vec(j),L,x,sample(1,3:end),10,t_vec(i));
        %Adjust the initial temperature distribution to be the same as the
        %experimental solution, then adjust the slope for aluminum
        %and steel to simulate additional heat loss and we have a good
        %approximation, changing the initial temperature is also good for
        %question 3
        
        temp_vec4(i,:) = u_xt(slope_vec3(j),alpha_vec2(j),L,x,sample(1,3:end),10,t_vec(i));
    end

    figure(3)
    subplot(2,3,j)
    hold on
    plot(t_vec,temp_vec(:,1),'r')
    plot(t_vec,temp_vec(:,2),'r','HandleVisibility','off')
    plot(t_vec,temp_vec(:,3),'r','HandleVisibility','off')
    plot(t_vec,temp_vec(:,4),'r','HandleVisibility','off')
    plot(t_vec,temp_vec(:,5),'r','HandleVisibility','off')
    plot(t_vec,temp_vec(:,6),'r','HandleVisibility','off')
    plot(t_vec,temp_vec(:,7),'r','HandleVisibility','off')
    plot(t_vec,temp_vec(:,8),'r','HandleVisibility','off')
    hold off

    figure(4)
    subplot(2,3,j)
    hold on
    plot(t_vec,temp_vec2(:,1),'r')
    plot(t_vec,temp_vec2(:,2),'r','HandleVisibility','off')
    plot(t_vec,temp_vec2(:,3),'r','HandleVisibility','off')
    plot(t_vec,temp_vec2(:,4),'r','HandleVisibility','off')
    plot(t_vec,temp_vec2(:,5),'r','HandleVisibility','off')
    plot(t_vec,temp_vec2(:,6),'r','HandleVisibility','off')
    plot(t_vec,temp_vec2(:,7),'r','HandleVisibility','off')
    plot(t_vec,temp_vec2(:,8),'r','HandleVisibility','off')
    hold off

    figure(5)
    subplot(2,3,j)
    hold on
    plot(t_vec,temp_vec3(:,1),'r')
    plot(t_vec,temp_vec3(:,2),'r','HandleVisibility','off')
    plot(t_vec,temp_vec3(:,3),'r','HandleVisibility','off')
    plot(t_vec,temp_vec3(:,4),'r','HandleVisibility','off')
    plot(t_vec,temp_vec3(:,5),'r','HandleVisibility','off')
    plot(t_vec,temp_vec3(:,6),'r','HandleVisibility','off')
    plot(t_vec,temp_vec3(:,7),'r','HandleVisibility','off')
    plot(t_vec,temp_vec3(:,8),'r','HandleVisibility','off')
    hold off
    
    figure(6)
    subplot(2,3,j)
    hold on
    plot(t_vec,temp_vec4(:,1),'r')
    plot(t_vec,temp_vec4(:,2),'r','HandleVisibility','off')
    plot(t_vec,temp_vec4(:,3),'r','HandleVisibility','off')
    plot(t_vec,temp_vec4(:,4),'r','HandleVisibility','off')
    plot(t_vec,temp_vec4(:,5),'r','HandleVisibility','off')
    plot(t_vec,temp_vec4(:,6),'r','HandleVisibility','off')
    plot(t_vec,temp_vec4(:,7),'r','HandleVisibility','off')
    plot(t_vec,temp_vec4(:,8),'r','HandleVisibility','off')
    hold off
    
    
    for i = 3:6
        figure(i)
        hold on
        plot(sample(:,1),sample(:,3),'b')
        plot(sample(:,1),sample(:,4),'b','HandleVisibility','off')
        plot(sample(:,1),sample(:,5),'b','HandleVisibility','off')
        plot(sample(:,1),sample(:,6),'b','HandleVisibility','off')
        plot(sample(:,1),sample(:,7),'b','HandleVisibility','off')
        plot(sample(:,1),sample(:,8),'b','HandleVisibility','off')
        plot(sample(:,1),sample(:,9),'b','HandleVisibility','off')
        plot(sample(:,1),sample(:,10),'b','HandleVisibility','off')
        xlabel('Time (s)')
        ylabel(['Temperature (' char(176) 'C)']) 
        legend('Analytical','Experimental','Location','Best')
        title(name_vec{j})
        hold off
    end

    error_SS(j,:) = abs(temp_vec(end,1:8) - sample(end,3:10));
    error_SS_percent(j,:) = abs(100 * (temp_vec(end,1:8) - sample(end,3:10)) ./ sample(end,3:10));
end
figure(3)
sgtitle('Analytical and Experimental Temperatures vs Time') 
figure(4)
sgtitle('Heat Loss Adjusted Analytical and Experimental Comparison')
figure(5)
sgtitle('Initial Temperature Adjusted Analytical and Experimental Comparison')
figure(6)
sgtitle('Thermal Diffusivity Adjusted Analytical and Experimental Comparison') 

%% Question 3
%Note that in question 2 we assumed that the initial temperature of the 
%entire rod was constant, T0. Is this assumption valid for each dataset? 
%Justify your answer with experimental data. If the assumption is not valid,
%determine how the altered initial temperature profile will affect the
%transient solution - do this without solving any formulas. Can the transient
%solution be solved analytically given an initial temperature distribution?
%Hint: The slope of a line over the different thermocouple temperatures 
%at the cold steady state may be one option to show validity of the assumption.

%Just brainstorm how the altered initial temperature profile will affect
%the transient solution

figure()
hold on
for i = 1:5
    plot(positions(2:end),error_SS_percent(i,:),'o')
end
title('Percent Error Between Analytical and Experimental Steady State')
xlabel('Thermocouple Position (m)')
ylabel('Temperature Percent Error (%)')
legend('Aluminum 25V 240mA','Aluminum 28V 269mA','Brass 26V 245mA',...
    'Brass 29V 273mA','Steel 21V 192mA','Location','Best')
hold off

init_vec1 = Samp1(1,3:10);
init_vec2 = Samp2(1,3:10);
init_vec3 = Samp3(1,3:10);
init_vec4 = Samp4(1,3:10);
init_vec5 = Samp5(1,3:10);

init_A = polyfit(positions(2:end),init_vec1,1);
init_B = polyfit(positions(2:end),init_vec2,1);
init_C = polyfit(positions(2:end),init_vec3,1);
init_D = polyfit(positions(2:end),init_vec4,1);
init_E = polyfit(positions(2:end),init_vec5,1);

%% Question 4
% same as Q 2, but only the temperature over time plots are included (no error)
% Need to adjust the alpha values so that the new analytical plots line up better with
% the experimental plots (I think alpha effects the settling time)
% alpha_vec = [alphaAl * 0.6, alphaAl * 0.6, alphaBr * 1.1, alphaBr * 1.1, alphaSt * 0.5];
% 
% figure(5)
% for j = 1:5
%     num = 100;
%     x = positions(2:end);
%     T0 = T0_vec(j);
%     sample = samp_vec{j};
%     temp_vec = zeros(num,length(positions(2:end)));
%     t_vec = linspace(sample(1,1),sample(end,1),num);
%     for i = 1:num
%         temp_vec(i,:) = u_xt(slope_vec(j),alpha_vec(j),L,x,T0,10,t_vec(i));
%     end
% 
%     figure(5)
%     subplot(2,3,j)
%     plot(t_vec,temp_vec(:,1),'r')
%     hold on
%     plot(t_vec,temp_vec(:,2),'r','HandleVisibility','off')
%     plot(t_vec,temp_vec(:,3),'r','HandleVisibility','off')
%     plot(t_vec,temp_vec(:,4),'r','HandleVisibility','off')
%     plot(t_vec,temp_vec(:,5),'r','HandleVisibility','off')
%     plot(t_vec,temp_vec(:,6),'r','HandleVisibility','off')
%     plot(t_vec,temp_vec(:,7),'r','HandleVisibility','off')
%     plot(t_vec,temp_vec(:,8),'r','HandleVisibility','off')
%     
%     plot(sample(:,1),sample(:,3),'b')
%     plot(sample(:,1),sample(:,4),'b','HandleVisibility','off')
%     plot(sample(:,1),sample(:,5),'b','HandleVisibility','off')
%     plot(sample(:,1),sample(:,6),'b','HandleVisibility','off')
%     plot(sample(:,1),sample(:,7),'b','HandleVisibility','off')
%     plot(sample(:,1),sample(:,8),'b','HandleVisibility','off')
%     plot(sample(:,1),sample(:,9),'b','HandleVisibility','off')
%     plot(sample(:,1),sample(:,10),'b','HandleVisibility','off')
%     
%     legend('Analytical','Experimental','Location','Best')
%     title(name_vec{j})
%     hold off
% end
% sgtitle('Adjusted Alpha Analytical and Experimental Temperatures vs Time') 

%% Question 5
%I think we want to find the times at which we reach 1% error from the
%steady state value
L = 0.1905; %beam length in m
f_Al = alphaAl / L^2;
f_Br = alphaBr / L^2;
f_St = alphaSt / L^2;
% F0 = f_Al * 1200;

%% Functions

function [u] = u_xt(H,alpha,L,x,T0,n,t)

u = T0 + H*x;
%prev = 0;
for i = 1:n
    r = rem(i,2);
    if r == 1
        bn = -8*H*L ./ (pi.^2 * ((2*i)-1).^2);
    else
        bn = 8*H*L ./ (pi.^2 * ((2*i)-1).^2);
    end
    lambda = ((2*i)-1)*pi ./ (2*L);
    %exponential = -(lambda.^2)*alpha*t
    %u = u + bn * sin(lambda * x) * exp(-(lambda.^2)*alpha*t);
    %prev = bn;
    u = u + bn .* sin(lambda .* x) .* exp(-(lambda.^2)*alpha*t);
end

end