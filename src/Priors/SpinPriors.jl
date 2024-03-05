if args.spin_prior.lower() == "component":
            post["prior"] /= 4
        if "chi_1" in args.parameters:
            post["prior"] *= aligned_spin_prior(post["chi_1"])
        if "chi_2" in args.parameters:
            post["prior"] *= aligned_spin_prior(post["chi_2"])



struct ComponentSpinPrior
    var_names
end

ComponentSpinPrior(;var_names=[]) = ComponentSpinPrior(var_names)
evaluate(df::DataFrame, P::ComponentSpinPrior) = ones(nrow(df)) ./ 4