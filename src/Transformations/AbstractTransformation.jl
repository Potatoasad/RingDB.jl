abstract type AbstractTransformation end

forward(Tr::AbstractTransformation) = Tr.forward
domain_columns(Tr::AbstractTransformation) = Tr.domain_columns
inverse(Tr::AbstractTransformation) = Tr.inverse
image_columns(Tr::AbstractTransformation) = Tr.image_columns

function forward(Tr::AbstractTransformation, df::DataFrame)
	F = forward(Tr)
	X = F.(Tuple(df[!, col] for col ∈ domain_columns(Tr))...)
	ys = image_columns(Tr)
	DataFrame(X, ys)
end

function inverse(Tr::AbstractTransformation, df::DataFrame)
	F = inverse(Tr)
	X = F.(Tuple(df[!, col] for col ∈ image_columns(Tr))...)
	ys = domain_columns(Tr)
	DataFrame(X, ys)
end


struct Transformation{A,B,C,D} <: AbstractTransformation
	domain_columns::A
	forward::B
	image_columns::C
	inverse::D
end