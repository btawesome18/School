%By Brian Trybus
%04/2/2022
%Computatinal assignment 3
%Collaborators: Cannon Palmer, Sophia Trissell


close all
clear
clc

%% Problem 1
%Test NACA 0012, NACA 2412, and NACA 4412
% N found from CA2 is 86 panels total 43 per surface.

disp("Problem 1");

%Alpha sweep setup
ClAlphaArry = zeros(4,101);
ClAlphaArry(1,:) = linspace(-30,30,101);

%Declaire NACA foils to be used
mNACA = [0,.02,.04];
pNACA = [0,.4,.4];
t = 0.12;
N=43; %Panels to be used
c = 2; %Same V inf as CA 2
V_inf = 60; %Same V inf as CA 2 Testing not normaly 60

for i = 1:3 %Cycle though NACA foils
    %Get NACA numbers for this run
    m = mNACA(i);
    p = pNACA(i);

    %Make wing shape
    [x,y,aLo(i),dCLda(i)] = NACA_Airfoils(m,p,t,c,N);

    for j = 1:101 %Sweep angles to get cl vs aoa plot
        %calculate Lift of given wing shape
        [ClCur,~,~,~,~] = Vortex_Panel(x,y,V_inf,ClAlphaArry(1,j),0);
        %Add Lift to arry for graphing
        ClAlphaArry(i+1,j) = ClCur;
    end

    p = polyfit(ClAlphaArry(1,36:66),ClAlphaArry(i+1,36:66),1);
    LiftSlope(i) = -p(1);

    [~,ZeroLiftAoAi(i)] = min(abs(ClAlphaArry(i+1,:)));
    ZeroLiftAoA(i) = ClAlphaArry(1,ZeroLiftAoAi(i));

end



figure(1);
hold on
plot(-ClAlphaArry(1,:),ClAlphaArry(2,:));
plot(-ClAlphaArry(1,:),ClAlphaArry(3,:));
plot(-ClAlphaArry(1,:),ClAlphaArry(4,:));
legend(["NACA 0012","NACA 2412","NACA 4412"])
xline(0,'HandleVisibility','off');
yline(0,'HandleVisibility','off');
title("Cl vs Angle of Attack");
xlabel("Angle of Attack (deg)");
ylabel("Coefficant of Lift");


fprintf("From CA2 for 1 percent error an N of 86 panels is used. \n");

fprintf("For the NACA 0012: \n Thin line approximation gave: Zero Lift Angle of Attack: %f (degrees), Lift Slope of: %f (1/rad)" + ...
    " \n Vortex Panel gave: Zero Lift Angle of Attack: %f (degrees), Lift Slope of: %f (1/rad) \n \n",aLo(1),dCLda(1),-ZeroLiftAoA(1),(180/pi)*LiftSlope(1));

fprintf("For the NACA 2412: \n Thin line approximation gave: Zero Lift Angle of Attack: %f (degrees), Lift Slope of: %f (1/rad)" + ...
    " \n Vortex Panel gave: Zero Lift Angle of Attack: %f (degrees), Lift Slope of: %f (1/rad) \n \n",aLo(2),dCLda(2),-ZeroLiftAoA(2),(180/pi)*LiftSlope(2));

fprintf("For the NACA 4412: \n Thin line approximation gave: Zero Lift Angle of Attack: %f (degrees), Lift Slope of: %f (1/rad)" + ...
    " \n Vortex Panel gave: Zero Lift Angle of Attack: %f (degrees), Lift Slope of: %f (1/rad) \n \n",aLo(3),dCLda(3),-ZeroLiftAoA(3),(180/pi)*LiftSlope(3));

fprintf("Note the Zero Lift Angle of Attack for the thin approx and the vortex panel both arived at the same angle but the Lift Slopes did not. This is due to an error in my code giveing much lower lift out of the vortex panel then expected.\n\n\n")

%% Problem 2

disp("Problem 2");

 N = 2;
