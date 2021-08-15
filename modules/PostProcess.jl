module PostProcess

include("../Types.jl")

export run

TIMETHRESHOLD = 200

function run(input:: Channel)
    current = nothing
    return function (output:: Channel)
        for dp in input
            if current === nothing
                current = dp
            else
                # If the time difference exceeds the threshold, we have a confirmed step
                if (dp.time - current.time) > TIMETHRESHOLD
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
