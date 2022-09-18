%By Brian Trybus
%2/24/2022
%Computatinal assignment 2

close all
clear
clc

%Use the same defult c, alpha, p_inf, V_inf, and rho_inf for all 3 problems
c =2;
V_inf = 60;
p_inf = 85.5*(10^3);
rho_inf = 1;
alpha = 9;


%% Problem 1

disp("Problem 1");
%Fig 1
PlotThinAirfoil(c,alpha,V_inf,p_inf,rho_inf,3);
%Fig 2
PlotThinAirfoil(c,alpha,V_inf,p_inf,rho_inf,50);

fprintf("Figure 1 shows a course approximation with only 3 panels vs Figure 2 shows a 50 panel approximation with much greater detail.\n");
fprintf("The effect of the higher detail is best seen in the diffrance in pressure contours in the third subplot of each figure.");


%% Problem 2

disp("Problem 2");
%Fig 3
PlotThickAirfoil(2,9,60,(85.5*(10^3)),1,3);
%Fig 4
PlotThickAirfoil(2,9,60,(85.5*(10^3)),1,50);

fprintf("Figure 3 shows a course approximation with only 6 panels vs Figure 4 shows a 100 panel approximation with much greater detail.\n");
fprintf("The effect of the higher detail is best seen in the diffrance in pressure contours in the third subplot of each figure.");

%% Problem 3

disp("Problem 3");

%Declaire Peramiters for run first

%Alpha sweep setup
ClAlphaArry = zeros(4,101);
ClAlphaArry(1,:)=linspace(-40,40,101);

%Range of thickness to test
NacaThickArry = [0.06,0.12,0.24];

%Varification data run at N = 1000
Varification = [-1.03133113301090,-1.08069233062309,-1.18158388556835];

%define naca curve
yt = @(x,Thickness) ((Thickness *c)/0.2)*(  (0.2969*(sqrt(x/c))) - (0.126*(x/c)) - (0.3516*((x/c).^2)) + (0.2843*((x/c).^3)) - (0.1036*((x/c).^4)) );

%Loops the 3 airfoils for resolution study.
for i = 1:3

    % Reset accumlators
    N = 3;
    ClCur =0;
    clear ClNArry;


    %Starting at 6 panels increases tell error is within 1%
    while( (abs((ClCur-Varification(i))/Varification(i))>0.01) )    
        
        %Make wing shape
        XB = zeros(1,2*N-1);
        XB(1,1:N) = linspace(0,c,N);
        XB(1,N:end) = linspace(c,0,N);
        YB = [yt(XB(1,1:N),NacaThickArry(i)),-yt(XB(1,N+1:end),NacaThickArry(i))];

        %calculate Lift of given wing shape
        [ClCur,~,~,~,~] = Vortex_Panel(XB,YB,V_inf,alpha,0);
        
        %Add Lift to arry for graphing
        ClNArry(N-2) = ClCur;

        %Increase Number of panels for next loop
        N = N+1;
        
    end
    
    %Save vectors in cell arry for later display
    ClNCellArry{i} = ClNArry;
    ClConverg(i) = ClCur;

    N = N-1;

    Narry(i) = N;
    %Calculate Lift vs Alpha
    for j = 1:101
            %Make wing shape
        XB = zeros(1,2*N-1);
        XB(1,1:N) = linspace(0,c,N);
        XB(1,N:end) = linspace(c,0,N);
        YB = [yt(XB(1,1:N),NacaThickArry(i)),-yt(XB(1,N+1:end),NacaThickArry(i))];

        %calculate Lift of given wing shape
        [ClCur,~,~,~,~] = Vortex_Panel(XB,YB,V_inf,ClAlphaArry(1,j),0);
        
        %Add Lift to arry for graphing
        ClAlphaArry(i+1,j) = ClCur;

    end
    
    %Use PolyFit to find lift slope
    p = polyfit(ClAlphaArry(1,36:66),ClAlphaArry(i+1,36:66),1);
    LiftSlope(i) = p(1);

    [~,ZeroLiftAoAi(i)] = min(abs(ClAlphaArry(i+1,:)));
    ZeroLiftAoA(i) = ClAlphaArry(1,ZeroLiftAoAi(i));

end

fprintf("Number of panels required for 1%% error: \nNACA 0006: Panels: %d,  Lift Coefficient: %f\nNACA 0012: Panels: %d,  Lift Coefficient: %f\nNACA 0024: Panels: %d,  Lift Coefficient: %f\n\n",Narry(1)*2,ClConverg(1),Narry(2)*2,ClConverg(2),Narry(3)*2,ClConverg(3));

fprintf("Lift Slope and Zero Lift Angle of Attack: \nNACA 0006: Lift Slope: %f (Cl/degree), Zero Lift Angle of Attack: %f (degree)\nNACA 0012: Lift Slope: %f (Cl/degree), Zero Lift Angle of Attack: %f (degree)\nNACA 0024: Lift Slope: %f (Cl/degree), Zero Lift Angle of Attack: %f (degree)\n",LiftSlope(1),ZeroLiftAoA(1),LiftSlope(2),ZeroLiftAoA(2),LiftSlope(3),ZeroLiftAoA(3))
fprintf("The Thick airfoils all had a greater Lift Slope then the thin wing approximation of -0.109662 (Cl/degree)\n");
%% Plots for Problem 3

figure();
hold on

NacaXX06 = ClNCellArry{1};
NacaXX12 = ClNCellArry{2};
NacaXX24 = ClNCellArry{3};

plot((linspace(6,(length(NacaXX06)*2)+6,length(NacaXX06))),NacaXX06);
plot((linspace(6,(length(NacaXX12)*2)+6,length(NacaXX12))),NacaXX12);
plot((linspace(6,(length(NacaXX24)*2)+6,length(NacaXX24))),NacaXX24);

legnedVec = ["NACA 0006","NACA 0012","NACA 0024"];

legend(legnedVec);

xlabel("Number of Panels (N)");
ylabel("Coefficent of Lift (Cl)");
title("Coefficent of lift vs Number of Panels for Airfoils of Varing Thickness");

hold off;
% yline(Varification(1));
% yline(Varification(2));
% yline(Varification(3));

figure();
hold on

plot(ClAlphaArry(1,:),ClAlphaArry(2,:));
plot(ClAlphaArry(1,:),ClAlphaArry(3,:));
plot(ClAlphaArry(1,:),ClAlphaArry(4,:));
plot(ClAlphaArry(1,:),ClAlphaArry(1,:)*-0.109662271123);

title("Coefficent of Lift vs Angle of Attack for Airfoils of Varing Thickness");
ylabel("Coefficent of Lift (Cl)");
xlabel("Angle of Attack (degrees)");

legnedVec(4) = "Thin Wing Aprox";
legend(legnedVec);


