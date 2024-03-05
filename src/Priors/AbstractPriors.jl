abstract type AbstractPrior end

var_names(P::AbstractPrior) = P.var_names

function evaluate!(df::DataFrame, P::AbstractPrior, colname::Symbol)
	df[!, colname] = evaluate(df, P)
end

grab_data(df::DataFrame, colnames) = Tuple(df[!, col] for col in colnames)
