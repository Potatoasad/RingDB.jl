__precompile__()
module RingDB

using Conda, PyCall, DataFrames

const ringdb = PyNULL()
const astropy = PyNULL()
const units = PyNULL()
const Planck15 = PyNULL()
const GLOBAL_CONSTS = Dict{Symbol, Float64}()

function __init__()
	try
		copy!(ringdb, pyimport("ringdb"))
	catch
		Conda.pip_interop(true)
		Conda.pip("install", "git+https://github.com/maxisi/ringdown")
		Conda.pip("install", "git+https://github.com/Potatoasad/ringdb");
		copy!(ringdb, pyimport("ringdb"))
	end

	try
		copy!(astropy, pyimport_conda("astropy", "astropy"))
		copy!(units, pyimport_conda("astropy.units", "astropy"))
		cosmo = pyimport_conda("astropy.cosmology", "astropy")
		copy!(Planck15, cosmo.Planck15)
		GLOBAL_CONSTS[:d_H] = py"$Planck15.hubble_distance.to($units.Gpc).value"
	catch
		Conda.pip_interop(true)
		#Conda.add("astropy")
		copy!(astropy, pyimport_conda("astropy", "astropy"))
		copy!(units, pyimport_conda("astropy.units", "astropy"))
		cosmo = pyimport_conda("astropy.cosmology", "astropy")
		copy!(Planck15, cosmo.Planck15)
		GLOBAL_CONSTS[:d_H] = py"$Planck15.hubble_distance.to($units.Gpc).value"
	end
end





include("./Database.jl")
include("./Event.jl")
include("./SelectionInjectionHandler.jl")
include("./Priors/AbstractPriors.jl")
include("./Priors/RedshiftPriors.jl")
include("./Priors/MassPriors.jl")
include("./GWpopPosteriorFile.jl")
include("./Transformations/AbstractTransformation.jl")


export ringdb, astropy, units, Planck15, GLOBAL_CONSTS
export install, Database, Event, Strain, PSD, Posteriors
export AbstractPrior, IdentityPrior, ProductPrior
export EuclidianDistancePrior, ComovingDistancePrior
export DetectorFrameMassesPrior, FromSecondaryToMassRatio
export evaluate, evaluate!
export AbstractTransformation, Transformation, forward, inverse, domain_columns, image_columns, to_chirp_mass
export download_file, get_injections, get_N_draws, implement_cuts, get_total_generated, get_analysis_time
export AbstractSelectionInjections, O3_sensitivity, O3a_sensitivity, O3b_sensitivity, O1_O2_O3_sensitivity
export GWPopPosteriorFile

end