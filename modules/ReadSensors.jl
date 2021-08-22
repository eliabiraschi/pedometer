module ReadSensors

include("../Types.jl")

using Dates

export readsensors

nowepoch = () -> floor(Int, datetime2unix(now())*1000)

active = true

start = () -> active = true
stop = () -> active = false

function init(output:: Channel)
    #while active
    for i in range(1,600; step=1)
        x = parse(Float64, readlines("/sys/bus/iio/devices/iio:device2/in_accel_x_raw")[1])
        y = parse(Float64, readlines("/sys/bus/iio/devices/iio:device2/in_accel_y_raw")[1])
        z = parse(Float64, readlines("/sys/bus/iio/devices/iio:device2/in_accel_z_raw")[1])
        magnitude = x^2 + y^2 + z^2
        dp = Types.Datapoint(nowepoch(), magnitude)
        put!(output, dp)
        sleep(0.1)
    end
end

end