push!(LOAD_PATH, "@stdlib")
using Conda

if !("tikzplotlib" in Conda._installed_packages())
    Conda.add("tikzplotlib", channel="conda-forge")
end

if !("imagemagick" in Conda._installed_packages())
    Conda.add("imagemagick", channel="conda-forge")
end