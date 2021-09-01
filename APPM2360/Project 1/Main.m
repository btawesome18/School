%% APPM 2360 - PROJECT 1
% Authors: Brian Trybus, Ivan Werne, Rishi Mayekar
% Purpose: Computing the different methods to ruin our life by 
%          asking the bank for money to acquire goon house.

clc; close all; clear;

%% Compound interest comparisons

% Variables
P = 750000; % Initial Loan dollar amt
r = 0.03; % Percent rate of interest
tvec = [1:30];


% Compounding interest 1, 2, 4 and 12 times per year

Acon = P*exp(r.*tvec);
A1 = P*(1+r).^(tvec);
A2 = P*(1+(r/2)).^(tvec.*2);
A4 = P*(1+(r/4)).^(tvec.*4);
A12 = P*(1+(r/12)).^(tvec.*12);

C5yr = [A1(1,5) A2(1,5) A4(1,5) A12(1,5) Acon(1,5)];



%% Eulers aprox
%Fixed rate
p = 4000;
r = 0.05;
A0 = 750000;
const =  [r,p];

input = {0,A0,const};

h = 0.01;

endx = 35;

e3Step05 = EulersAprox(@Equetion3,input,0.5,endx);

e3Step001 = EulersAprox(@Equetion3,input,0.01,endx);

% Adjustible rate

const =  4000;

input = {0,750000,const};

adjRateStep001p4000 = EulersAprox(@adjustableRate,input,0.01,endx);

const =  4500;

input = {0,750000,const};

adjRateStep001p4500 = EulersAprox(@adjustableRate,input,0.01,endx);


% Real soln
t = e3Step001(:,1);
A = 12*(p/r)+(exp(r*(t)))*(A0 - (12*(p/r)));


%% Find Total intrest paid

mortgateP4000 = adjRateStep001p4000(:,2);
mortgateP4500 = adjRateStep001p4500(:,2);

logicP4000 = mortgateP4000<=0;
logicP4500 = mortgateP4500<=0;

i4000 = find(logicP4000, 1, 'first');

i4500 = find(logicP4500, 1, 'first');

p4000intrest = (adjRateStep001p4000(i4000,1)*4000*12)-A0;

p4500intrest = (adjRateStep001p4000(i4500,1)*4500*12)-A0;

%% Plots

% Plot continuous vs 4 vs 12 times per year
figure(1);
hold on;
title('Compound Interest Without Payments');
plot(tvec,Acon,'b');
plot(tvec,A4,'r');
plot(tvec,A12,'y');
legend('Continuous', 'Quarterly','Monthly')
xlabel('Time (years)');
ylabel('Amount ($)');
hold off

% Plot Eulers for fixed rate
figure(2);
title('Eulers Mortgage Aproximation for fixed rate');
hold on
plot(e3Step05(:,1),e3Step05(:,2)); % step = 0.5
plot(e3Step001(:,1),e3Step001(:,2)); % step = 0.01
plot(t,A);%Real solution
legend('Step size = 0.5', 'Step size = 0.01','Real Solution')
xlim([0 35]);
ylim([0 800000]);
xlabel('Time (years)');
ylabel('Mortgage ($)');
hold off


% Plot Eulers for adjustable rate
figure(3);
hold on
title('Eulers Mortgage Aproximation for adjustable rate');
plot(adjRateStep001p4000(:,1),adjRateStep001p4000(:,2)); % p =4000
plot(adjRateStep001p4500(:,1),adjRateStep001p4500(:,2)); % p =4500
legend('p =4000', 'p =4500')
xlim([0 35]);
ylim([0 800000]);
xlabel('Time (years)');
ylabel('Mortgage ($)');
hold off

%% Functions

function output = EulersAprox(dydx,input,h,endx)
%Takes a function in, uses Eulars method to aproximate it with h as the
%step size, and input as inital condistion
    y = input{2};
    x = input{1};
    const = input{3}; %pass any constants in there own cell for the function to unpack
    output = [x,y];%start a matrix with x0 and y0
    for i = (x+h):h:endx
        input = {i,y,const}; %Construct input for dy/dx
        y = y+(h*dydx(input)); % core of Eulars
        
        iter = [i,y];
        output = [output;iter];%append latest value to end of matix
    end

end

function outputArg1 = adjustableRate(state)
%Takes in a state vector and calculates the rate of change for adjustable at that state

    t = state{1};
    A = state{2};
    const = state{3};
    p = const(1);
    
    if t <= 5
        r = 0.03;
    else
        r = 0.03 + (0.015*sqrt(t-5));
    end
    
    Aprime = (r*A)-(12*p);
    
    outputArg1 = Aprime;
end

function outputArg1 = Equetion3(state)
%Takes in a state vector and calculates the rate of change at that state

% unpack state vector
    A = state{2};
    const = state{3};
    r = const(1);
    p = const(2);
% Cacluate rate
    Aprime = (r*A)-(12*p);
    
    outputArg1 = Aprime;
end

