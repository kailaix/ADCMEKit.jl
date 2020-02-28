export linedata, lineview, landscapedata, landscapeview
function linedata(θ1, θ2; n = 20)
    T = []
    for x in LinRange(0.0,1.0,n)
        push!(T, θ1*(1-x)+θ2*x)
    end
    T
end

function lineview(losses)
    n = length(losses)
    v = collect(LinRange(0.0,1.0,n))
    plot(v, losses)
    xlabel("\$\\alpha\$")
    ylabel("loss")
    grid("on")
end

function landscapedata(θ, a=1, b=1, m=20, n=20)
    as = LinRange(-a, a, m)
    bs = LinRange(-b, b, n)
    α = zeros(m, n)
    β = zeros(m, n)
    θs = Array{Any}(undef, m, n)
    δ = randn(size(θ)...)
    γ = randn(size(θ)...)
    for i = 1:m 
        for j = 1:n 
            α[i,j] = as[i]
            β[i,j] = bs[j]
            θs[i,j] = θ + δ*as[i] + γ*bs[j]
        end
    end
    return θs
end

function landscapeview(losses, a=1, b=1)
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
end