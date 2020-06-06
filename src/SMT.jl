export init_smt, init_smt_remote

function init_smt(name="default")
    JULIA = joinpath(Sys.BINDIR, Sys.iswindows() ? "julia.exe" : "julia")
    if Sys.iswindows()
        run(`cmd /c smt init $name`)
        run(`cmd /c smt configure -e $(JULIA)`)
        run(`cmd /c smt configure -d Data`)
        run(`cmd /c smt configure -l cmdline`)
    else
        run(`smt init $name`)
        run(`smt configure -e $(JULIA)`)
        run(`smt configure -d Data`)
        run(`smt configure -l cmdline`)
    end
end

function init_smt_remote(name = "default")
    try 
        init_smt(name)
    catch
    end
    if Sys.iswindows()
        run(`cmd /c smtweb`)
    else
        run(`smtweb`)
    end 
    printstyled("Starting development server...\n", color=:green, bold = true)
end
