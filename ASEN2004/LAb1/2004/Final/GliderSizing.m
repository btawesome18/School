%By Brian Trybus 2-22-2021
%Used to get flight proformace of model glider consept and ajust wing-loading
%Design note: Designed for a reynolds number of 80,000 at a speed of 7m/s
%Highwing twinboon
%7m launch 1.5km standard

clear all
close all


%% TODO 


%ASK ABOUT MAX CL


%% Constans and enviromnt

rhoFoam = 0.295; %kg/m^2
massCam = 0.160; %kg
rho = 1.0581;%kg/m^3
hight = 7;%m

%sWet = 0.330646; %m^2
b = 400; %mm
c = 165; %mm
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

%c = 2b/AR


%% Import wing data

Foil = xlsread('FlatPlateRe80,000.xlsx', 'A1:C9');

aoa = Foil(:,1);
Cl = Foil(:,2);
Cd = Foil(:,3);


%% Iderate through wingspans
    

    for b = 150:600
        
        gliderData(b-99) = sizingProformance(b,Foil,AR,e,e0,Cfe,rho,hight,massCam,rhoFoam);
        
    end

%% Graphs

weight = [gliderData.weight];
wingArea = [gliderData.sref];
wingloading = weight./wingArea;

figure(1);
tiledlayout(2,3)
nexttile
hold on
title('Max R & CL Req vs W/S');
ylabel('Range (m)');
yyaxis left
plot(wingloading,[gliderData.range]);
%yline(70);
xline(20);
yyaxis right 
ylabel('Coefficent of Lift');
plot(wingloading,[gliderData.CLrange]);
legend('Glide Range','CL Needed');
xlabel('Wing Loading (N/m^2)');
xline(20);
hold off;

nexttile
hold on
title('Max E & CL Req vs W/S');
yyaxis left
ylabel('Endurace (seconds)');
plot(wingloading,[gliderData.enduranceTime]);
yline(7);
yyaxis right 
ylabel('Coefficent of Lift');
plot(wingloading,[gliderData.CLendurance]);
legend('Glide Time','Required Time','CL Needed');
xlabel('Wing Loading (N/m^2)');
xline(20);
hold off;

nexttile
hold on
title('Vel Req for Max R & Max E');
plot(wingloading,([gliderData.endurance]));
plot(wingloading,([gliderData.vRangeMax]));
plot(wingloading,([gliderData.vStall]),'--r');
xlabel('Wing Loading (N/m^2)');
ylabel('Velocity (m/s)');
legend('Max Endurace','Max Range','Stall');
xline(20);
hold off

nexttile
hold on
title('Variation of Aircraft Weight with Wing Loading');
plot(wingloading,[gliderData.weight]);
ylabel('Weight (N)');
xlabel('Wing Loading (N/m^2)');
xline(20);
hold off

nexttile
hold on
title('Variation of Wing Geometry with Constant AR and Taper');
yline(1000);
yyaxis left
ylabel('Length (mm)');
plot(wingloading,(([gliderData.winglength]*2)+72));
plot(wingloading,(0.25*([gliderData.winglength]*2)./AR));
yyaxis right 
ylabel('Aera (m^2)');
plot(wingloading,[gliderData.sref]);
xlabel('Wing Loading (N/m^2)');
legend('Wing Span','Wing Area','Mean Cord');
xline(20);
hold off;

nexttile
hold on
title('Variation of Aircraft Cost with Wing Loading');
plot(wingloading,([gliderData.massDry].*1000));
ylabel('Cost ($)');
xlabel('Wing Loading (N/m^2)');
xline(20);
hold off

[~,index] = min((wingloading-20).^2);

gliderData(index).massDry
gliderData(index).winglength
gliderData(index).range

%ASK ABOUT MAX CL