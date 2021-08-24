module PostProcess

include("../Types.jl")

export run

function run(input:: Channel, time_threshold)
    current = nothing
    return function (output:: Channel)
        for dp in input
            if current === nothing
                current = dp
            else
                # If the time difference exceeds the threshold, we have a confirmed step
                if (dp.time - current.time) > time_threshold
                    current = dp
                    put!(output, dp)
                else
                    # Keep the point with the largest magnitude.
                    if dp.magnitude > current.magnitude
                        current = dp
                    end
                end
            end
        end
    end
end

end
