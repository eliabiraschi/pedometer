include("./modules/ReadSensors.jl")
include("./Controller.jl")
include("./modules/LoadCSV.jl")

function main()
    steps_count = 0;
    rawdata = Channel(LoadCSV.load_csv)
    #rawdata = Channel(ReadSensors.init)
    #ReadSensors.start()
    steps = Channel(Controller.controller(rawdata))
    for x in steps
        steps_count += 1
    end
    
    println(steps_count);
end

main()
