abstract type AbstractPrior end

var_names(P::AbstractPrior) = P.var_names

function evaluate!(df::DataFrame, P::AbstractPrior, colname::Symbol)
	df[!, colname] = evaluate(df, P)
end

grab_data(df::DataFrame, colnames) = Tuple(df[!, col] for col in colnames)


struct IdentityPrior <: AbstractPrior end

evaluate(df::DataFrame, P::IdentityPrior) = ones(nrow(df))

var_names(P::IdentityPrior) = []


struct ProductPrior{T} <: AbstractPrior
	priors::T
end

function evaluate(df::DataFrame, P::ProductPrior)
	prior_values = ones(nrow(df))
	for prior ∈ P.priors
		prior_values .*= evaluate(df, prior)
	end
	return prior_values
end


