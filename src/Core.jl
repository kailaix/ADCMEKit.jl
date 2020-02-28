export linedata, lineview, meshdata, meshview, gradview
function linedata(θ1, θ2=nothing; n = 10)
    if θ2 === nothing
        θ2 = θ1 .* (1 .+ randn(size(θ1)...))
    end
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

function meshdata(θ, a=1, b=1, m=10, n=10)
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

function meshview(losses, a=1, b=1)
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

function gradview(sess, pl, grad, loss, u0)
    v = rand(length(u0))
    γs = 1.0 ./ 10 .^ (1:5)
    v1 = Float64[]
    v2 = Float64[]
    L_, J_ = run(sess, [loss, grad], pl=>u0)
    for i = 1:5
        @info i 
        L__ = run(sess, loss, pl=>u0+v*γs[i])
        push!(v1, norm(L__-L_))
        if size(J_)==size(v)
            push!(v2, norm(L__-L_-γs[i]*sum(J_.*v)))
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
end