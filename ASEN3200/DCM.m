
function out = M1(a)
%DCM Summary of this function goes here
%   Detailed explanation goes here
     out = [1,0,0;0,cos(a),sin(a);0,-sin(a),cos(a)];

end

function out = M2(b)
%DCM Summary of this function goes here
%   Detailed explanation goes here
     out = [cos(b),0,-sin(b);0,1,0;sin(b),0,cos(b)];

end

function out = M3(c)
%DCM Summary of this function goes here
%   Detailed explanation goes here
     out = [cos(c),sin(c),0;-sin(c),cos(c),0;0,0,1];
     
end