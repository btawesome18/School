function ScaledData = scaleSWdata(Exp, SW)
% Scales solidworks data to align with experimental data
% --- SAMPLE AT DESIRED TIMES BEFORE THIS ---
%    assumes that data doesn't get more than 1/2 period offset by end
%
% INPUTS:    Exp     - Experimental 
%            SW      - Solidworks data
% 
% OUTPUTS :  ScaledData  -  SW data scaled to align with Exp
%

% Ex1 = 1;
% Ex2 = length(Exp);
% 
% Sx1 = 1;
% Sx2 = length(SW);
% 
% 
% while Exp(Ex1) < Exp(Ex1 + 1)
%     Ex1 = Ex1 + 1;
% end
% while SW(Sx1) < SW(Sx1 + 1)
%     Sx1 = Sx1 + 1;
% end
% 
% while Exp(Ex2) > Exp(Ex2 - 1)
%     Ex2 = Ex2 - 1;
% end
% while SW(Sx2) > SW(Sx2 - 1)
%     Sx2 = Sx2 - 1;
% end
% 


% midExp = (min(Exp) + max(Exp))/2;
% midSW = (min(SW) + max(SW))/2;

midExp = mean(Exp);
midSW = mean(SW);

Ex1 = 1;
while Exp(Ex1) >= midExp
    Ex1 = Ex1 + 1;
end
while Exp(Ex1) < midExp
    Ex1 = Ex1 + 1;
end

Sx1 = 1;
while SW(Sx1) >= midSW
    Sx1 = Sx1 + 1;
end
while SW(Sx1) < midSW
    Sx1 = Sx1 + 1;
end

Ex2 = length(Exp);
Sx2 = length(SW);

while Exp(Ex2) <= midExp
    Ex2 = Ex2 - 1;
end
while Exp(Ex2) > midExp
    Ex2 = Ex2 - 1;
end

while SW(Sx2) <= midSW
    Sx2 = Sx2 - 1;
end
while SW(Sx2) > midSW
    Sx2 = Sx2 - 1;
end

scale = (Sx2 - Sx1)/(Ex2 - Ex1);

idx = floor(scale*(1:length(SW)));
idx = idx(idx > 0);
idx = idx(idx <= length(SW));
ScaledData = SW(idx);

end