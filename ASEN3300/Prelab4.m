

Fs = 2048;
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T; 

x = 2*sin(2*pi*t*500)+1;

y= fft(x);

P2 = abs(y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')