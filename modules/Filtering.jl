module Filtering

include("../Types.jl")

export run

FILTER_RANGE = 1:12
FILTER_LENGTH = size(FILTER_RANGE)[1]
FILTER_STD = 0.35
HALF_FILTER_LENGTH = FILTER_LENGTH / 2
B = (FILTER_STD * HALF_FILTER_LENGTH) ^ 2

function generateCoefficients()
    coeff = []
    for i in FILTER_RANGE
        value = ℯ ^ (-0.5 * ((i - HALF_FILTER_LENGTH) / B))
        push!(coeff, value)
    end
    coeff
end

function run(input:: Channel)
    window = []
    filtersum = 0.0
    filtercoefficients = generateCoefficients()
    for i in FILTER_RANGE
        filtersum += filtercoefficients[i]
    end
    return function (output:: Channel)
        for dp in input
            push!(window, dp)
            if size(window)[1] == FILTER_LENGTH
                sum = 0.0
                for i in FILTER_RANGE
                    sum += window[i].magnitude * filtercoefficients[i]
                end
                new_dp = Types.Datapoint(window[Int(HALF_FILTER_LENGTH)].time, sum / filtersum)
                put!(output, new_dp)
                popfirst!(window)
            end
        end
    end
end

end