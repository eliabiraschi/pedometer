module Controller

include("./modules/PreProcess.jl")
include("./modules/Filtering.jl")
include("./modules/Scoring.jl")
include("./modules/Detection.jl")
include("./modules/PostProcess.jl")

export controller

function controller(rawdata:: Channel)
    return function (output:: Channel)
        ppdata = Channel(PreProcess.run(rawdata))
        smoothdata = Channel(Filtering.run(ppdata))
        peakScoreData = Channel(Scoring.run(smoothdata))
        peakData = Channel(Detection.run(peakScoreData))

        for x in Channel(PostProcess.run(peakData))
            put!(output, x)
        end
    end
end

end
