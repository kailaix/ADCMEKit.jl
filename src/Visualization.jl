export animate, saveanim, save_tikz

@doc raw"""
    animate(update::Function, frames; kwargs...)

Creates an animation using update function `update`. 
# Example 
```julia
θ = LinRange(0, 2π, 100)
x = cos.(θ)
y = sin.(θ)
pl, = plot([], [], "o-")
t = title("0")
xlim(-1.2,1.2)
ylim(-1.2,1.2)
function update(i)
    t.set_text("$i")
    pl.set_data([x[1:i] y[1:i]]'|>Array)
end
animate(update, 1:100)
```
"""
function animate(update::Function, frames; kwargs...)
    if !isa(frames, Integer)
        frames = Array(frames)
    end
    animation_.FuncAnimation(gcf(), update, frames=frames; kwargs...)
end

"""
    saveanim(anim::PyObject, filename::String; kwargs...)

Saves the animation produced by [`animate`](@ref)
"""
function saveanim(anim::PyObject, filename::String; kwargs...)
    if Sys.iswindows()
        anim.save(filename, "ffmpeg"; kwargs...)
    else
        anim.save(filename, "imagemagick"; kwargs...)
    end
end


"""
    save_tikz(filename::String)

Saves the current figure to tex files. 
"""
function save_tikz(filename::String)
    open(filename, "w") do io
        write(io, tikz.get_tikz_code())
    end 
end