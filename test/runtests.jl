using ADCMEKit
using LinearAlgebra
using Test

loss1 = x->sum(x.^2-0.1*x)
v = linedata(zeros(10), rand(10))
l = loss1.(v)
lineview(l)

close("all")
v = meshdata(zeros(10))
l = loss1.(v)
meshview(l)

close("all")
v = meshdata(zeros(10))
l = loss1.(v)
pcolormeshview(l)

# pl = placeholder(Float64, shape=[2])
# l = sum(pl^2-pl*0.1)
# g = gradients(l, pl)
# sess = Session(); init(sess)
# gradview(sess, pl, g, l, rand(2))