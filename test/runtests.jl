using PyCall, DataFrames, RingDB, Test

include("test_LVK_compare.jl")
include("test_get_posteriors.jl")
include("test_transformations.jl")

@testset "Prior value Matches LVK up to constant factor" begin
   @test check_if_priors_match_LVK(rtol=1e-2)
end;

@testset "Get GW150914 posterior from database" begin
   @test get_GW150914_posteriors()
end;

@testset "Test Tranformations inverse is truly the inverse of forward" begin
   @test test_transformations()
end;



