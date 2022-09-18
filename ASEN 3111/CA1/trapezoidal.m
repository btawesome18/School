function sum = trapezoidal(funcIn, startX, endX, steps)
%Trapizodail sum of a fuction from start to end with set amount of steps
%By Brian Trybus
%1/11/2022
%   funcIn expects @functionInQuestion, startX is starting index, endX is
%   end of intergration, steps the the total number of points to be
%   considered.

    sum = 0; %Start an accumulator
    size = (endX-startX)/steps;
    Y0 = funcIn(startX);
    Y1 = 0;
    for x = startX:size:(endX-size)
        
        Y1 = funcIn(x+size); %Only calls once per loop

        sum = sum + ((Y0+Y1)); % Adds the 2 points togather using area of trap being b*(h1+h2)/2 but multiples are moved out.

        Y0 = Y1;

    end

    sum = sum*(size/2); %Move the constant multipliers out of the loop to save speed.

end