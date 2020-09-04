module ADCMEKit

using PyPlot
using LinearAlgebra
import PyCall
import PyCall:PyObject
using ADCME


tikz = PyCall.PyNULL()
animation_ = PyCall.PyNULL()
function __init__()
    global animation_, tikz 
    copy!(animation_,PyCall.pyimport("matplotlib.animation"))
    copy!(tikz,PyCall.pyimport("tikzplotlib"))

    if Sys.iswindows()
        if !occursin(ADCME.BINDIR, replace(ENV["PATH"], "\\\\"=>"\\"))
            @warn """$(ADCME.BINDIR) is not in the system path. Some of the ADCMEKit tools may break."""
        end
    elseif !occursin(ADCME.BINDIR, ENV["PATH"])
        @warn """$(ADCME.BINDIR) is not in the system path. Some of the ADCMEKit tools may break."""
    end
end
include("Core.jl")
include("Visualization.jl")

end # module
