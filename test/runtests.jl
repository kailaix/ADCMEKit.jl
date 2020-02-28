using LandscapeView
using LinearAlgebra
using Test

loss1 = x->sum(x.^2-0.1*x)
v = linedata(zeros(10), rand(10))
l = loss1.(v)
lineview(l)

close("all")
v = landscapedata(zeros(10))
l = loss1.(v)
landscapeview(l)