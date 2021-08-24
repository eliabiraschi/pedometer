module Scoring

include("../Types.jl")

export run

function scorePeak(data, window_size)
        midpoint = Int(size(data)[1] / 2)
        diffLeft = 0.0
        diffRight = 0.0

        for i in range(1, midpoint; step=1)
            diffLeft += data[midpoint].magnitude - data[i].magnitude
        end
        for j in range(midpoint + 1, size(data)[1]; step=1)
            diffRight += data[midpoint].magnitude - data[j].magnitude
        end
        
        (diffRight + diffLeft) / window_size
end

function run(input:: Channel, window_size)
    window = []
    new_dp_index = Int(window_size / 2)
    return function (output:: Channel)
        for dp in input
            push!(window, dp)
            if size(window)[1] == window_size
                score = scorePeak(window, window_size)
                new_dp = Types.Datapoint(window[new_dp_index].time, score)
                put!(output, new_dp)
                popfirst!(window)
            end
        end
    end
end

end