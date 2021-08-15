module LoadCSV

include("../Types.jl")
using Dates, CSV

export load_csv

nowepoch = () -> floor(Int, datetime2unix(now())*1000)

function load_csv(output:: Channel)
    faketime = nowepoch()
    for j in [7,8,15]
        for i in 1:24
            for row in CSV.File("~/A_DeviceMotion_data/wlk_$j/sub_$i.csv")
                x = row[11]
                y = row[12]
                z = row[13]
                magnitude = x^2 + y^2 + z^2
                faketime+=100
                dp = Types.Datapoint(faketime, magnitude)
                put!(output, dp)
            end
        end
    end
end

end
