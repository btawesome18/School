% ASEN 3200 - Design Project Part 1
% Tuesday
% Author: Ashwin Raju


%% Housekeeping
clc;
clear;
close all;

%% Constants
G = 6.6743015*10^(-20); 
me = 5.97129*10^(24);
MU = G*me;
J2 = 1.087 * 10^(-3); 
t = 0:30:(24*60*60);
t0 = 0;
rEarth = 6378.1;
omegaEarth = -2*pi/(23*3600 + 56*60 + 4.1);
elevation_limit = 15; %deg

%% Load Data
[num_launches, num_spacecraft, satellite_list, data] = loadConstellation('Constilation7L8.json');
cityData = readtable('worldcities.csv');
%cities = table2cell(cityData(:,1));
cityData = cityData(:,[4 3 10]); % only look at long,latt,population
coastData = load('world_coastline_low.txt');

% change numCities variable to 'height(cityData)' if you want to see all
% cities
numCities = 500;%height(cityData); % number of cities to analyze (height(cityData is all cities)
usefulCityData = table2array(cityData(1:numCities,:));

long = deg2rad(usefulCityData(:,1));
latt = deg2rad(usefulCityData(:,2));
pop = usefulCityData(:,3);
r_site = rEarth*[sin(latt), cos(latt).*sin(long), cos(latt).*cos(long)];

%% Plot Earth 

figure; 
[x,y,z] = sphere;
x = rEarth*x;
y = rEarth*y;
z = rEarth*z;

surf(x,y,z,'facecolor','w','LineWidth',.05);

hold on;
[xCoast,yCoast,zCoast] = sph2cart(deg2rad(coastData(:,1)),deg2rad(coastData(:,2)),rEarth);
plot3(xCoast,yCoast,zCoast,'k');


[xCities,yCities,zCities] = sph2cart(deg2rad(usefulCityData(:,1)),deg2rad(usefulCityData(:,2)),rEarth);
scatter3(xCities,yCities,zCities,1+10^(-7)*usefulCityData(:,3),usefulCityData(:,3),'filled');
c = colorbar;
c.Label.String = "Population";
caxis([min(usefulCityData(:,3)) max(usefulCityData(:,3))])
colormap jet


%% Propogate & Plot Orbit
numInLoS = zeros(length(t),numCities);

%loop to iterate through each spacecraft
for o = 1:num_spacecraft
    oe = satellite_list(o).oe0;
    x = ones(6,length(t));
    inLine = zeros(length(t),numCities);
    
    % loop to iterate through time
    for i = 1:length(t)   
        propogated = propagateState(oe,t(i),t0,MU,J2,rEarth);
        x(1,i) = propogated(1);
        x(2,i) = propogated(2);
        x(3,i) = propogated(3);
        x(4,i) = propogated(4);
        x(5,i) = propogated(5);
        x(6,i) = propogated(6);
        r_sc = x(1:3,i);
        
        % loop to iterate through each analyzed city
        for k = 1:numCities
            long = deg2rad(usefulCityData(k,1));
            latt = deg2rad(usefulCityData(k,2));
            long = long + omegaEarth*(t(i)-t0);
            r_site = rEarth*[sin(latt), cos(latt)*sin(long), cos(latt)*cos(long)]'; % radius of city in ECI
%             r_site = [xCities(k);yCities(k);zCities(k)];
            inLine(i,k) = testLoS(r_site,r_sc,elevation_limit);
    %         if inLine(i,k) == 1
    %             plot3(r_site(1),r_site(2),r_site(3),'g');
    %         else 
    %             plot3(r_site(1),r_site(2),r_site(3),'r');
    %         end
        end
        %numInLoS(i) = numInLoS(i) + nnz(inLine(i,:));
        numInLoS(i,:) = numInLoS(i,:) + inLine(i,:); % Matrix of num SC seen by each analyzed city at t
    end
    plot3(x(1,:),x(2,:),x(3,:));
end
hold off

totInLoS = sum(numInLoS,2);
figure;
plot(t,totInLoS);


%% Test Case
% J2=1082.63*10^(-6);
% Re=6378.137;%km
% MU=398600;
% a=7000;
% e=.887;
% i=0;
% Om=pi;
% om=0;
% f=0;
% oe0=[a,e,i,Om,om,f];
% x=propagateState(oe0,1000,0,MU,J2,Re)

%% Functions
%% Load JSON file
function [num_launches, num_spacecraft, satellite_list, data] = loadConstellation(filename)
%DESCRIPTOIN: Ingests constellation description .json file and parses it
%into a list of structs with full initial orbit elements (km, s, rad) and
%satellite name.
%
%INPUTS:
% filename      A string indicating the name of the .json file to be parsed
%
%OUTPUTS:
% nl            Number of total launches
% ns            Total number of spacecraft between all launches
% satlist       Array of structs with 'name' and 'oe0' properties

    num_launches = 0;
    num_spacecraft = 0;
    satellite_list.name = '';
    satellite_list.oe0 = NaN(6,1);

    %1) extract the constellation structure from the json file
    data = jsondecode(fileread(filename));

    %2) read all of the launches and payloads to understand how many launches
    % and spacecraft are in the constellation; note, this will be useful in
    % Part 2!
    [num_launches, ~] =  size(data.launches);
    %loop to iterate through all launch.payload structs
    for i = 1:num_launches
        [spacecraftPerLaunch,~] = size(data.launches(i).payload);
        num_spacecraft = num_spacecraft + spacecraftPerLaunch;
    end   
    clear i
    %3) RECOMMENDED: Pre-allocate the satellite_list struct
    satellite_list(num_spacecraft).name = '';
    satellite_list(num_spacecraft).oe0 = NaN(6,1);

    %4) Populate each entry in the satellite struct list with its name and
    %initial orbit elements [a,e,i,Om,om,f] at time t0
    idx = 1;
    for i = 1:num_launches
        a = data.launches(i).orbit.a;
        e = data.launches(i).orbit.e;
        inclination = data.launches(i).orbit.i;
        Om = data.launches(i).orbit.Om;
        om = data.launches(i).orbit.om;
        
        [spacecraftPerLaunch,~] = size(data.launches(i).payload);
        for k = 1:spacecraftPerLaunch
            f = data.launches(i).payload(k).f;
            oe0 = [a,e,inclination,Om,om,f]';
            satellite_list(idx).name = data.launches(i).payload(k).name;
            satellite_list(idx).oe0 = oe0;
            idx = idx+1;
        end
    end   
