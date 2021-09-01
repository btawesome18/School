% Andrew's Group Part 2
clear
clc
%% Constants
%Aluminum
E = 9.9;  %[x10^3ksi]
F_Yield_al = 35000; %psi
rho_al = .098; %[lb/in^3]
cost_al = 8.03; %[$/lb]
% 
% %Steel 
E = 29;  %[x10^3ksi]
% F_Ult = 90000; %[ksi]
F_Yield_steel= 70000; %[ksi] %yield is what matters
rho_steel = .283; %[lb/in]
cost_steel = 8.07; %[$/lb]
% 
% %Nickel
% E = 30;  %[x10^3ksi]
F_Yield_nickel= 35000; %[psi
rho_nickel = .304; %[lb/in]
cost_nickel= 53.78; %[$/lb]
% 
% %Stainless
% E = 28.5;  %[x10^3ksi]
F_Yield_stainless= 115000; %[psi]
rho_stainless = .284; %[lb/in]
cost_stainless = 29.63; %[$/lb]
% 
% %Titanium
% E = 16.9;  %[x10^3ksi]
F_Yield_ti= 120000; %[psi]
rho_ti = .16; %[lb/in]
cost_ti = 115.36; %[$/lb]

%% Bending Stress in a Circular Cross Section
L=27.25*12; %length is 27.25 feet *12 in/ft
x=linspace(0,L,1000);
totload=27263.625; %lb
w_0=2001/12;
% Circle max radius is .5 foot = 6 inches
circular_fos=zeros(1,5749);
k=1;
r_vec=.25:.001:6;
for r=r_vec
    circ_area=pi*r^2;
    I=(pi*r^4)/4;
   %Aluminum
    moments_al=(((L-x).^2)).*(((w_0.*(L-x))./(6*L))-(rho_al*circ_area/2)); %this gives the moments at various x's
    maxmoment_al=max(moments_al); %this gives the max moment which is all we're concerned about
   
    bendingstress_al=(maxmoment_al*r)/I;
    circular_fos_al(k)=F_Yield_al/bendingstress_al;
    
    %Steel
    moments_steel=(((L-x).^2)).*(((w_0.*(L-x))./(6*L))-(rho_steel*circ_area/2)); %this gives the moments at various x's
    maxmoment_steel=max(moments_steel); %this gives the max moment which is all we're concerned about
   
    bendingstress_steel=(maxmoment_steel*r)/I;
    circular_fos_steel(k)=F_Yield_steel/bendingstress_steel;
    
    %Nickel
    moments_nickel=(((L-x).^2)).*(((w_0.*(L-x))./(6*L))-(rho_nickel*circ_area/2)); %this gives the moments at various x's
    maxmoment_nickel=max(moments_nickel); %this gives the max moment which is all we're concerned about
   
    bendingstress_nickel=(maxmoment_nickel*r)/I;
    circular_fos_nickel(k)=F_Yield_nickel/bendingstress_nickel;
    
    %Stainless
    moments_stainless=(((L-x).^2)).*(((w_0.*(L-x))./(6*L))-(rho_stainless*circ_area/2)); %this gives the moments at various x's
    maxmoment_stainless=max(moments_stainless); %this gives the max moment which is all we're concerned about
   
    bendingstress_stainless=(maxmoment_stainless*r)/I;
    circular_fos_stainless(k)=F_Yield_stainless/bendingstress_stainless;
    
    %Titanium
    moments_ti=(((L-x).^2)).*(((w_0.*(L-x))./(6*L))-(rho_ti*circ_area/2)); %this gives the moments at various x's
    maxmoment_ti=max(moments_ti); %this gives the max moment which is all we're concerned about
   
    bendingstress_ti=(maxmoment_ti*r)/I;
    circular_fos_ti(k)=F_Yield_ti/bendingstress_ti;
    
    
    k=k+1;
end

%Aluminum Cost Calculation

best_index_al=find(circular_fos_al==min((circular_fos_al(circular_fos_al>1.5))));
cost_al_circ=L*(pi*(r_vec(best_index_al))^2);

%Steel Cost Calculation

best_index_steel=find(circular_fos_steel==min((circular_fos_steel(circular_fos_steel>1.5))));
cost_steel_circ=L*(pi*(r_vec(best_index_steel))^2);

%Nickel Cost Calculation

best_index_nickel=find(circular_fos_nickel==min((circular_fos_nickel(circular_fos_nickel>1.5))));
cost_nickel_circ=L*(pi*r_vec(best_index_nickel)^2);

%Stainless Cost Calculation

best_index_stainless=find(circular_fos_stainless==min((circular_fos_stainless(circular_fos_stainless>1.5))));
cost_stainless_circ=L*(pi*r_vec(best_index_stainless)^2);

%Titanium cost calculation

best_index_ti=find(circular_fos_ti==min((circular_fos_ti(circular_fos_ti>1.5))));
cost_ti_circ=L*(pi*r_vec(best_index_ti)^2);



%Total Costs

circ_costs=[cost_al_circ,cost_steel_circ,cost_nickel_circ,cost_stainless_circ,cost_ti_circ];
circ_best_index=find(circ_costs==min(circ_costs));

beam_radii=[r_vec(best_index_al),r_vec(best_index_steel),r_vec(best_index_nickel),r_vec(best_index_stainless),r_vec(best_index_ti)];
names=["Aluminum","Steel","Nickel","Stainless","Titanium"];
fprintf('Best circular beam is a %s beam with radius %.3f in\n',names(circ_best_index),beam_radii(circ_best_index));
fprintf('This beam costs $%.2f',circ_costs(circ_best_index));


