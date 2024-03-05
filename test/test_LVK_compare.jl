LVK_posteriors_dir = joinpath(homedir(), "Documents/posteriors.pkl")

function check_if_priors_match_LVK(;rtol=1e-2, filepath=LVK_posteriors_dir)
	py"""
	import numpy as np

	posts = np.load($filepath, allow_pickle=True)
	"""

	function pandas_to_jl(df_pd)
		df= DataFrame()
	    for col in df_pd.columns
	        df[!, col] = getproperty(df_pd, col).values
	    end
	    df
	end

	all_posteriors = DataFrame[pandas_to_jl(py"posts[$i]") for i ∈ 0:68]

	max_z = maximum( maximum(post[!, :redshift]) * 1.01 for post ∈ all_posteriors ) 


	test_posterior = pandas_to_jl(py"posts[0]")

	priors = [
		EuclidianDistancePrior(:redshift, z_max=max_z),
		DetectorFrameMassesPrior(),
		FromSecondaryToMassRatio([:mass_1])
	]

	prior = ProductPrior(priors)

	evaluate!(test_posterior, prior, :prior_ringdb)

	test_posterior[!, :prior_ringdb_normalized] = test_posterior[!, :prior_ringdb] ./ test_posterior[1, :prior_ringdb]
	test_posterior[!, :prior_normalized] = test_posterior[!, :prior] ./ test_posterior[1, :prior]

	largest_relative_difference = maximum(@. abs((test_posterior[!, :prior_ringdb_normalized] - test_posterior[!, :prior_normalized])/test_posterior[!, :prior_normalized]))
	largest_relative_difference <= rtol
end