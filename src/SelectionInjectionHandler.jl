using HDF5, DataFrames

abstract type AbstractSelectionInjections end

filepath(SI::AbstractSelectionInjections) = SI.filepath

function download_file(A::AbstractSelectionInjections; overwrite=false)
	selection_file = filepath(A)
	if !isfile(selection_file) | overwrite
		url = download_link(A)
    	println("Downloading the selection injections file (~88.0 MB) may take a while...")
    	download(url , selection_file);
	end
end

function get_injections(A::AbstractSelectionInjections; overwrite=false)
	selection_file = filepath(A)
	download_file(A; overwrite=overwrite)

	fid = h5open(selection_file, "r")

	cols = keys(fid["injections"])
	df_selections = DataFrame([fid["injections"][col][:] for col ∈ cols], cols)
	#N_draws = read_attribute(fid, "total_generated")

	close(fid)

	return df_selections
end


function get_N_draws(A::AbstractSelectionInjections; overwrite=false)
	selection_file = filepath(A)
	download_file(A; overwrite=overwrite)

	fid = h5open(selection_file, "r")

	#cols = keys(fid["injections"])
	#df_selections = DataFrame([fid["injections"][col][:] for col ∈ cols], cols)
	N_draws = read_attribute(fid, "total_generated")

	close(fid)

	return N_draws
end

get_total_generated = get_N_draws

function get_analysis_time(A::AbstractSelectionInjections; overwrite=false)
	selection_file = filepath(A)
	download_file(A; overwrite=overwrite)

	fid = h5open(selection_file, "r")

	#cols = keys(fid["injections"])
	#df_selections = DataFrame([fid["injections"][col][:] for col ∈ cols], cols)
	analysis_time_yr = read_attribute(fid, "analysis_time_s")  / 365.25 / 24 / 60 / 60

	close(fid)

	return analysis_time_yr
end




function implement_cuts(df_selections; ifar_threshold = 1, snr_threshold = 11, m_min = 2.0, m_max=100.0, z_max = 3.0)
	ifar_keys = [name for name in names(df_selections) if occursin("ifar", name)]

	### Selecting due to FAR estimates
	detected_mask = BitVector(undef, nrow(df_selections))
	for k in 1:length(detected_mask)
	    detected_mask[k] = reduce(.|, [(df_selections[k, ifar_key] > ifar_threshold) for ifar_key ∈ ifar_keys] ) 
	end
	gwtc_1 = (df_selections[!, "name"] .== "o1") .| (df_selections[!, "name"] .== "o2")
	snr_cuts = df_selections[!, "optimal_snr_net"] .> snr_threshold
	detected_mask = detected_mask .| ( gwtc_1 .& (snr_cuts))

	df_detected = df_selections[detected_mask, :];


	select!(df_detected, :, [:spin1x, :spin1y, :spin1z] => ByRow((x,y,z) -> √(x^2 + y^2 + z^2)) => :chi_1)
	select!(df_detected, :, [:spin2x, :spin2y, :spin2z] => ByRow((x,y,z) -> √(x^2 + y^2 + z^2)) => :chi_2)
	select!(df_detected, :, [:mass1_source, :mass2_source] => ByRow((m₁, m₂) -> m₂/m₁) => :mass_ratio)
	select!(df_detected, :, [:mass1_source, :mass_ratio] => ByRow((m₁,q) -> (m₁ * (q^3 / (1+q))^(1/5))) => :chirp_mass)

	m_cutoff_det = (df_detected[!, :mass2_source] .≥ m_min) .& (df_detected[!, :mass1_source] .≤ m_max)
	z_cutoff_det = df_detected[!, :redshift] .≤ z_max;

	df_detected = df_detected[m_cutoff_det .& z_cutoff_det, :]
	return df_detected
end




struct O3_sensitivity{T} <: AbstractSelectionInjections 
	filepath::T
end
const O3_sensitivity_link = "https://zenodo.org/record/5546676/files/endo3_bbhpop-LIGO-T2100113-v12.hdf5"
download_link(x::O3_sensitivity) = O3_sensitivity_link


struct O3a_sensitivity{T} <: AbstractSelectionInjections 
	filepath::T
end
const O3a_sensitivity_link = "https://zenodo.org/record/5546676/files/endo3_bbhpop-LIGO-T2100113-v12-1238166018-15843600.hdf5"
download_link(x::O3a_sensitivity) = O3a_sensitivity_link



struct O3b_sensitivity{T} <: AbstractSelectionInjections 
	filepath::T
end
const O3b_sensitivity_link = "https://zenodo.org/record/5546676/files/endo3_bbhpop-LIGO-T2100113-v12-1256655642-12905976.hdf5"
download_link(x::O3b_sensitivity) = O3b_sensitivity_link


struct O1_O2_O3_sensitivity{T} <: AbstractSelectionInjections 
	filepath::T
end
const O1_O2_O3_sensitivity_link = "https://zenodo.org/record/5636816/files/o1%2Bo2%2Bo3_bbhpop_real%2Bsemianalytic-LIGO-T2100377-v2.hdf5"
download_link(x::O1_O2_O3_sensitivity) = O1_O2_O3_sensitivity_link