module ADCMEKit

using PyPlot
using LinearAlgebra
import PyCall
import PyCall:PyObject
using ADCME
using Conda


tikz = PyCall.PyNULL()
animation_ = PyCall.PyNULL()
function __init__()
    global animation_, tikz 
    copy!(animation_,PyCall.pyimport("matplotlib.animation"))
    copy!(tikz,PyCall.pyimport("tikzplotlib"))

    if Sys.iswindows()
        if !occursin(joinpath(Conda.ROOTENV, "Scripts"), replace(ENV["PATH"], "\\\\"=>"\\"))
            @warn """$(joinpath(Conda.ROOTENV, "Scripts")) is not in the system path. Some of the ADCMEKit tools may break."""
        end
    elseif !occursin(Conda.BINDIR, ENV["PATH"])
        @warn """$(Conda.BINDIR) is not in the system path. Some of the ADCMEKit tools may break."""
    end
end
include("Core.jl")
include("Visualization.jl")

end # module
