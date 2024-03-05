using DataFrames, Interpolations, Trapz

luminosity_distance(redshift) = py"$Planck15.luminosity_distance($redshift).to($units.Gpc).value"
efunc(redshift) = py"$Planck15.efunc($redshift)"
differential_comoving_volume(redshift) = py"$Planck15.differential_comoving_volume($redshift).value * 4 * $π / (1 + $redshift)"

function euclidian_distance_prior(z)
	dL = luminosity_distance(z)
	E = efunc(z)
	d_H = GLOBAL_CONSTS[:d_H]
	return @. ( dL^2 * ((dL / (1 + z)) + ((1 + z)*d_H/E)) )
end

const DZ_INTERPOLANT = 1e-3

struct EuclidianDistancePrior{T,L,K} <: AbstractPrior
	var_names::T
	z_max::L
	interpolant::K
end

EuclidianDistancePrior(var_names::T; z_max=3.0) where T = EuclidianDistancePrior(var_names, z_max)
EuclidianDistancePrior(var_names::T, z_max::L) where {T <: Union{Symbol, AbstractString}, L} = EuclidianDistancePrior([var_names], z_max)

function EuclidianDistancePrior(var_names::T, z_max::L) where {T <: AbstractVector, L}
	z_grid = 0.0:DZ_INTERPOLANT:z_max
	prior = euclidian_distance_prior(z_grid)
	prior = prior ./ trapz(prior, z_grid)
	interpolant = linear_interpolation(z_grid, prior)
	EuclidianDistancePrior(var_names, z_max, interpolant)
end

function evaluate(df::DataFrame, P::EuclidianDistancePrior)
	(z,) = grab_data(df, P.var_names)
	P.interpolant(z)
end






struct ComovingDistancePrior{T,L,K} <: AbstractPrior
	var_names::T
	z_max::L
	interpolant::K
end

ComovingDistancePrior(var_names::T; z_max=3.0) where T = ComovingDistancePrior(var_names, z_max)
ComovingDistancePrior(var_names::T, z_max::L) where {T <: Union{Symbol, AbstractString}, L} = ComovingDistancePrior([var_names], z_max)
function ComovingDistancePrior(var_names::T, z_max::L) where {T <: AbstractVector, L}
	z_grid = 0.0:DZ_INTERPOLANT:z_max
	prior = differential_comoving_volume(z_grid)
	prior = prior ./ trapz(prior, z_grid)
	interpolant = linear_interpolation(z_grid, prior)
	ComovingDistancePrior(var_names, z_max, interpolant)
end

function evaluate(df::DataFrame, P::ComovingDistancePrior)
	(z,) = grab_data(df, P.var_names)
	return differential_comoving_volume(z)
end
