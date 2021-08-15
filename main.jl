include("./modules/LoadCSV.jl")
include("./Controller.jl")

function main()
    steps_count = 0;
    rawdata = Channel(LoadCSV.load_csv)
    steps = Channel(Controller.controller(rawdata))
    for x in steps
        steps_count += 1
    end
    
    println(steps_count);
end

main()
