%Balloon anaylsis


%Starting properties to test diffent meticals edit this part.
m_pay = 500; %Kg
factorS = 1.5; %Guess based off low risk mission
targetAlt = 25000; %meter
gravity = 9.8; %m/s^2


%meterial properties
tensile = 214000000; %Pa
p_mat = 1400; %kg/m^3

%Gas props
Rloon = 2077; %J/(KgK) %Gas constant for He

%Air props
Rair = 287; %J/(KgK)

%Standard atmo stuff


%TO DO
%P=pRT
%dP/dh = -pg at surface
%P = -pgh
%dT/dh=a
%Temp =  216K at 25km
temp = 216; %K
%densitySea = 1.225;
%pressureSea = 101325; %pascals
%pressureAlt = pressureSea - densitySea*gravity*targetAlt;
%densityAlt = pressureAlt/(Rair*temp);
%Using for testing https://www.digitaldutch.com/atmoscalc/
p_air=  0.04008; %kg/meter cubed
pressureAlt = 2511.02;


%vars used in code
radius =0;
P_gage =10;



%Equations

%wallThick = factorS*(pressureG*r/(2*tensile))
sigmaT = tensile;

%Gas stuff
p_He = pressureAlt/(Rloon*temp);

radius = (((m_pay)/(((p_air*(4/3)*pi)-(4*pi*p_mat)*((factorS*P_gage)/(2*sigmaT)))-(((p_He*(4/3)*pi)))))^(1/3));

wallThickness = factorS*((P_gage*radius)/(2*tensile));

volume = (4/3)*pi*(radius^3);

mass_He = p_He * volume;
mass_mat = (4*pi*(radius^2))*wallThickness*p_mat;
%Radiation and Altitude from day night

S_sb = 5.670*(10^-8); %j/((kg^4)*(m^2)*s)
a_sb = .6;
e_b = .8;
a_eb = e_b;
qSun = 1353; %w/m^2
qEarth = 237; %w/m^2

%day
t_day = (((a_sb*qSun)+(a_eb*qEarth))/(4*e_b*S_sb))^(1/4);

volume_day = (Rloon*t_day*mass_He)/pressureAlt;

density_day = (m_pay+mass_He+mass_mat)/volume_day;

dayAlt = 26400;

p_He_Day = pressureAlt/(Rloon*t_day);

radiusDay = (((m_pay)/(((p_air*(4/3)*pi)-(4*pi*p_mat)*((factorS*P_gage)/(2*sigmaT)))-(((p_He_Day*(4/3)*pi)))))^(1/3));


%night
t_night = (((a_eb*qEarth))/(4*e_b*S_sb))^(1/4);

volume_night = (Rloon*t_night*mass_He)/pressureAlt;

density_night = (m_pay+mass_He+mass_mat)/volume_night;

nightAlt = 23700;

p_He_Night = pressureAlt/(Rloon*t_night);

radiusNight = (((m_pay)/(((p_air*(4/3)*pi)-(4*pi*p_mat)*((factorS*P_gage)/(2*sigmaT)))-(((p_He_Night*(4/3)*pi)))))^(1/3));

h = 20000:1000:30000;

[~,~,~,rho] = atmosisa(h);


%Altitude Control gas lost

volumeVented = ((4*pi)/3)* ((radiusNight^3)-(radiusDay^3))


