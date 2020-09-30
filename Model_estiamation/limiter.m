function output = limiter(value, min, max)
    
    output = zeros(length(value), 1);

    for i = 1:length(value)
        if(value(i) >= max)
            output(i) = max;
        elseif(value(i) <= min)
            output(i) = min;
        else
            output(i) = value(i);
        end 
    end
    
end