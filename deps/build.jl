push!(LOAD_PATH, "@stdlib")
using Conda

if !("tikzplotlib" in Conda._installed_packages())
    Conda.add("tikzplotlib", channel="conda-forge")
end

image_writer = "imagemagick"

if !(Sys.iswindows()) && !(image_writer in Conda._installed_packages())
    Conda.add(image_writer, channel="conda-forge")
end

