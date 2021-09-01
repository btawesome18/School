function [outputArg1] = discretize_load(points,length, W)
%Left Endpoint Approimation
%   This finds the force per area for every point then multiplys that by
%   the distance between points

x = linspace(0,length,(points+1));
dx = length/(points);
x = x(1:points);

%find foreces at left points
F=W*dx*(1-(x./length));

%adds forece and mistance to one matrix
dis = ones((points),2);
temp = linspace(0,points-1, points);
dis(:,2) = dis(:,2).*dx.*(temp');
dis(:,1) = F;

outputArg1 = dis;
end

