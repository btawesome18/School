%%ASEN 3111- Computatinal Assignment 1
%Problem 1 compares simpsons rule vs trapizodal approximations using the
%example of a spinning cylender
%Problem 2 uses a trapizodal sum to caluclate the lift and drag of an
%airfoil given a pressure distibution
%By Brian Trybus
%Contributers: Cannon Palmer (rubber duck debugging)
%1/11/2022

load("Data_CA1_Trybus_Brian.mat");

%% Problem 1
fprintf("Problem 1:\n");
%part a.
fprintf("Part a.) Given a rotainal rate of -pi*R*V_inf  analytically the lift coefficient is -pi, and the drag coefficient is 0.\n");

%part b.


%Will test for accuracy from 1-50 points of intergration

resultsTrap = zeros(3,50); %Pre alocate arry for speed
R = 1;
V = 1;
Gamma = -pi*R*V;

cl = @(x) coefficientPressureCylinder(x,R,V,Gamma)*sin(x);
cd = @(x) coefficientPressureCylinder(x,R,V,Gamma)*cos(x);

for i = 1:50
    
    resultsTrap(2,i) = (-1/2)*trapezoidal(cl,0,(2*pi),i);
    resultsTrap(3,i) = (-1/2)*trapezoidal(cd,0,(2*pi),i);

    if (abs((resultsTrap(2,i)+pi)/pi)<0.01)
        resultsTrap(1,i) = 1;
    end

end
figure();
plot(resultsTrap(2,:))
hold on;
plot(resultsTrap(3,:))
title("Lift and Drag vs Number of panels with Trapizodal Sumation");
xlabel("Number of panels")
ylabel("Coefficent");
legend("Lift","Drag");

%part c.

resultsSimp = zeros(3,50); %Pre alocate arry for speed

for i = 1:50
    resultsSimp(2,i) = (-1/2)*simpsonsRule(cl,0,(2*pi),i);
    resultsSimp(3,i) = (-1/2)*simpsonsRule(cd,0,(2*pi),i);

    if (abs((resultsSimp(2,i)+pi)/pi)<0.01)
        resultsSimp(1,i) = 1;
    end
end
figure();
plot(resultsSimp(2,:))
hold on;
plot(resultsSimp(3,:))
title("Lift and Drag vs Number of panels with Simpson's Rule Sumation");
xlabel("Number of panels")
ylabel("Coefficent");
legend("Lift","Drag");

%part d
trapFirst = find(resultsTrap(1,:) , 1, 'first');
fprintf("Part d.) The trapazoid aproximation took %d steps to get within 1 percent of the analytical value.\n",trapFirst);
%part e
simpFirst = find(resultsSimp(1,:) , 1, 'first');
fprintf("Part e.) The Simpson rule aproximation took %d steps to get within 1 percent of the analytical value.\n",simpFirst);

% Reflection:
% For this problem they both finish really fast so the diffreacne is not
% clear, but simpsons rule should be must better. If given discrete data
% simpsions is a good method if you expect the data to be a continuse
% curve, if uncerten then trapizod is reliable.

%% Problem 2

fprintf("Problem 2:\n")

load("Cp.mat"); % Load in The Airfoil Pressure dist

%Define Givens
V_inf = 60; %m/s
rho_inf = 1; %kg/m^3
%p_inf = 85.5*10^3; % Pa Not needed
alpha = 9*(pi/180); % angle of attack 
c = 2;
thickness = 0.12;

% Test lift at high number of devisions to get an error refreance value
% assuing 10000 is more accurate then needed.
% samples = 10000; %number of sub devisions
% [L,D] = sumCpWingForLiftDrag(c,Cp_upper,Cp_lower, rho_inf, V_inf, samples,thickness, alpha);

fprintf("With %d samples there is Lift: %f [N], and Drag: %f [N]\n",10000, 3.8596e+03 ,104.9518);

%% How the number of subdivistions n requaired for a given percent is calulated here commented out to save time.

% L = 0;
% refLift = 3.8634e+03;
% samples = 0;
% 
% while( (abs((L-refLift)/refLift)>0.1) )%error is more then 10%
% 
%     samples = samples + 1; %incrementer 
%     [L,~] = sumCpWingForLiftDrag(c,Cp_upper,Cp_lower, rho_inf, V_inf, samples,thickness, alpha);
% 
% end
% fprintf("Number of subdivistions n requaired for 10 percent relative accuracy: %d \n" ,samples);
% samples = floor(samples/10)*10;
% while( (abs((L-refLift)/refLift)>0.01) )%error is more then 10%
% 
%     samples = samples + 10;
%     [L,~] = sumCpWingForLiftDrag(c,Cp_upper,Cp_lower, rho_inf, V_inf, samples,thickness, alpha);
% 
% end
% fprintf("Number of subdivistions n requaired for 1 percent relative accuracy: %d \n" ,samples);
% while( (abs((L-refLift)/refLift)>0.001) )%error is more then 10%
% 
%     samples = samples + 20;
%     [L,~] = sumCpWingForLiftDrag(c,Cp_upper,Cp_lower, rho_inf, V_inf, samples,thickness, alpha);
% 
% end
% fprintf("Number of subdivistions n requaired for 0.1 percent relative accuracy: %d \n" ,samples);

fprintf("Number of subdivistions n requaired for 10 percent relative accuracy: %d \n" ,48);
fprintf("Number of subdivistions n requaired for 1 percent relative accuracy: %d \n" ,400);
fprintf("Number of subdivistions n requaired for 0.1 percent relative accuracy: %d \n" ,2100);

