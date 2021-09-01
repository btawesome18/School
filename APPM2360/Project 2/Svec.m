function S = Svec(num)

S = zeros(num,num);
    for i = 1:num
        for j = 1:num
            
            S(i,j) = sin((pi*(i-1/2)*(j-1/2))/num);
            
        end
    end

S = S*sqrt(2/num);
end

