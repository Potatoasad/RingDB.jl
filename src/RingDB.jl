module RingDB

using Conda, PyCall, DataFrames

function install() 
	Conda.pip_interop(true)
	Conda.pip("install", "git+https://github.com/maxisi/ringdown")
	Conda.pip("install", "git+https://github.com/Potatoasad/ringdb")
end


include("./Database.jl")
include("./Event.jl")




export install, Database, Event, Strain, PSD, Posteirors

end