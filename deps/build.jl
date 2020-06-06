push!(LOAD_PATH, "@stdlib")
using Conda
using LibGit2
PWD = pwd()

if Sys.iswindows()
    ENV["PATH"] = joinpath(Conda.BINDIR)*";"*ENV["PATH"]
end

# rm(joinpath(Conda.LIBDIR, "Sumatra"), recursive=true, force=true)
if !isdir(joinpath(Conda.LIBDIR, "Sumatra"))
    LibGit2.clone("https://github.com/ADCMEMarket/Sumatra", joinpath(Conda.LIBDIR, "Sumatra"))
    cd(joinpath(Conda.LIBDIR, "Sumatra"))
    if Sys.iswindows()
        run(`$(joinpath(Conda.PYTHONDIR, "python.exe")) setup.py install`)
    else
        run(`$(joinpath(Conda.PYTHONDIR, "python")) setup.py install`)
    end
end


if !("tikzplotlib" in Conda._installed_packages())
    Conda.add("tikzplotlib", channel="conda-forge")
end

image_writer = "imagemagick"

if !(Sys.iswindows()) && !(image_writer in Conda._installed_packages())
    Conda.add(image_writer, channel="conda-forge")
end

cd(PWD)