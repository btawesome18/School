function [outputArg1] = moment_error(F, L, W)
%MOMENT_ERROR compares the rainmensum to the analitical solution of the
%moment to approximate error

X = 3*L/16;

%Find points past point of intrest and take the sum of the moments
Logic = F(:,2)>= X;
F1 = F(Logic,1);
X1 = F(Logic,2);

M1 = sum(F1.*X1);

%My manual intergration for M(x) is wrong so this output will be off by a
%large constant
Ma = (W)*((L*X)-((X^2)/(2*L))-((1/6)*(L^2)));

outputArg1 = M1 - Ma;
end

