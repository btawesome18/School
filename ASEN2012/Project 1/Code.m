%Calorimeter Project
%By Brian Trybus

%Using Calorimetery to find the specific heat of an unknown sample.

%Calorimeter Mass 0.51 kg AL 6061
%A 115.671g
%TC0 Calorimeter
%TC1 boiling water
%TC2 air
%TC3 Calorimeter

%% Import data
load('SampleA');


%% Points Picked for line of best fit
%N is the index before the sample is placed in the calorimeter
N=157;

%% Prepareing data for sample temp line of best fit
meanA = ((SampleA(:,2)+SampleA(:,5))./2);

lineAInitalTime = SampleA(1:N,1);
lineACalMean = meanA(1:N,1);

%N1 is index as calorimeter comes to peak
[~,N1] = max(meanA); %start sample
nEnd = 500; %end sample
nL = nEnd-N1+1; % amount of samples used




%% Linear regression of least squares for temp of calorimeter before sample

% Y = a + bx 
% A = (sum(x^2)*sum(y)-sum(x)sum(xy)) /delta
% B = (N(sum(xy))-sum(x)sum(y))/delta
% delta = (Nsum(x^2)-sum(x)^2)

aTempSum = sum(lineACalMean);
aTimeSum = sum(lineAInitalTime);
aSquaredTimeSum = sum((lineAInitalTime.^2));
aTimeTempSum = sum((lineAInitalTime.*lineACalMean));

delta = (((N)*aSquaredTimeSum)-(aTimeSum^2));
%y = a + bx
A = ((aSquaredTimeSum*aTempSum)-(aTimeSum*aTimeTempSum))/delta;
B = (((N)*aTimeTempSum)-(aTempSum*aTimeSum))/delta;
% calculte line to plot
y1 = A + B*SampleA(:,1);

sigmaY1 = sqrt((1/(N-2))*((sum((lineACalMean-A-(B*lineAInitalTime)).^2))));
Sigma_A1 = sqrt((sigmaY1^2)*(aSquaredTimeSum/delta)); 
Sigma_B1 = sqrt(N*(sigmaY1^2)/delta);
%Error propigation to find error in T at N
sigmaT1 = sqrt(((Sigma_A1)^2)+(((Sigma_B1*(SampleA(N,1)))^2)));

%% Calorimeter line of best fit
%arrys we will use for least squares
yCalMean = meanA(N1:nEnd,1);
xTime = SampleA(N1:nEnd,1);
%splitting equations into steps
ySum = sum(yCalMean);
xSum = sum(xTime);
xSumSquare = sum((xTime.^2));
yxSum = sum((yCalMean.*xTime));
%solving for A1 and B1
delta2 = ((nL*xSumSquare)-(xSum^2));
A1 = ((xSumSquare*ySum)-(xSum*yxSum))/delta2;
B1 = ((nL*yxSum)-(xSum*ySum))/delta2;
% calculte line to plot
y2 = A1 + B1*SampleA(:,1);
%Approximate error
sigmaY2 = sqrt((1/(N-2))*((sum(((yCalMean-A1-(B1*xTime)).^2)))));
Sigma_A2 = sqrt((sigmaY2^2)*(xSumSquare/delta2)); 
Sigma_B2 = sqrt(nL*(sigmaY2^2)/delta2);
%Error propigation to find error in T at N
sigmaT2 = sqrt(((Sigma_A2)^2)+(((Sigma_B2*(SampleA(N,1)))^2)));
%% Find the tempitures to use in the calulation
calTimeMid = SampleA(N,1);
dTc = y2(N)- y1(N);
sampleTempAve = sum(SampleA(1:N,3))/N;
dTs = sampleTempAve - y2(N);

%% Solve for specific heat
%Qout = Qin
%Ms Cs dTs = Mc Cc dTc
%Cs = (Mc Cc dTc)/(Ms dTs)
Cc = 0.895; %J/(gC)
Mc = 510; %g
Ms = 115.671; %g

Cs = (Mc*Cc*dTc)/(Ms*dTs);

%% Propagate error
%quadriture propagation
% sigmaT^2 = ((d/d(dTs))*sigma1)^2+((d/d(dTc))*sigma2)^2
%sigmaT = sqrt((((d/d(Ts))*sigma1)^2)+(((d/d(Tc))*sigma2)^2));
%d/d(Ts)
ddTs = (Mc*Cc)/(Ms*dTs);
%d/d(Tc)
ddTc = (Mc*Cc/Ms)*(sampleTempAve-y1(N))/((sampleTempAve-y2(N))^2);

sigmaT = sqrt((((ddTs)*sigmaT1)^2)+(((ddTc)*sigmaT2)^2));


%% Plot data with lines of best fit, and Tempiture values used
plot(SampleA(:,1), meanA,SampleA(:,1), y1,SampleA(:,1),y2);
xline(calTimeMid);
title('Calorimeter: Temperature vs Time');
xlabel('Time(s)');
ylabel('Temperature(C)');


%% Print Final result with error

fprintf('Sample A specific heat: %3.3f(J/(gC)) and an error of %d',Cs,sigmaT);

