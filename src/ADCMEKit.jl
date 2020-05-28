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
    if Sys.iswindows()
py"""
import sys, codecs
if sys.stdout.encoding != 'cp850':
  sys.stdout = codecs.getwriter('cp850')(sys.stdout.buffer, 'strict')
if sys.stderr.encoding != 'cp850':
  sys.stderr = codecs.getwriter('cp850')(sys.stderr.buffer, 'strict')
"""
    end
end
include("Core.jl")
include("Visualization.jl")

end # module
