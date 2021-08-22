module LoadCSV

include("../Types.jl")
using Dates, CSV

export load_csv

nowepoch = () -> floor(Int, datetime2unix(now())*1000)

function load_csv(output:: Channel)
    faketime = nowepoch()
#    for j in [7,8,15]
#        for i in 1:24
            for row in CSV.File("/home/manjaro/_dev/out_4283steps_50ms.csv")
                x = row[1]
                y = row[2]
                z = row[3]
                magnitude = x^2 + y^2 + z^2
                faketime+=100
                dp = Types.Datapoint(faketime, magnitude)
                put!(output, dp)
            end
#        end
#    end
end

end
