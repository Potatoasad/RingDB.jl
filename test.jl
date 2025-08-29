using PythonCall
using LinearAlgebra

astropy = @pyconst(pyimport("astropy"))
units = @pyconst(pyimport("astropy.units"))
cosmo = @pyconst(pyimport("astropy.cosmology"))
Planck15 = cosmo.Planck15
np = @pyconst(pyimport("numpy"))

d_H = pyconvert(Float64, @pyconst(cosmo.Planck15.hubble_distance.to(units.Gpc).value))

make_1D_array(x) = pyconvert(Vector{Float64}, x);
luminosity_distance(redshift) = Planck15.luminosity_distance(np.array(redshift)).to(units.Gpc).value |> make_1D_array
efunc(redshift) = Planck15.efunc(np.array(redshift)) |> make_1D_array
differential_comoving_volume(redshift) = make_1D_array(Planck15.differential_comoving_volume(np.array(redshift)).value) .* 4 .* π ./ (1 .+ redshift)


z = LinRange(0,1,100) |> collect


@show luminosity_distance(z)
@show efunc(z)
@show differential_comoving_volume(z)