function sum = simpsonsRule(funcIn, startX, endX, steps)
%Simpson's Rule sum of a fuction from start to end with set amount of steps
%By Brian Trybus
%1/11/2022
%   funcIn expects @functionInQuestion, startX is starting index, endX is
%   end of intergration, steps the the total number of points to be
%   considered.

    sum = 0;%Start an accumulator

    size = (endX-startX)/steps;
    halfSize = size/2;

    Y0 = funcIn(startX);
    Y1 = 0;

    for x = startX:size:(endX-size)

        Y1 = funcIn(x+size); %Only calls once per loop

        sum = sum + ((Y0+Y1+(4*funcIn(x+halfSize)))); %inter part of simpsons without multiplyers.

        Y0 = Y1; %Save endpoint for next loop as start point

    end

    sum = (size/6)*sum; %Move the constant multipliers out of the loop to save speed.

end