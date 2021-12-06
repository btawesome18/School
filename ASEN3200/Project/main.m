%Megaconstellation Design Code
%By Brian Trybus
%11/29/2021

%% Define Constants

MU = 3.986*(10^5);

J2 = 1.087*(10^-3);

Re = 6378;

elevation_limit = 15*(pi/180); 


%% Import data
%Load in satellites
[num_launches, num_spacecraft, satellite_list] = loadConstellation("example_constellation.json"); 
%Load coast and convert to rad
load("world_coastline_low.txt") 
xCoast = world_coastline_low(:,1)*(pi/180);
yCoast = world_coastline_low(:,2)*(pi/180);

%Load citys in
citys = readtable("worldcities.csv");

%Allow for loading less citys if ':' is replaced with a number
citysOfWorthC = (citys(1:30,3:4));
citysOfWorth = zeros(size(citysOfWorthC));

%Convert city possitions to rad then to 3d cords.
for i = 1:height(citysOfWorthC)
    citysOfWorthX = str2double(citysOfWorthC(i,1).lat{1})*(pi/180); %Reading in the csv needed lots of handeling and to be casted to double.
    citysOfWorthY = str2double(citysOfWorthC(i,2).lng{1})*(pi/180);
    [Cx(i),Cy(i),Cz(i)]=sph2cart(citysOfWorthY,citysOfWorthX,Re);
end

%% Plot world map

%Convert coast to 3d cords
[cx,cy,cz]=sph2cart(xCoast,yCoast,Re);

%Plot a sphere for the earth
[sx,sy,sz] = sphere(40);
s=surf(sx*Re,sy*Re,sz*Re);
%Make it blue for the sea
s.EdgeColor = 'none';
s.FaceColor = '#006994';
hold on %Hold on all parts will be ploted on this figure

%Plot the coast lines in black
plot3(cx,cy,cz,'k') 
%Plot the citys as red dots
scatter3(Cx,Cy,Cz,'r.') 
title("Constellation Traces over Earth with Major Citys")



%% Propagate orbits

t_0=0; %Setting epoch time.

t = 0:30:86400;%We will run every 30 seconds over a day

lengthT = length(t); %Reduce function calls for speed
satTime = zeros(height(citysOfWorthC),lengthT);
x=zeros(6,lengthT);
for i = 1:length(satellite_list) %Other loop cover each satellite
    
    oe0 = satellite_list(i).oe0; %orbital info from sat i
    
    for j = 1:lengthT % second loop covers time
        
        x(1:6,j) = propagateState(oe0,t(j),t_0,MU,J2,Re); %Propagates the orbit of satellite i for time j.
        
        for k = 1:height(citysOfWorthC) %third loop covers citys, 
            
            r_site = [Cx(k);Cy(k);Cz(k)]; %Possition of city k
            
            if(testLoS(r_site,x(1:3,j),elevation_limit)) %testing if city k has sight of sat i at time j
                
                satTime(k,j) = satTime(k,j)+1;%If sat i is over city k at time j then add 1
                
            end
            
        end
        
    end

    plot3(x(1,:),x(2,:),x(3,:)); % After running the orbit for a day it will plot the path of the current sat i.
    
end

%satTime has amount of coverage in terms of satTime(city,time) time indexes
