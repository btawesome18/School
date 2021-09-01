function w = Method4(M,M0,B,anglet,R,I,g,moment,r,m,k,r0)


B = B*(pi/180);

%h = sind(B)*r*anglet;
h = sind(B)*R*anglet;

%num = ((M+M0)*g*h)+(((r*cosd(5.5))-(r*cos(B+anglet))+h+R)*(g*m))+(2*moment*anglet);

%num = 2*(((M+M0)*g*h)+R+h+(m*g*((r*cosd(5.5))-(r*cos(B+anglet))))+(moment*anglet));

%num = 2*(((M+M0)*g*h)+(h*m*g)+(m*g*((r*cosd(5.5))-(r*cos(B+anglet))))+(moment*anglet));

num = 2*(((M+M0)*g*h)+(h*m*g)+(m*g*r*(cosd(5.5)-(cos(B+anglet))))+(moment*anglet));

%V = ((R^2)*(cosd(5.5)^2))+(2*R*r*cosd(5.5)*cos(B+anglet))+((r^2)*(cos(B+anglet).^2))+((r^2)*(sin(B+anglet).^2))-(2*R*r*sind(5.5)*sin(B+anglet)) + ((R^2)*(sind(5.5)^2));

V = ((R^2)*(cosd(5.5)^2)) + (2*R*r*cosd(5.5)*cos(anglet)) + ((r^2)*(cos(anglet).^2)) + ((r^2)*(sin(anglet).^2))-(2*R*r*sind(5.5)*sin(anglet)) + ((R^2)*(sind(5.5)^2));

dom = ((M+M0)*(R^2))+(I)+(V.^2);

frac = num./dom;

w = sqrt(frac);

num2 = 2*(g*R*anglet*sin(B)*(M0+M+m) + m*g*r*(cos(B)-cos(anglet+B))-moment*anglet);
den2 = M0*R^2 + M*R^2 + M*k^2  + m*((R+r*cos(anglet)).^2 + (r*sin(anglet)).^2) + 0.5*m*r0^2;
frac2 = num2./den2;
w = sqrt(frac2);
end

