export linedata, lineview, meshdata, meshview, gradview, jacview, PCLview, pcolormeshview
function linedata(θ1, θ2=nothing; n::Integer = 10)
    if θ2 === nothing
        θ2 = θ1 .* (1 .+ randn(size(θ1)...))
    end
    T = []
    for x in LinRange(0.0,1.0,n)
        push!(T, θ1*(1-x)+θ2*x)
    end
    T
end

function lineview(losses::Array{Float64})
    n = length(losses)
    v = collect(LinRange(0.0,1.0,n))
    close("all")
    plot(v, losses)
    xlabel("\$\\alpha\$")
    ylabel("loss")
    grid("on")
end


@docs raw"""
    lineview(sess::PyObject, pl::PyObject, loss::PyObject, θ1, θ2=nothing; n::Integer = 10)

Plots the function 

$$h(α) = f((1-α)θ_1 + αθ_2)$$

# Example
```julia
pl = placeholder(Float64, shape=[2])
l = sum(pl^2-pl*0.1)
sess = Session(); init(sess)
lineview(sess, pl, l, rand(2))
```
"""
function lineview(sess::PyObject, pl::PyObject, loss::PyObject, θ1, θ2=nothing; n::Integer = 10)
    dat = linedata(θ1, θ2, n=n)
    V = zeros(length(dat))
    for i = 1:length(dat)
        @info i, n 
        V[i] = run(sess, loss, pl=>dat[i])
    end
    lineview(V)
end

function meshdata(θ;
     a::Real=1, b::Real=1, m::Integer=10, n::Integer=10 ,direction::Union{Array{<:Real}, Missing}=missing)
    local δ, γ
    as = LinRange(-a, a, m)
    bs = LinRange(-b, b, n)
    α = zeros(m, n)
    β = zeros(m, n)
    θs = Array{Any}(undef, m, n)
    if !ismissing(direction)
        δ = direction - θ
        γ =    randn(size(θ)...)
        γ = γ/norm(γ)*norm(δ)
    else
        δ = randn(size(θ)...)
        γ = randn(size(θ)...)
    end
    for i = 1:m 
        for j = 1:n 
            α[i,j] = as[i]
            β[i,j] = bs[j]
            θs[i,j] = θ + δ*as[i] + γ*bs[j]
        end
    end
    return θs
end

function meshview(losses::Array{Float64}, a::Real=1, b::Real=1)
    m, n = size(losses)
    α = zeros(m, n)
    β = zeros(m, n)
    as = LinRange(-a, a, m)
    bs = LinRange(-b, b, n)
    for i = 1:m 
        for j = 1:n 
            α[i,j] = as[i]
            β[i,j] = bs[j]
        end
    end
    close("all")
    mesh(α, β, losses)
    xlabel("\$\\alpha\$")
    ylabel("\$\\beta\$")
    zlabel("loss")
    scatter3D(α[m÷2, n÷2], β[m÷2, n÷2], losses[m÷2, n÷2], color="red", s=100)
    return α, β, losses
end

function pcolormeshview(losses::Array{Float64}, a::Real=1, b::Real=1)
    m, n = size(losses)
    α = zeros(m, n)
    β = zeros(m, n)
    as = LinRange(-a, a, m)
    bs = LinRange(-b, b, n)
    for i = 1:m 
        for j = 1:n 
            α[i,j] = as[i]
            β[i,j] = bs[j]
        end
    end
    close("all")
    pcolormesh(α, β, losses)
    xlabel("\$\\alpha\$")
    ylabel("\$\\beta\$")
    scatter(0.0,0.0, marker="*", s=100)
    colorbar()
    return α, β, losses
end

function meshview(sess::PyObject, pl::PyObject, loss::PyObject, θ; 
        a::Real=1, b::Real=1, m::Integer=9, n::Integer=9, 
        direction::Union{Array{<:Real}, Missing}=missing)
    dat = meshdata(θ; a=a, b=b, m=m, n=n, direction=direction)
    m, n = size(dat)
    V = zeros(m, n)
    for i = 1:m 
        @info i, m
        for j = 1:n 
            V[i,j] = run(sess, loss, pl=>dat[i,j])
        end
    end
    meshview(V, a, b)
end

function pcolormeshview(sess::PyObject, pl::PyObject, loss::PyObject, θ; 
    a::Real=1, b::Real=1, m::Integer=9, n::Integer=9, 
    direction::Union{Array{<:Real}, Missing}=missing)
    dat = meshdata(θ; a=a, b=b, m=m, n=n, direction=direction)
    m, n = size(dat)
    V = zeros(m, n)
    for i = 1:m 
        @info i, m
        for j = 1:n 
            V[i,j] = run(sess, loss, pl=>dat[i,j])
        end
    end
    pcolormeshview(V, a, b)
end


