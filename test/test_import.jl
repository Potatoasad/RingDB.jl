using Revise, RingDB

db = Database("/Users/asadh/Documents/Data/ringdb")
event = Event(db, "GW150914")
df = event.posteriors()