%Use a computer to plot a graph (all plots 
%on same axes) of flyby bending angle as a function of V_?  for planetary flybys of Mercury, Venus, Earth, Mars, Jupiter, and Saturn assuming the flyby periapsis has an altitude of 1000 km.

mu = [2.203*(10^4),3.249*(10^5),3.986*(10^5),4.283*(10^4),1.267*(10^8),3.793*(10^7)]; %Mu in km^3s^-2
planet = ["Mercury","Venus","Earth","Mars","Jupiter","Saturn"];
Rp = 1000; %km
delta = zeros(6,201);

for i = 1:6 
    
    for j = 1:250
        delta(i,(j)) = 2*asind(1/((1/mu(i))*((Rp*((j^2)+((2*mu(i))/Rp)))-mu(i))));
        %1/((1/mu(i))*((Rp*((j^2)+((2*mu(i))/Rp)))-mu(i)))
    end
    plot(delta(i,:));
    hold on
end
title("Flyby Bending Angle vs Excess Speed By Planet");
xlabel("Excess Speed (km/s)");
ylabel("Flyby Bending Angle (degrees)");
legend(planet);