%Code By Brian Trybus


%% Setup inital variables

w = 2001; % given constant (lb/ft)

L = 27.25; %Wing length (ft)

N = 30; %Number of points compared

Error = zeros(1,N);

%% Loop for N times

for P = 1:N
    
    F = discretize_load(P,L,w);

    Error(P) = moment_error(F,L,w);
    
end

%% Results


[a,b] = wall_reactions(F);


plot(Error);
title('Error vs Points sampled');
xlabel('Samples');
ylabel('Error (lb*ft)');

%% Functions

function [outputArg1] = discretize_load(points,length, W)
%Left Endpoint Approimation
%   This finds the force per area for every point then multiplys that by
%   the distance between points

x = linspace(0,length,(points+1));
dx = length/(points);
x = x(1:points) + (dx/2);

%find foreces at left points
F=W*dx*(1-(x./length));

%adds forece and mistance to one matrix
dis = ones((points),2);
temp = linspace(0,points-1, points);
dis(:,2) = dis(:,2).*dx.*(temp') + (dx/2);
dis(:,1) = F;

outputArg1 = dis;
end

function [outputArg1,outputArg2] = wall_reactions(input)
%WALL_REACTIONS finds reactions at joint

Fsum = sum(input(:,1));

outputArg1 = Fsum; % sum of forces

outputArg2 = sum((input(:,1).*input(:,2))); % sum of moments

end

function [outputArg1] = moment_error(F, L, W)
%MOMENT_ERROR compares the rainmensum to the analitical solution of the
%moment to approximate error

X = 3*L/16;

%Find points past point of intrest and take the sum of the moments
Logic = F(:,2)>= X;
F1 = F(Logic,1);
X1 = F(Logic,2)- X;

M1 = sum((F1.*X1));

%My manual intergration for M(x) is wrong so this output will be off by a
%large constant

Ma =  (((L-X)^2)*(W*(1-(X/L))))/6; %andrew derivation


outputArg1 = M1 - Ma;
end