%Wing peramiters
c_t = 3+(8.5/12);
c_r = 5+(4/12);
b = 33+(4/12);
geo_r = 1;
geo_t = 0;
aero_r = ZeroLiftAoA(2);
aero_t = ZeroLiftAoA(1); %LiftSlope
a0_r = 2*pi; %LiftSlope(2);
a0_t = 2*pi; %LiftSlope(1);
S = b*(c_r+c_t)/2;%Area

[~,c_L_Ver,c_Di_Ver] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,1000);
[e,c_L,c_Di] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N);
%Flight Conditions at 82knot cruise 10,000ft
v_inf = 138.4; %Feet/s
T_inf = 483.04; %R
p_inf = 1.4556; %lb/ft^2
rho_inf = 1.7556*(10^-3); %slug/ft^3

%Calculate lift and drag in units
q = (1/2)*rho_inf*(v_inf^2);

% Setup Error bounds

%Values calculated at N = 10000
% c_L_Ver = -0.0475020308697265;
% c_Di_Ver = 0.000195208879892737;
%Loop tell it is withen error with stepped error bounds
while( (abs((c_L-c_L_Ver)/c_L_Ver)>0.1)&&(abs((c_Di-c_Di_Ver)/c_Di_Ver)>0.1) )   
    N = N+1;
    [e,c_L,c_Di] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N);
    
end
c_L10p = c_L;
c_Di10p = c_Di;
N10 = N;

while( (abs((c_L-c_L_Ver)/c_L_Ver)>0.01)&&(abs((c_Di-c_Di_Ver)/c_Di_Ver)>0.01) )   
    N = N+1;
    [e,c_L,c_Di] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N);
    
end
c_L1p = c_L;
c_Di1p = c_Di;
N1 = N;

while( (abs((c_L-c_L_Ver)/c_L_Ver)>0.001)&&(abs((c_Di-c_Di_Ver)/c_Di_Ver)>0.001) )   
    N = N+1;
    [e,c_L,c_Di] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N);
    
end
c_L01p = c_L;
c_Di01p = c_Di;
N01 = N;

L = c_L*q*S;
Di = c_Di*q*S;

fprintf("For 10 percent error only %i odd terms are needed. \nYielding: Lift = %f(lb), and Drag = %f(lb) \n\n",N10,-c_L10p*q*S,c_Di10p*q*S);
fprintf("For 1 percent error only %i odd terms are needed. \nYielding: Lift = %f(lb), and Drag(l) = %f(lb) \n\n",N1,-c_L1p*q*S,c_Di1p*q*S);
fprintf("For 0.1 percent error only %i odd terms are needed. \nYielding: Lift = %f(lb), and Drag = %f(lb) \n\n",N01,-c_L01p*q*S,c_Di01p*q*S);

%% Problem 3

disp("Problem 3");

%Constants for wing:
N =20;
AR_vec = [4,6,8,10];
taperVec = linspace(0.01,1,1000);
c_r = 10;
%Pre allocate mem
eMet = zeros(4,1000);

%Loop through for all ARs and tappers.
for i= 1:4
    AR = AR_vec(i);
    for j = 1:1000
        c_t = taperVec(j)*c_r; %Chord Tip
        b =AR*(c_t+c_r)/2;%span
        %PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N)
        [eMet(i,j),~,~] = PLLT(b,2*pi,2*pi,c_t,c_r,0,0,1,1,N);
    end
end
figure(2)
hold on;
plot(taperVec,eMet(1,:))
plot(taperVec,eMet(2,:))
plot(taperVec,eMet(3,:))
plot(taperVec,eMet(4,:))
title("Thin Airfoil: Span Efficancy Vs Taper Ratio")
xlabel("Taper Ratio");
ylabel("Span Efficancy")
%Zoom to fix cleaner section
figure(3)
hold on;
plot(taperVec,eMet(1,:))
plot(taperVec,eMet(2,:))
plot(taperVec,eMet(3,:))
plot(taperVec,eMet(4,:))
title("Thin Airfoil: Span Efficancy Vs Taper Ratio")
xlabel("Taper Ratio");
ylabel("Span Efficancy")
xlim([0.4,1]);


fprintf("There is an error I could not solve that shifted the plot to the right, if the plot is cropped then the graph shows the expected curve(figure 3).\nThis is likely due to an error in calculating wing geometry or fourier values.");