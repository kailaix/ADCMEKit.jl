# LandscapeView

LandscapeView is used to plot the loss landscape. 

`linedata(a, b)`: generate (1-α)a+αb as a function of α

`landscapeview(a)`: generate a `m×n` matrix in the neighborhood of `a`

```julia
loss1 = x->sum(x.^2-0.1*x)
v = linedata(zeros(10), rand(10))
l = loss1.(v)
lineview(l)

close("all")
v = landscapedata(zeros(10))
l = loss1.(v)
landscapeview(l)
```



| `lineview`           | `landscapeview`      |
| -------------------- | -------------------- |
| ![](./others/f1.png) | ![](./others/f2.png) |

