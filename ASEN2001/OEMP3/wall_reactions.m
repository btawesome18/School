function [outputArg1,outputArg2] = wall_reactions(input)
%WALL_REACTIONS finds reactions at joint

Fsum = sum(input(:,1));

outputArg1 = Fsum; % sum of forces

outputArg2 = sum((input(:,1).*input(:,2))); % sum of moments

end

