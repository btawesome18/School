T = readtable('output.csv');
GenCell = T(:,1);
Gen = table2array(GenCell);
MaxCell = T(:,2);
Max = table2array(MaxCell);
AllCell = T(:,(3:(width(T)-1)));
All = table2array(AllCell);
GenAve = (sum(All, 2)/(width(T)-3));
plot(Gen, GenAve, Gen, Max)
title("Fitness Vs Generations")
xlabel("Generations")
ylabel("Fitness")
legend("Average","Max")