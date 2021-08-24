module Detection

include("../Types.jl")

export run

function run(input:: Channel, threshold)
    count = 0
    mean = 0
    std = 0
    return function (output:: Channel)
        for dp in input
            count+=1
            o_mean = 0
            o_mean = copy(mean)
            if count == 1
                mean = dp.magnitude
            elseif count == 2
                mean = (mean + dp.magnitude) / 2;
                std = sqrt(
                    (dp.magnitude - mean)^2 + (o_mean - mean)^2
                ) / 2
            else
                mean = (dp.magnitude + (count - 1) * mean) / count;
                std = sqrt(((count - 2) * (std^2) / (count - 1)) + ((o_mean - mean)^2) +  ((dp.magnitude - mean)^2) / count)
            end
            if count > 15
                if ((dp.magnitude - mean) > std * threshold)
                    # This is a peak
                    put!(output, dp)
                end
            end
        end
    end
end

end
