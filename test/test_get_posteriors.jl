
ringdb_database_dir = joinpath(homedir(), "Documents/Data/ringdb")


function get_GW150914_posteriors(ringdb_database_dir=ringdb_database_dir)
	db = Database(ringdb_database_dir)
	event = Event(db, "GW150914")
	df = event.posteriors()
	true
end