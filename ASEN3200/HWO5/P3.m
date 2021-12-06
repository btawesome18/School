a = 0.723*(1.496e+8); % AU
e = 0.0068;
mu = 1.327 *(10^11);% of the sum
Ra = a*(1+e);
Vav = sqrt((1-e)/(1+e))*sqrt(mu/a);

a1 = (Ra+(1.496e+8))/2;
e1 = 1-(Ra/a1);

Va = sqrt((1-e1)/(1+e1))*sqrt(mu/a1);
Vp = sqrt((1+e1)/(1-e1))*sqrt(mu/a1);
Ve = sqrt(mu/(1.496e+8));

muE = 3.986*(10^5);
muV = 3.249*(10^5);
V1 = Ve - Va;
V2 = Vp - Vav;
RpDep = 300+6378 ;
RpArv = 100 + 6052;

Vp1 = sqrt((V1^2)+(2*muE/RpDep));

Vp2 = sqrt((V2^2)+(2*muV/RpArv));
VcE = sqrt(muE/RpDep);
VcV = sqrt(muV/RpArv);

dV = Vp1 - VcE + Vp2 - VcV;
