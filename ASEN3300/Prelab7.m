t = linspace(0,2*pi,200);

V = 1.65*sin(t)+1.65;


[binDec12,binBi12] = Voltage2Bin(0,3.3,12,V);

scatter(t,binDec12);
title("12 Bits range 0-3.3V")
ylabel("Bin")
xlabel("Voltage")





function [binDec,binBi] = Voltage2Bin(min_voltage,max_voltage,bits,vin)

%by Brian Trybus

N = 2^(bits)-1;

range = max_voltage-min_voltage;

VperN = range/N;

binDec = round((vin-min_voltage)./VperN);

binBi =zeros(length(binDec),1);

for j = 1:length(binDec)
    temp = binDec(j);
    for i= 1:bits
       
        binBi(j) =binBi(j) + (mod((floor(temp/2^(i-1))),2))*(10^(i-1));
        
    
    end
end

end