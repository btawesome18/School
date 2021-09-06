function out = M1(a)
%DCM Summary of this function goes here
%   Detailed explanation goes here
     out = [1,0,0;0,cosd(a),sind(a);0,-sind(a),cosd(a)];

end

function out = M2(b)
%DCM Summary of this function goes here
%   Detailed explanation goes here
   
     out = [cosd(b),0,-sind(b);0,1,0;sind(b),0,cosd(b)];

end

function out = M3(c)
%DCM Summary of this function goes here
%   Detailed explanation goes here

     out = [cosd(c),sind(c),0;-sind(c),cosd(c),0;0,0,1];
end