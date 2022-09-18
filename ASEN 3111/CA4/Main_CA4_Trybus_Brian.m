%%ASEN 3111- Computatinal Assignment 1
%By Brian Trybus
%4/23/2022

%   Problem 1: Generate a theta beta Mach plot
%   Problem 2: Shock Expansion Theroy of diamond airfoil.
%   Problem 3: Shock Expansion Theroy of diamond airfoil vs lineraized at varing angles of attack.

%% Problem 1
%Allocate memory
Mach = [1.05,1.1,1.15,1.2,1.25,1.3,1.35,1.4,1.45,1.6,1.7,1.8,1.9,2,2.2,2.4,2.6,2.8,3];
Theta = linspace(0,90,9000);
StrongShock = zeros(1,9000);
WeakShock = zeros(1,9000);
%Make figure, plot updates in loop
figure(1)
hold on
for i = 1:length(Mach) %Loop for mach value

    for j = 1:length(Theta) %Loop for theta angle

        strong = (ObliqueShockBeta(Mach(i),Theta(j),1.4,'Strong'));
        weak = ((ObliqueShockBeta(Mach(i),Theta(j),1.4,'Weak')));
        
        StrongShock(j) = strong*(isreal(strong))*(strong>0);
        WeakShock(j) = weak*(isreal(weak))*(weak>0);
    end
    WeakShock((WeakShock==0)) = nan; %Clean the plot
    StrongShock((StrongShock==0)) = nan;%Clean the plot
    Shock = [StrongShock,WeakShock]; %Combines weak and strong curves to match colors
    plot([Theta,Theta],Shock)

end

legend(num2str(Mach))
title("θ −β −M Diagram for Mach 1.05 through 3")
xlabel("θ (degrees)")
ylabel("β (degrees)")


%% Problem 2

[c_l,c_d] = DiamondAirfoil(2,5,10,5);%Mach 2, angle of attack 5, 10 degree leading half angle, 5 trailing

fprintf("For a diamond airfoil with a leading half angle of 10 degrees, and trailing half angle of 5 degrees\nat mach 2 and an angle of attack of 5 degrees Shock Expansion theory predicts\na sectional lift coefficient of %f and a wave-drag coefficient of %f.\n",c_l,c_d);

%% Problem 3

%Allocate memory
alpha = linspace(-10,10,100);
Cl_lin = zeros(100,4);
Cdw_lin = zeros(100,4);
Cl_shock = zeros(100,4);
Cdw_shock = zeros(100,4);

for j = 1:4 %Loop Mach

    M = 1+j;

    for i = 1:100 %Loop angle of attack
    
        [Cl_shock(i,j),Cdw_shock(i,j)] = DiamondAirfoil(M,alpha(i),10,5);

        Cl_lin(i,j)=(4*(pi/180)*alpha(i))/sqrt((M^2)-1);
        Cdw_lin(i,j)=(4*(((pi/180)*(alpha(i)))^2))/sqrt((M^2)-1);
    
    end

end

%Plot Coeffiecnt of lift
figure(2)
hold on
%Plot Shock expansion
plot(alpha,Cl_shock(:,1),'b');
plot(alpha,Cl_shock(:,2),'r');
plot(alpha,Cl_shock(:,3),'g');
plot(alpha,Cl_shock(:,4),'m');
%Plot Linear results
plot(alpha,Cl_lin(:,1), 'b--');
plot(alpha,Cl_lin(:,2), 'r--');
plot(alpha,Cl_lin(:,3), 'g--');
plot(alpha,Cl_lin(:,4), 'm--');

legend('Mach: 2 ','Mach: 3','Mach: 4','Mach: 5','Mach: 2 Linear','Mach: 3 Linear','Mach: 4 Linear','Mach: 5 Linear','AutoUpdate','off')

xlabel("Angle Of Attack (degrees)")
ylabel("Coefficent of Lift")
title("Coefficent of Lift vs Angle of Attack at Variating Mach Numbers with both Linear and Shock-Expansion Theory");

%Plot Coeffiecnt of drag
figure(3)
hold on
%Plot Shock expansion
plot(alpha,Cdw_shock(:,1),'b');
plot(alpha,Cdw_shock(:,2),'r');
plot(alpha,Cdw_shock(:,3),'g');
plot(alpha,Cdw_shock(:,4),'m');
%Plot Linear results
plot(alpha,Cdw_lin(:,1), 'b--');
plot(alpha,Cdw_lin(:,2), 'r--');
plot(alpha,Cdw_lin(:,3), 'g--');
plot(alpha,Cdw_lin(:,4), 'm--');

legend('Mach: 2 ','Mach: 3','Mach: 4','Mach: 5','Mach: 2 Linear','Mach: 3 Linear','Mach: 4 Linear','Mach: 5 Linear','AutoUpdate','off')

xlabel("Angle Of Attack (degrees)")
ylabel("Coefficent of Drag")
title("Coefficent of Drag vs Angle of Attack at Variating Mach Numbers with both Linear and Shock-Expansion Theory");

