%By Brian Trybus 2-14-2021
%Used to get flight proformace of model glider consept
%Design note: Designed for a reynolds number of 80,000 at a speed of 7m/s
%Highwing twinboon
%7m launch 1.5km standard
%% Constans and enviromnt

rhoFoam = 0.295; %kg/m^2
massCam = 0.160; %kg
rho = 1.0581;%kg/m^3
hight = 7;%m


%% Define plane

%sWet = 0.330646; %m^2
b = 347; %mm
c = 147.14; %mm
sWet = (3.28*b*c)+(4*b*sqrt((0.0324*(c^2))+(9)))+(1.2*b)+(134.92*c)+(72*sqrt((c^2)-(144*c)+7888))+31650; %mm^2
sWet = sWet/1000000; %mm^2 to m^2
sMass = ((22520+72*((sqrt(((c-72)^2)+2704))+c))+(2*b*c))/1000000;%m^2 About how much foam we will need, so only counting the top of the wing type deal.
sRef = (b*c*2)/1000000; %m^2
massDry = (sMass*rhoFoam)+0.00377; %The 2 dowels should add about 3.77 grams
mass = massDry + massCam; %kg
AR = (((b/1000)*2)^2)/sRef;
Cfe = 0.0055; %Quick estamte look for better
e = 0.7; %Rectangular wing with no taper
e0 = 1.78*(1-(0.045*AR^0.68))-0.64;

%C = 2b/AR


%% Import wing data

Foil = xlsread('FlatPlateRe80,000.xlsx', 'A1:C9');

aoa = Foil(:,1);
Cl = Foil(:,2);
Cd = Foil(:,3);

%% Calculate flight proformance

[~,~,CL] = convert2dFoilTo3dWing(aoa,Cd,Cl,AR,e,1,9);

[CL_extented,WholeAircraftDrag] = wholeCraftDrag(Cd,CL,AR,e,e0,sWet,sRef,Cfe,1,9,0.01,aoa);

weight = mass * 9.81;

[range,vRangeMax,endurance,~] = glideRange(WholeAircraftDrag,weight,sRef,rho,hight,e0,AR);


%% Make plots
figure(1);
    plot(aoa,Cl,'r-o',aoa,CL,'b');
    title('2D vs 3D Flat Plate Lift');
    legend('2D Lift', '3D Lift');
    xlabel('Angle of Attack');
    ylabel('Coeffisent of Lift');
    hold off;
    
figure(2);
    plot(CL_extented,WholeAircraftDrag);
    title('Drag Polar for Glider');
    xlabel('Coefficent of Lift');
    ylabel('Coefficent of Drag');
    
    