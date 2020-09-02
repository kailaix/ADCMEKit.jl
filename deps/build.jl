push!(LOAD_PATH, "@stdlib")
using LibGit2
using ADCME 
PWD = pwd()

CONDA = get_conda()

PKGS = read_with_env(`$CONDA list`)
if !(occursin("tikzplotlib", PKGS))
    run_with_env("$CONDA install -c conda-forge tikzplotlib")
end

if !(Sys.iswindows()) && !(occursin("imagemagick", PKGS))
    run_with_env("$CONDA install -c conda-forge imagemagick")
end

cd(PWD)