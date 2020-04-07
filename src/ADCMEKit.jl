module ADCMEKit

using PyPlot
using LinearAlgebra
import PyCall
import PyCall:PyObject
using ADCME


mpl = PyCall.PyNULL()
animation_ = PyCall.PyNULL()
function __init__()
    global animation_, mpl 
    copy!(animation_,PyCall.pyimport("matplotlib.animation"))
    copy!(mpl,PyCall.pyimport("tikzplotlib"))
end
include("Core.jl")
include("Visualization.jl")

end # module
