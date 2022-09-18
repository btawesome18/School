function vec = sampleAtTimes(sampleTimes, vecTime, inVec)
% Uses linear interpolation to give time sampled vector values at different
% sample times
%
% INPUTS:   sampleTimes:    desired time values
%           vecTime:        current time values
%           inVec:          vector to sample for values
%
% OUTPUTS:  vec:    vector sampled at desired time values
%

    if (sampleTimes(1) < vecTime(1)) || (sampleTimes(end) > vecTime(end))
        error('Requested sample times exceed given time')
    end
    
    index = 1;
    vec = zeros(size(sampleTimes));

    for i = 1:length(sampleTimes)
        while vecTime(index) < sampleTimes(i)
            index = index + 1;
        end

        x1 = vecTime(index);
        x2 = vecTime(index + 1);
        y1 = inVec(index);
        y2 = inVec(index + 1);

        vec(i) = (((y2 - y1)/(x2 - x1))*(sampleTimes(i) - x1)) + y1;
        
    end

end




