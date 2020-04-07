module ADCMEKit

using PyPlot
using LinearAlgebra
import PyCall
import PyCall:PyObject
using ADCME

export tikz 

tikz = PyCall.PyNULL()
animation_ = PyCall.PyNULL()
function __init__()
    global animation_, tikz 
    copy!(animation_,PyCall.pyimport("matplotlib.animation"))
    copy!(tikz,PyCall.pyimport("tikzplotlib"))
end
include("Core.jl")
include("Visualization.jl")

end # module
