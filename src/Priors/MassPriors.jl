struct DetectorFrameMassesPrior{T} <: AbstractPrior
	var_names::T
end

DetectorFrameMassesPrior(;var_names=[:redshift]) = DetectorFrameMassesPrior(var_names)

function evaluate(df::DataFrame, P::DetectorFrameMassesPrior)
	(z,) = grab_data(df, P.var_names)
	return @. (1 + z)^2
end


FromDetectorMassToSourceMass = DetectorFrameMassesPrior


struct FromSecondaryToMassRatio{T} <: AbstractPrior
	var_names::T
end

FromSecondaryToMassRatio(;var_names=[:mass_1_source]) = FromSecondaryToMassRatio(var_names)

function evaluate(df::DataFrame, P::FromSecondaryToMassRatio)
	(m1,) = grab_data(df, P.var_names)
	return @. (m1)
end