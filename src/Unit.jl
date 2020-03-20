import Unitful
export Unit, value

Unit = Unitful 

function value(p::Unit.Quantity)
    return Unit.upreferred(p).val|>float
end