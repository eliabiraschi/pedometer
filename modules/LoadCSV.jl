module LoadCSV

include("../Types.jl")
using Dates, CSV

export load_csv

timescalingfactor = 1000000 # Convert ns to ms.

function load_csv(output:: Channel)
    for row in CSV.File("~/_dev/pedometer/data/indoor_100steps.csv")
        if row[1] === "T"
            continue
        end
        T = row[1] / timescalingfactor
        x = row[2]
        y = row[3]
        z = row[4]
        magnitude = x^2 + y^2 + z^2
        dp = Types.Datapoint(T, magnitude)
        put!(output, dp)
    end
end

end
