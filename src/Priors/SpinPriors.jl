struct ComponentSpinPrior{T} <: AbstractPrior
    var_names::T
end

ComponentSpinPrior(;var_names=[]) = ComponentSpinPrior(var_names)
evaluate(df::DataFrame, P::ComponentSpinPrior) = ones(nrow(df)) ./ 4

struct FromSpinComponentToSpinMagnitude{T} <: AbstractPrior
    var_names::T
end

FromSpinComponentToSpinMagnitude(;var_names=[:chi_1,:chi_2]) = FromSpinComponentToSpinMagnitude(var_names)
product_together(iter) = reduce((x, y) -> x .* y, iter)
evaluate(df::DataFrame, P::FromSpinComponentToSpinMagnitude) = product_together( (@. 2π * χ^2) for χ ∈ grab_data(df, P.var_names))
