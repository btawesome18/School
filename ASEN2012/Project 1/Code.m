%Calorimeter Project
%Calorimeter Mass 0.51 kg AL 6061
%A 115.671g
%B 39.306g
%C 17.615g
%D 88.897g
%TC0 Calorimeter
%TC1 boiling water
%TC2 air
%TC3 Calorimeter

load('SampleA');
%N is the index before the sample is placed in the calorimeter
N=160;

meanA = ((SampleA(:,2)+SampleA(:,2))./2);

lineAInitalTime = SampleA(1:N,1);
lineACalMean = meanA(1:N,1);

% Y = a + bx 
% A = (sum(x^2)*sum(y)-sum(x)sum(xy)) /delta
% B = (N(sum(xy))-sum(x)sum(y))/delta
% delta = (Nsum(x^2)-sum(x)^2)


%Linear regression of least squares for temp of calorimeter before sample
aTempSum = sum(lineACalMean);
aTimeSum = sum(lineAInitalTime);
aSquaredTimeSum = sum((lineAInitalTime.^2));
aTimeTempSum = sum((lineAInitalTime.*lineACalMean));

delta = ((N*aSquaredTimeSum)-(aTimeSum^2));
%y = a + bx
A = ((aSquaredTimeSum*aTempSum)-(aTimeSum*aTimeTempSum))/delta;
B = ((N*aTimeTempSum)-(aTempSum*aTimeSum))/delta;
% calculte line to plot
y1 = A + B*SampleA(:,1);

sigma1 = sqrt((1/N)*((sum((lineACalMean-A-(B*lineAInitalTime)).^2))));




%N1 is index as calorimeter comes to peak
N1 = 352; %start sample
nEnd = 611; %end sample
nL = nEnd-N1+1; % amount of samples used

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
sigma2 = sqrt((1/N)*((sum(((yCalMean-A1-(B1*xTime)).^2)))));

%Find the tempitures to use in the calulation
calTimeMid = N+round((N1-N)/2);
dTc = y2(calTimeMid)- y1(calTimeMid);
sampleTempAve = sum(SampleA(1:N,3))/N;
dTs = sampleTempAve - y2(calTimeMid);
%Qout = Qin
%Ms Cs dTs = Mc Cc dTc
%Cs = (Mc Cc dTc)/(Ms dTs)
Cc = 0.895; %J/(gC)
Mc = 510; %g
Ms = 115.671; %g

Cs = (Mc*Cc*dTc)/(Ms*dTs);

plot(SampleA(:,1), meanA,SampleA(:,1), y1,SampleA(:,1),y2);
hold();
xline(calTimeMid);
