using DataFrames

abstract type AbstractPrior end

var_names(P::AbstractPrior) = P.var_names

function evaluate!(df::DataFrame, P::AbstractPrior, colname::Symbol)
	df[!, colname] = evaluate(df, P)
end

grab_data(df::DataFrame, colnames::Tuple) = Tuple(df[!, col] for col in colnames)


using PyCall
astropy = pyimport("astropy")
Planck15 = pyimport("astropy.cosmology.Planck15")
units = pyimport("astropy.units")

luminosity_distance(redshift) = py"$Planck15.luminosity_distance($redshift).to($units.Gpc).value"
efunc(redshift) = py"$Planck15.efunc($redshift)"
differential_comoving_volume(redshift) = py"$Planck15.differential_comoving_volume($redshift).value * 4 * $π / (1 + $redshift)"
d_H = py"$Planck15.hubble_distance.to(units.Gpc).value"


struct EuclidianDistancePrior{T} <: AbstractPrior
	var_names::T
end

function evaluate(df::DataFrame, P::EuclidianDistancePrior)
	(z,) = grab_data(df, P.var_names)
	dL = luminosity_distance(z)
	E = efunc(z)
	return dL**2 * ((dL / (1 + z)) + ((1 + z)*d_H/E))
end


struct ComovingDistancePrior{T} <: AbstractPrior
	var_names::T
end

function evaluate(df::DataFrame, P::ComovingDistancePrior)
	(z,) = grab_data(df, P.var_names)
	return differential_comoving_volume(z)
end
