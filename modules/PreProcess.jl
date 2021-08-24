module PreProcess

include("../Types.jl")

export run

INTERPOLATIONTIME = 10 # in millis

scaletime = (time, starttime) -> (time - starttime)

function linearInterpolate(dp1:: Types.Types.Datapoint, dp2:: Types.Types.Datapoint, interpolatedtime:: Int)::Types.Types.Datapoint
    dt = dp2.time - dp1.time
    dv = dp2.magnitude - dp1.magnitude
    mag = (dv/dt) * (interpolatedtime - dp1.time) + dp1.magnitude
    Types.Types.Datapoint(interpolatedtime, mag)
end

function run(input:: Channel)
    window = []
    starttime = -1
    interpolationcount = 0
    return function (output:: Channel)
        for dp in input
            if starttime == -1
                starttime = copy(dp.time)
            end
            local_dp = Types.Types.Datapoint(scaletime(dp.time, starttime), dp.magnitude)
            push!(window, local_dp)
            if size(window)[1] >= 2
                dp1 = deepcopy(window[1])
                dp2 = deepcopy(window[2])
                numberofpoints = ceil(Int, (dp2.time - dp1.time) / INTERPOLATIONTIME)
                for i in range(1, numberofpoints; step=1)
                    interpolatedtime = interpolationcount * INTERPOLATIONTIME
                    if (dp1.time <= interpolatedtime < dp2.time)
                        interpolated = linearInterpolate(dp1, dp2, interpolatedtime)
                        put!(output, interpolated)
                        interpolationcount += 1
                    end
                    if !isempty(window)
                        popfirst!(window)
                    else
                        println("EMPTY!")
                    end
                end
            end
        end
    end
end

end
