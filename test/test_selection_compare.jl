LVK_selection_dir = joinpath(homedir(), "/Users/asadh/Documents/Data/gwpop_selection_samples_w_prior.csv")

using DataFrames, CSV, RingDB


df = DataFrame(CSV.File(LVK_selection_dir))


path = "/Users/asadh/Downloads/o1+o2+o3_bbhpop_real+semianalytic-LIGO-T2100377-v2.hdf5"
columns = [:mass_1_source, :mass_ratio, :chi_1, :chi_2, :cos_tilt_1, :cos_tilt_2, :redshift, :prior]

## Get Data
catalog = O1_O2_O3_sensitivity(path)
df_selections = get_injections(catalog)
analysis_time = get_analysis_time(catalog)
total_generated = get_total_generated(catalog)

#N_samples_to_fit_with = 30_000

## Implement Cuts
df_detected = implement_cuts(df_selections; ifar_threshold = 1, snr_threshold = 11, m_min = 2.0, m_max=100.0, z_max = 1.9)
rename!(df_detected, :mass1_source  => :mass_1_source)
#rename!(df_detected, :sampling_pdf  => :prior) <-this  is wrong!!
select!(df_detected, :, [:sampling_pdf, :mass_1_source] => ByRow((p,m1) -> p*m1) => :prior)
select!(df_detected, :, [:prior, :chi_1] => ByRow((p,χ₁) -> p*2π*χ₁^2) => :prior)
select!(df_detected, :, [:prior, :chi_2] => ByRow((p,χ₂) -> p*2π*χ₂^2) => :prior)

df_detected