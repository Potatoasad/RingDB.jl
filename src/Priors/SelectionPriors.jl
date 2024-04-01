struct InjectionSamplingPDF{T} <: AbstractPrior
    var_names::T
end

InjectionSamplingPDF(;var_names=[:sampling_pdf]) = InjectionSamplingPDF(var_names)
evaluate(df::DataFrame, P::InjectionSamplingPDF) = df[!, P.var_names[1]]