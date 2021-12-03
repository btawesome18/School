%%REACTION WHEEL MEASUREMENTS - Using the data obtained in the procedure part 2),
%calculate how long the reaction wheel could resist an aerodynamic torque of 10-4 Nm 
%before the wheel speed exceeds the limit of 4000 rpm. What is the angular momentum capacity of this wheel in [Nms]? 

x3 = load("ReactionWheelMeasurementTrial1_3Nm_5s");
x4 = load("ReactionWheelMeasurementTrial1_4Nm_5s");
x5 = load("ReactionWheelMeasurementTrial1_5Nm_5s");
x6 = load("ReactionWheelMeasurementTrial1_6Nm_5s");
x7 = load("ReactionWheelMeasurementTrial1_7Nm_5s");

Data = {x3,x4,x5,x6,x7};

timeStart = 500;
timeStop = 1000;
n = timeStop-timeStart;

slopes = zeros(5,1);
m_error = zeros(5,1);
torques = [3;4;5;6;7];

for i = 1:5
    
   set = Data{i};
   
   x = set(timeStart:timeStop,1);
   y = set(timeStart:timeStop,3);
   x = x*(pi/30); %RPM to rad/s
   
   [slopes(i),~,m_error(i)] = fitLine(x,y);
   
end

%T = I*a
% I = T/a
I = torques./slopes;
I_error = ((-torques.*m_error)./(slopes.^2)).^2;

I_mean = sum(I)/5;

stanDiv = sqrt((sum((I-I_mean).^2))/5);


%%Functions


function [m,b, sigma_m] = fitLine(x,y)

    n = (length(x));

    X = sum(x)/n;
    Y = sum(y)/n;

    m = sum((x-X).*(y-Y))/sum((x-X).^2);
    
    b = Y - (m*X);
    
    S = sqrt((sum((y-(m*x)-b).^2))/(n-2));
    
    sigma_m = S* sqrt(n/((n*sum(x.^2))-(sum(x)^2)));
    
end