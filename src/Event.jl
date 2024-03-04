
abstract type PythonMethodMimic end

(P::PythonMethodMimic)(x...) = P.object(x...)

struct Posteriors{T} <: PythonMethodMimic
	object::T
end

function pandas_to_jl(df_pd)
	df= DataFrame()
    for col in df_pd.columns
        df[!, col] = getproperty(df_pd, col).values
    end
    df
end

(P::Posteriors)() = P.object() |> pandas_to_jl


struct Strain{T} <: PythonMethodMimic
	object::T
end

struct PSD{T} <: PythonMethodMimic
	object::T
end



struct Event{T,L1, L2, L3} 
	name::T
	posteriors::L1
	strain::L2
	psd::L3
end

Event(py_event) = Event(string(py_event.name), Posteriors(py_event.posteriors), Strain(py_event.strain), PSD(py_event.psd))

Event(db::Database, eventname) = Event(db.event(string(eventname)))