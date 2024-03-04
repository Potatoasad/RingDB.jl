using Revise, RingDB

db = Database("/Users/asadh/Documents/Data/ringdb")
#event = db.event("GW150914")
event = Event(db, "GW150914")