BN = M1(60)*M2(-45)*M3(30);
FN = M1(-15)*M2(25)*M3(10);

BF = BN*(FN')

O = rad2deg(atan2(BF(3,1),BF(3,2)))
i = acosd(BF(3,3))
w = rad2deg(atan2(BF(1,3),BF(2,3)))

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