function gradview(sess::PyObject, pl::PyObject, loss::PyObject, u0, grad::PyObject; 
    scale::Float64 = 1.0)
    local v 
    if length(size(u0))==0
        v = rand()
    else
        v = rand(length(u0))
    end
    γs = scale ./ 10 .^ (1:5)
    v1 = Float64[]
    v2 = Float64[]
    L_, J_ = run(sess, [loss, grad], pl=>u0)
    for i = 1:5
        @info i 
        L__ = run(sess, loss, pl=>u0+v*γs[i])
        push!(v1, norm(L__-L_))
        if size(J_)==size(v)
            if length(size(J_))==0
                push!(v2, norm(L__-L_-γs[i]*sum(J_*v)))
            else
                push!(v2, norm(L__-L_-γs[i]*sum(J_.*v)))
            end
        else
            push!(v2, norm(L__-L_-γs[i]*J_*v))
        end

    end
    close("all")
    loglog(γs, abs.(v1), "*-", label="finite difference")
    loglog(γs, abs.(v2), "+-", label="automatic linearization")
    loglog(γs, γs.^2 * 0.5*abs(v2[1])/γs[1]^2, "--",label="\$\\mathcal{O}(\\gamma^2)\$")
    loglog(γs, γs * 0.5*abs(v1[1])/γs[1], "--",label="\$\\mathcal{O}(\\gamma)\$")
    plt.gca().invert_xaxis()
    legend()
    xlabel("\$\\gamma\$")
    ylabel("Error")
    return v1, v2
end

function gradview(sess::PyObject, pl::PyObject, loss::PyObject, u0; scale::Float64 = 1.0)
    grad = tf.convert_to_tensor(gradients(loss, pl))
    gradview(sess, pl, loss, u0, grad, scale = scale)
end


@doc raw"""
```julia
u0 = rand(10)
function verify_jacobian_f(θ, u)
    r = u^3+u - u0
    r, spdiag(3u^2+1.0)
end
verify_jacobian(sess, verify_jacobian_f, missing, u0); close("all")

# least square
u0 = rand(10)
rs = rand(10)
function verify_jacobian_f(θ, u)
    r = [u^2;u] - [rs;rs]
    r, [spdiag(2*u); spdiag(10)]
end
verify_jacobian(sess, verify_jacobian_f, missing, u0); close("all")
```
"""
function jacview(sess::PyObject, f::Function, θ::Union{Array{Float64}, PyObject, Missing}, 
                u0::Array{Float64}, args...)
    u = placeholder(Float64, shape=[length(u0)])
    L, J = f(θ, u)
    init(sess)
    L_ = run(sess, L, u=>u0, args...)
    J_ = run(sess, J, u=>u0, args...)
    v = rand(length(u0))
    γs = 1.0 ./ 10 .^ (1:5)
    v1 = Float64[]
    v2 = Float64[]
    for i = 1:5
        L__ = run(sess, L, u=>u0+v*γs[i], args...)
        push!(v1, norm(L__-L_))
        push!(v2, norm(L__-L_-γs[i]*J_*v))
    end
    close("all")
    loglog(γs, abs.(v1), "*-", label="finite difference")
    loglog(γs, abs.(v2), "+-", label="automatic linearization")
    loglog(γs, γs.^2 * 0.5*abs(v2[1])/γs[1]^2, "--",label="\$\\mathcal{O}(\\gamma^2)\$")
    loglog(γs, γs * 0.5*abs(v1[1])/γs[1], "--",label="\$\\mathcal{O}(\\gamma)\$")
    plt.gca().invert_xaxis()
    legend()
    xlabel("\$\\gamma\$")
    ylabel("Error")
end


function PCLview(sess::PyObject, f::Function, L::Function, θ::Union{PyObject,Array{Float64,1}, Float64}, 
    u0::Union{PyObject, Array{Float64}}, args...; options::Union{Dict{String, T}, Missing}=missing) where T<:Real
    if isa(θ, PyObject)
        θ = run(sess, θ, args...)
    end
    x = placeholder(Float64, shape=[length(θ)])
    l, u, g = NonlinearConstrainedProblem(f, L, x, u0; options=options)
    init(sess)
    L_ = run(sess, l, x=>θ, args...)
    J_ = run(sess, g, x=>θ, args...)
    v = rand(length(x))
    γs = 1.0 ./ 10 .^ (1:5)
    v1 = Float64[]
    v2 = Float64[]
    for i = 1:5
        @info i 
        L__ = run(sess, l, x=>θ+v*γs[i], args...)
        # @show L__,L_,J_, v
        push!(v1, L__-L_)
        push!(v2, L__-L_-γs[i]*sum(J_.*v))
    end
    close("all")
    loglog(γs, abs.(v1), "*-", label="finite difference")
    loglog(γs, abs.(v2), "+-", label="automatic linearization")
    loglog(γs, γs.^2 * 0.5*abs(v2[1])/γs[1]^2, "--",label="\$\\mathcal{O}(\\gamma^2)\$")
    loglog(γs, γs * 0.5*abs(v1[1])/γs[1], "--",label="\$\\mathcal{O}(\\gamma)\$")
    plt.gca().invert_xaxis()
    legend()
    xlabel("\$\\gamma\$")
    ylabel("Error")
end