using Revise, RingDB

db = Database("/Users/asadh/Documents/Data/ringdb")
event = Event(db, "GW150914")
df = event.posteriors()

redshift_prior = EuclidianDistancePrior(:redshift, 3.0)


evaluate!(df, redshift_prior, :prior_redshift)
