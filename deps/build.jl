push!(LOAD_PATH, "@stdlib")
using Conda

if !("tikzplotlib" in Conda._installed_packages(:ADCME))
    Conda.add("tikzplotlib", :ADCME, channel="conda-forge")
end

if !("imagemagick" in Conda._installed_packages(:ADCME))
    Conda.add("imagemagick", :ADCME, channel="conda-forge")
end