__precompile__()
module RingDB

using Conda, PyCall, DataFrames

#const ringdb = PyNULL()
#const astropy = PyNULL()
#const units = PyNULL()
#const Planck15 = PyNULL()

"""function __init__()
	copy!(ringdb, pyimport("ringdb"))
	copy!(astropy, pyimport_conda("astropy", "astropy"))
	#copy!(units, astropy.units)
	#copy!(Planck15, astropy.cosmology.Planck15)
end"""


"""
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
		#copy!(units, pyimport_conda("astropy.units", "astropy"))
		#copy!(Planck15, pyimport_conda("astropy.cosmology.Planck15", "astropy"))
	catch
		Conda.pip_interop(true)
		#Conda.add("astropy")
		copy!(astropy, pyimport_conda("astropy", "astropy"))
		copy!(units, pyimport_conda("astropy.units", "astropy"))
		copy!(Planck15, pyimport_conda("astropy.cosmology.Planck15", "astropy"))
	end
end
?"""

const scipy_opt = PyNULL()

"""
function __init__()
    copy!(scipy_opt, pyimport("astropy"))
end
"""

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
include("./Priors/AbstractPriors.jl")
include("./Priors/RedshiftPriors.jl")


export ringdb, astropy, units, Planck15, GLOBAL_CONSTS
export install, Database, Event, Strain, PSD, Posteriors
export EuclidianDistancePrior, ComovingDistancePrior, evaluate, evaluate!

end