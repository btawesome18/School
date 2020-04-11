%[numbers, strings, raw]=xlsread('Flight_Sample_Data_Raw.xlsx');
R= 8.31446;
T= 293;
M= 0.028964;
g= -9.80665;
Constant = -8576.625;
Pint=numbers(1,5);
P=numbers(:,5);
Hight = Constant * log(P/Pint);
plot(numbers(:,1),Hight);
title('Height');
xlabel('Time(seconds)');
ylabel('Height(meters)');
c = 1;
for i = 2:length(Hight)
    velTemp =(Hight(i)-Hight(i-1))/(numbers(i,1)-numbers(i-1,1));
    if(velTemp~=1)
        vel(1,c)= velTemp;
        vel(2,c) = numbers(i,1);
        c = c + 1;
    end
    
end    
plot(vel(:,1),vel(:,2));