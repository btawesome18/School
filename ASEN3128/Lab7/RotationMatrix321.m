function R321 = RotationMatrix321(attitude)
% Standard 321 Euler Angle Rotation
% If xI is inertial coordinates of vector
% then XB = R321 * XI are body coordinates

% cphi = cos(attitude(1));
% sphi = sin(attitude(1));
% 
% cth = cos(attitude(2));
% sth = sin(attitude(2));
% 
% cpsi = cos(attitude(3));
% spsi = sin(attitude(3));
% 
% 
% R3 = [cpsi spsi 0;...
%     -spsi cpsi 0;...
%     0 0 1];
% 
% R2 = [cth 0 -sth;...
%     0 1 0;...
%     sth 0 cth];
% 
% R1 = [1 0 0;...
%     0 cphi sphi;...
%     0 -sphi cphi];
%     
% R321 = R1*R2*R3;

phi = attitude(1);
theta = attitude(2);
psi = attitude(3);

R3 = [cos(psi) sin(psi) 0;...
    -sin(psi) cos(psi) 0;...
    0 0 1];

R2 = [cos(theta) 0 -sin(theta);...
    0 1 0;...
    sin(theta) 0 cos(theta)];

R1 = [1 0 0;...
    0 cos(phi) sin(phi);...
    0 -sin(phi) cos(phi)];
    
R321 = R1*R2*R3;