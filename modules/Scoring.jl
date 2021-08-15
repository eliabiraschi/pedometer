module Scoring

include("../Types.jl")

export run

WINDOW_SIZE = 34

function scorePeak(data)
        midpoint = Int(size(data)[1] / 2)
        diffLeft = 0.0
        diffRight = 0.0

        for i in range(1, midpoint; step=1)
            diffLeft += data[midpoint].magnitude - data[i].magnitude
        end
        for j in range(midpoint + 1, size(data)[1]; step=1)
            diffRight += data[midpoint].magnitude - data[j].magnitude
        end
        
        (diffRight + diffLeft) / WINDOW_SIZE
end

function run(input:: Channel)
    window = []
    new_dp_index = Int(WINDOW_SIZE / 2)
    return function (output:: Channel)
        for dp in input
            push!(window, dp)
            if size(window)[1] == WINDOW_SIZE
                score = scorePeak(window)
                new_dp = Types.Datapoint(window[new_dp_index].time, score)
                put!(output, new_dp)
                popfirst!(window)
            end
        end
    end
end

end