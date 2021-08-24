module Controller

include("./modules/PreProcess.jl")
include("./modules/Filtering.jl")
include("./modules/Scoring.jl")
include("./modules/Detection.jl")
include("./modules/PostProcess.jl")

export controller

SCORING_WINDOW_SIZE = 34
DETECTION_TIMETHRESHOLD = 1.2
POSTPROCESS_TIMETHRESHOLD = 200

function controller(rawdata:: Channel)
    return function (output:: Channel)
        ppdata = Channel(PreProcess.run(rawdata))
        smoothdata = Channel(Filtering.run(ppdata))
        peakScoreData = Channel(Scoring.run(smoothdata, SCORING_WINDOW_SIZE))
        peakData = Channel(Detection.run(peakScoreData, DETECTION_TIMETHRESHOLD))

        for x in Channel(PostProcess.run(peakData, POSTPROCESS_TIMETHRESHOLD))
            put!(output, x)
        end
    end
end

end
