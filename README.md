# ADCMEKit

ADCMEKit is used to plot the loss landscape. 

`linedata(a, b)`: generate (1-α)a+αb as a function of α

`meshview(a)`: generate a `m×n` matrix in the neighborhood of `a`

```julia
loss1 = x->sum(x.^2-0.1*x)
v = linedata(zeros(10), rand(10))
l = loss1.(v)
lineview(l)

close("all")
v = landscapedata(zeros(10))
l = loss1.(v)
meshview(l)
```



| `lineview`           | `meshview`      |
| -------------------- | -------------------- |
| ![](./others/f1.png) | ![](./others/f2.png) |


`gradview(sess, pl, loss, u0)`: use with ADCME.jl to test gradients

```julia
pl = placeholder(Float64, shape=[2])
l = sum(pl^2-pl*0.1)
sess = Session(); init(sess)
gradview(sess, pl, l, rand(2))
```
![](./others/f3.png)
