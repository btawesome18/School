
%Plank's law
C1 = 3.74177*(10^8);
C2 = 1.43878*(10^4);
e = 2.71828182845904523536028747135266249775724709369995;
T = 5780;
Eplank =  @(L) ((C1*(10^6))./( (L.^5).*(((e.^(C2./(L*T))))-1) ));
L = logspace(-2,4,1000);
E = Eplank(L);
loglog(L,E)
ylim([10^-6,10^9])