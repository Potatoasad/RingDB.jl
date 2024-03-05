using Revise, RingDB

db = Database("/Users/asadh/Documents/Data/ringdb")
event = Event(db, "GW150914")
df = event.posteriors()

redshift_prior = EuclidianDistancePrior(:redshift, 3.0)

priors = [
	EuclidianDistancePrior(:redshift, 3.0),
	DetectorFrameMassesPrior(),
	FromSecondaryToMassRatio()
]

prior = ProductPrior(priors)

evaluate!(df, prior, :prior)


f(q) = ((q^3)/(1+q))^(1/5)

ToChirpDetector = Transformation(
	[:mass_1_source, :mass_ratio, :redshift],
	(m1,q,z) -> (m1*f(q)*(1+z), q, z),
	[:chirp_mass_det, :mass_ratio, :redshift],
	(M1,q,z) -> (M1/(f(q)*(1+z)), q, z)
)


forward(ToChirpDetector, df)