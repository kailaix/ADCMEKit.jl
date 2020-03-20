module ADCMEKit

using PyPlot
using LinearAlgebra
import PyCall
import PyCall:PyObject
using ADCME



animation_ = PyCall.PyNULL()
function __init__()
    global animation_
    copy!(animation_,PyCall.pyimport("matplotlib.animation"))
end
include("Core.jl")
include("Visualization.jl")
include("Unit.jl")


end # module
