function test_transformations()
	masses = LinRange(5,100,1000)
	mass_ratios = LinRange(0.001,1,1000)
	redshift = LinRange(0.001,3,1000)
	df = DataFrame(
		Dict(
			:mass_1_source => masses,
			:mass_ratio => mass_ratios,
			:redshift => redshift
			)
		)


	f(q) = ((q^3)/(1+q))^(1/5)

	ToChirpDetector = Transformation(
		[:mass_1_source, :mass_ratio, :redshift],
		(m1,q,z) -> (m1*f(q)*(1+z), q, z),
		[:chirp_mass_det, :mass_ratio, :redshift],
		(M1,q,z) -> (M1/(f(q)*(1+z)), q, z)
	)


	final_df = inverse(ToChirpDetector, forward(ToChirpDetector, df))

	all(all(abs.(final_df[!, col] .- df[!, col]) .<= 1e-3) for col ∈ [:mass_1_source, :mass_ratio, :redshift])
end