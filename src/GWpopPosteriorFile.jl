resolved_overlaps=Dict(
    "GW190413_052954" => "S190413i",
    "GW190413_134308" => "S190413ac",
    "GW190521" => "S190521g",
    "GW190521_074359" => "S190521r",
    "GW190828_063405" => "S190828j",
    "GW190828_065509" => "S190828l"
)


struct GWPopPosteriorFile{T,L,K}
	pickle_path::T
	eventnamepath::L
	posteriors::K
end

function GWPopPosteriorFile(pickle_path, eventnamepath)
	lines = readlines(eventnamepath)
	eventnames = [split(x, ":")[1] for x in lines]
	pd = pyimport("pandas")
	np = pyimport("numpy")
	posteriors = np.load(pickle_path, allow_pickle=true)
	posterior_dict = Dict()
	for (i,event) ∈ enumerate(eventnames)
		posterior_dict[event] = pandas_to_jl(posteriors[i])
	end
	GWPopPosteriorFile(pickle_path, eventnamepath, posterior_dict)
end