end

%% Propogate Orbit Elements
function x = propagateState(oe0,t,t0,MU,J2,rEarth)
%DESCRIPTION: Computes the propagated position and velocity in km, km/s
%accounting for approximate J2 perturbations
%
%INPUTS:
% oe0       Orbit elements [a,e,i,Om,om,f] at time t0 (km,s,rad)
% t         Current time (s)
% t0        Time at the initial epoch (s)
% MU        Central body's gravitational constant (km^3/s^2)
% J2        Central body's J2 parameter (dimensionless)
% Re        Radius of central body (km)
%
%OUTPUTS:
% x         Position and velocity vectors of the form [r; rdot] (6x1) at
%             time t

    %1) Compute the mean orbit elements oe(t) at time t due to J2 perturbations
    a = oe0(1);
    e = oe0(2);
    i = oe0(3);
    n = sqrt(MU/a^3);
    p = a*(1-e^2);
    
    % calculate change in big and little omega
    Om_dot = (-3/2)*n*J2*cos(i)*(rEarth/p)^2;
    om_dot = (3/2)*n*J2*((rEarth/p)^2)*(2-(5/2)*sin(i)^2);
    
    Om = (t-t0)*Om_dot + oe0(4); %Om at time t
    om = (t-t0)*om_dot + oe0(5); %om at time t
    
    
    %2) Solve the time-of-flight problem to compute the true anomaly at time t
    f0 = oe0(6);
    E0 = 2*atan(sqrt((1-e)/(1+e))*tan(f0/2));
    M0 = E0 - e*sin(E0);
    M = M0 + n*(t-t0); % 1/n(t-t0) (to account for tp)
    E = M; %initial guess for E
    
    % Newtons Method to find f at time t
    ratio = 1;
    error = 10^(-9);  
    while abs(ratio) > error
        ratio = (E - e*sin(E) - M)/(1 - e*cos(E));
        E = E - ratio;
    end
    f = 2*atan(sqrt((1+e)/(1-e))*tan(E/2));

    %3) Compute r(t), rdot(t) in the perifocal frame
    rMag = p/(1+e*cos(f));
    r_P = rMag*[cos(f);sin(f);0];
    rDot_P = sqrt(MU/p)*[-sin(f);e+cos(f);0];
    
    %4) Compute r(t), rdot(t) in the ECI frame, save into x
    PN = [cos(om)*cos(Om)-sin(om)*cos(i)*sin(Om), cos(om)*sin(Om)+sin(om)*cos(i)*cos(Om), sin(om)*sin(i); -sin(om)*cos(Om)-cos(om)*cos(i)*sin(Om), -sin(om)*sin(Om)+cos(om)*cos(i)*cos(Om), cos(om)*sin(i); sin(i)*sin(Om), -sin(i)*cos(Om), cos(i)];
    NP = PN'; % DCM for perifocal to ECI
    r_N = NP*r_P;
    rDot_N = NP*rDot_P;
    x = [r_N;rDot_N];
    
end

%% Determine if in Line of Sight Exists
function inLoS = testLoS(r_site,r_sc,elevation_limit)
%DESCRIPTION: Determines whether the spacecraft is within line-of-sight
%(LoS) of the site given an elevation limit
%
%INPUT:
% r_site            The position vector of the site (km, 3x1)
% r_sc              The position vector of the spacecraft (km, 3x1)
% elevation_limit   Lower elevation limit (above the horizon) (rad)
%
%OUTPUT: 
% inLoS             A boolean flag (0 or 1); 1 indicates the spacecraft and
%                   the site have line-of-sight
    
    %1) Compute whether the site and spacecraft have line of sight (hint, I
    %suggest drawing a picture and writing this constraint as an inequality
    %using a dot product)
    rij = r_sc - r_site; % vector between the site & sc (in ECI) 
    dp = dot(rij,r_site)/(norm(rij)*norm(r_site));
    theta = acosd(dp); % angle between rij and ri   
    
    % check if angle is within bounds
    if theta <= 90 - elevation_limit
        inLoS = 1;
    else
        inLoS = 0;
    end
   
end
