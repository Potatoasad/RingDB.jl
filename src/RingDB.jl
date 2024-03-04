module RingDB

using Conda, PyCall, DataFrames

function install() 
	Conda.pip_interop(true)
	Conda.pip("install", "git+https://github.com/maxisi/ringdown")
	Conda.pip("install", "git+https://github.com/Potatoasad/ringdb")
	Conda.add("astropy")
end


include("./Database.jl")
include("./Event.jl")
include("./Priors/redshift_priors.jl")



export install, Database, Event, Strain, PSD, Posteirors

end