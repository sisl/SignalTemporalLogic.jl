### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 752d2f6b-a2bb-45bc-9fac-299f88d13f00
using Test

# ╔═╡ 39ceaac5-1084-44fa-9388-18593600eb11
using Plots; default(fontfamily="Computer Modern", framestyle=:box) # LaTex-style

# ╔═╡ e74099af-ea14-46d6-a61d-d71d176f5e45
using LaTeXStrings

# ╔═╡ ab57fd9b-9bec-48fc-8530-483a5d4ddb11
using Statistics

# ╔═╡ d06d3ce6-d13b-4ab6-bb66-8a07835e1ce7
using LinearAlgebra

# ╔═╡ d8a7facd-1ad8-413d-9037-054472fdc50f
md"""
# STL Formula Testing
"""

# ╔═╡ d383bf0a-3ff1-46d5-b285-63a803463bc0
x = [-0.25, 0, 0.1, 0.6, 0.75, 1.0]

# ╔═╡ c27ce933-8a2f-4384-bb3f-d843c1112740
t = 1

# ╔═╡ 0259067a-b538-4dd2-8665-d308273c1a21
md"""
## Truth
"""

# ╔═╡ 3846c63f-32e7-4f96-8e7a-ff62a5b5a21c
md"""
## Predicate
"""

# ╔═╡ 0398e51a-7c72-4fd9-8884-387ee256a9cb
md"""
## Negation
"""

# ╔═╡ 016fa961-5f8a-4993-9fdf-a0c2c8d3c540
md"""
## Conjunction
"""

# ╔═╡ 3e02651f-fffd-47d7-956d-5ba405ecbfaa
md"""
## Disjunction
"""

# ╔═╡ 74fabd52-861f-46dd-a509-cb10914ba332
md"""
## Implication
"""

# ╔═╡ e9cad561-10d3-48dd-ac13-090906b7c1e0
md"""
## Eventually
"""

# ╔═╡ d5fb1b62-574f-4025-9cf8-8e62e357f29f
md"""
## Always
"""

# ╔═╡ 00b37481-0a05-4f5a-a6d0-2fdddaa6ee97
md"""
## Until $\mathcal{U}$
> Note, Julia v1.8 will allow `∃` and `∀` as allowable identifiers.

$$\phi\;\mathcal{U}_{[a,b]}\;\psi$$

 $\phi$ holds until $\psi$ holds, in interval $I=[a,b]$.

$$\exists i: \psi(x_i) \wedge \bigl(\forall j < i: \phi(x_j)\bigr)$$
"""

# ╔═╡ 1d0e135e-6cc3-422e-ba44-fee53cc1965f
μ(x) = x

# ╔═╡ 2305b206-0c6d-440d-81b7-0f485cc8a6a8
# U = @formula 𝒰(_ϕ, _ψ); NOTE: does not work like this.

# ╔═╡ 2d65db96-f8cf-4ccc-b4f5-1c642249ed7b
md"""
### Plotting Until
"""

# ╔═╡ ef4d7b05-d4b3-4498-9e5f-c26d9b47fb60
miss(ϕₓ) = map(v->v ? v : missing, ϕₓ)

# ╔═╡ d1c3412a-373b-47e2-b3d1-383d4ce1fa61
md"""
### More Until Testing
"""

# ╔═╡ 56d37e18-c978-4757-9ed4-e4bd412af310
x2 = [1, 2, 3, 4, -9, -8]

# ╔═╡ b30d0b1e-493b-48c0-b492-5f7dd2ad872b
md"""
# Extra Testing
"""

# ╔═╡ ce82cf55-0e32-412e-b6c6-f95563796e7e
md"""
## Combining STL Formulas
"""

# ╔═╡ ec6ff814-1179-4525-b138-094ca6bec408
md"""
## Satisfying an STL formula
The notation $x_t \in \phi$ denotes that signal $x_t$ satisfies an STL formula $\phi$.
"""

# ╔═╡ 78c782a1-0db2-4c97-a10d-8df036d1c409
x

# ╔═╡ d68f9268-b807-4a76-a1ba-707938b1a589
md"""
## Other Rules

-  $\vee$ disjunction/or
    -  $\phi \vee \psi = \neg(\neg\phi \wedge \neg\psi)$

-  $\implies$ implies
    -  $\phi \implies \psi = \neg\phi \vee \psi$

-  $\lozenge$ eventually
-  $\square$ always
"""

# ╔═╡ 31317201-432b-47fa-818d-6690010788b0
md"""
# Min/Max Approximation Testing
"""

# ╔═╡ ce7dcbba-9546-4b40-8e14-79f80865241b
md"""
## Minish/Maxish Testing
"""

# ╔═╡ ead8d084-7e83-4908-b0cd-7a284aaa8c33
mean(x), minimum(x), maximum(x)

# ╔═╡ aee6eeb8-9f08-402a-8283-bdd19fa88894
w = 0 # 150

# ╔═╡ 86cb96ff-5291-4617-848f-36fc1181d122
md"""
## Smooth Min/Max Testing
"""

# ╔═╡ 222eb11e-1b01-4050-8233-22ef24692c10
maximum(x2), minimum(x2)

# ╔═╡ 1681bbe3-0327-495c-a3e4-0fc34cc9f298
md"""
# Gradient Testing
"""

# ╔═╡ cb623b6e-f91a-4dab-95a7-525ed0cf3476
# diagonal(A) = [A[i,i] for i in 1:minimum(size(A))]

# ╔═╡ b70197e9-7cc1-44d0-82d8-96cfe3a5de76
max.([1,2,3,4], [0,1,2,5])

# ╔═╡ 084904b0-1c60-4358-8369-50d56c456b2a
md"""
## Until gradients
"""

# ╔═╡ 9c354e0c-4e11-4611-81db-b87bd4c5854b
md"""
# Multidimensional signals
Where $x_t \in \mathbb{R}^n$ and $\mu:\mathbb{R}^n \to \mathbb{R}$.

"""

# ╔═╡ 8ac3d316-6048-42c5-8c80-a75baa5b32b2
X = [[1,1], [2,2], [3,3], [4,5]]

# ╔═╡ c0e942a5-1c67-403a-abd2-8d9805a304e2
mu3(𝐱) = 𝐱[1] - 𝐱[2] # norm(x)

# ╔═╡ c8084849-b06c-465a-a69d-1051ab4b085e
mu3.(X)

# ╔═╡ 1c5eaf4b-68aa-4ec1-95d0-268cff0bebf6
md"""
## Automatic transmission example

$$\square_{1,10} v < 120 \wedge \square_{1,5} \omega < 4750$$
"""

# ╔═╡ 88403601-59c3-4e67-9e02-90fdf5800e4a
# transmission = @formula □(x -> x[1] < 120) ∧ □(x -> x[2] < 4750)

# ╔═╡ f4ccd76d-fdf8-436a-83d3-5b062e45152e
begin
	speeds = Real[114, 117, 100, 96, 92, 88, 108, 101, 118, 119]
	rpms = Real[4719, 4747, 4706, 4744, 4701, 4744, 4743, 4753, 4712, 4704]
end

# ╔═╡ 46036c23-797f-4f62-b9fa-64f43950747f
speeds

# ╔═╡ 811f6836-e5c8-447f-aa26-dda644fecc1b
rpms

# ╔═╡ d0b29940-303b-41ac-9313-ee290bde89c5
signals = collect(zip(speeds, rpms))

# ╔═╡ 84496823-db6a-4070-b4e3-c8aff24c54a7
function fill2size(arr, val, n)
	while length(arr) < n
		push!(arr, val)
	end
	return arr
end

# ╔═╡ d143a411-7824-411c-be71-a7fb6b9745a5
# with_terminal() do
# 	T = length(signals)
# 	ab = I -> (first(I), last(I))
# 	trans = deepcopy(transmission)
# 	ϕa, ϕb = ab(trans.ϕ.I)
# 	ψa, ψb = ab(trans.ψ.I)
# 	for t in 1:T
# 		trans.ϕ.I = clamp(max(1,ϕa),1,T):clamp(min(t, ϕb),1,T)
# 		trans.ψ.I = clamp(max(1,ψa),1,T):clamp(min(t, ψb),1,T)
# 		@info ρ(signals[1:t], trans)
# 	end
# end

# ╔═╡ 3903012f-d2d9-4a8a-b246-ec778459a06e
md"""
# Unit Tests
"""

# ╔═╡ 61d62b0c-7ea9-4220-87aa-150d801d2f10
max.([1, 2, 3], [-1, -2, 4]) # broadcasting is important here!

# ╔═╡ 4b8cddcd-b180-4e97-b897-ef47a471d941
neg_ex = Expr(:(->), :xₜ, :(¬(μ(xₜ) > 0.5)))

# ╔═╡ 9ce4cb7e-7ec6-429d-99a8-e5c523c45ba9
non_neg_ex = Expr(:(->), :xₜ, :(μ(xₜ) > 0.5))

# ╔═╡ d0722372-8e7a-409a-abd6-088b9a49ec8b
md"""
# Variable testing
"""

# ╔═╡ fda28f2d-255f-4fd6-b08f-59d61c20eb08
md"""
# Junction testing
"""

# ╔═╡ 41dd7143-8783-45ea-9414-fa80b68b4a6c
md"""
# README Example Tests
Sample tests shown in the README file.
"""

# ╔═╡ cc3e80a3-b3e6-46ab-888c-2b1795d8d3d4
md"""
## Example formula
"""

# ╔═╡ c8441616-025f-4755-9925-2b68ab49f341
md"""
## Example robustness
"""

# ╔═╡ fafeca97-78e5-4a7d-8dd2-ee99b1d41cc3
# ϕ = @formula ◊(xᵢ->xᵢ > 0.5)
# x2 = [1, 2, 3, 4, -9, -8]

# ╔═╡ 319a2bf8-8761-4367-a3f8-c896bd144ee4
md"""
# Notebook
"""

# ╔═╡ bf3977db-5fd3-4440-9c01-39d5268181b9
IS_NOTEBOOK = @isdefined PlutoRunner

# ╔═╡ b04a190f-948f-48d6-a173-f2c8ef5f1280
begin
	if IS_NOTEBOOK
		using Revise
		using PlutoUI
		using Pkg
		Pkg.develop(path="../.")
	end

	using SignalTemporalLogic
	import SignalTemporalLogic: # Pluto triggers
		@formula, ⊤, ⊥, minish, maxish, ⟹, smoothmax, smoothmin
end

# ╔═╡ 09e292b6-d253-471b-9985-97485b8be5b6
⊤(x)

# ╔═╡ bfa42119-da7c-492c-ac80-83d9f765645e
ρ(x[t], ⊤)

# ╔═╡ c321f5cc-d35c-4ef9-9411-6bfec0ed4a70
ϕ_predicate = @formula xₜ -> μ(xₜ) > 0.5;

# ╔═╡ 82a6d9d9-6693-4c7e-88b5-3a9776a51df7
ϕ_predicate(x)

# ╔═╡ ac98fe7e-378c-44a2-940e-1acb805b7ad7
ρ(x, ϕ_predicate)

# ╔═╡ 499161ae-ee5b-43ae-b313-203c70318771
ρ(x, @formula xₜ -> xₜ > 0.5) # without μ

# ╔═╡ 745b4f91-2671-4b11-a8af-84f1d98f3c1f
ρ(x, @formula xₜ -> xₜ < 0.5) # flipped

# ╔═╡ 674ff4b6-e832-4c98-bcc9-bf240a9dd45d
ϕ_negation = @formula xₜ -> ¬(xₜ > 0.5)

# ╔═╡ 6cf6b47a-64da-4967-be77-190e192e3771
ϕ_negation(x)

# ╔═╡ 3a212a95-32f2-49f2-9903-114b8da8e4cf
ρ(x, ϕ_negation)

# ╔═╡ e67582ba-ea43-4a78-b49e-dd1bc40ca5d9
ρ(x, @formula xₜ -> !(xₜ > 0.5))

# ╔═╡ 6062be75-cacb-4d7b-90fa-be76a9a3adf0
ϕ_conjunction = @formula (xₜ -> μ(xₜ) > 0.5) && (xₜ -> μ(xₜ) > 0);

# ╔═╡ bfdbe9f2-6288-4c00-923b-6cdd7b865f16
ϕ_conjunction(x)

# ╔═╡ 13a7ce7f-62c7-419f-a961-84257fd087dd
ρ(x, ϕ_conjunction)

# ╔═╡ 9b04cffe-a87e-4b6f-b2ca-e9f158f3767e
ρ̃(x, ϕ_conjunction)

# ╔═╡ 00847a03-890f-4397-b162-607251ecbe70
∇ρ̃(x, ϕ_conjunction)

# ╔═╡ d30a3fd9-4719-426d-b766-01eda690b76d
ρ(x[t], @formula (xₜ -> μ(xₜ) > 0.5) && (xₜ -> μ(xₜ) > 0))

# ╔═╡ 31851f20-4030-404e-9dc2-46c8cb099ed8
ρ(x[t], @formula (xₜ -> μ(xₜ) > 0.5) ∧ (xₜ -> μ(xₜ) > 0))

# ╔═╡ 758e16d1-c2f9-4051-9af1-7270e5794699
ρ(x[t], @formula (xₜ -> ¬(μ(xₜ) > 0.5)) ∧ (xₜ -> μ(xₜ) > 0))

# ╔═╡ 8e4780db-ec27-4db9-a5ab-3360db1a69e6
ϕ_disjunction = @formula (xₜ -> μ(xₜ) > 0.5) || (xₜ -> μ(xₜ) > 0);

# ╔═╡ dba58b15-fcb5-4627-bcce-9225302e1a6c
ϕ_disjunction(x)

# ╔═╡ 8b9ee613-8036-43b1-bb0f-a4c3df72ca55
ρ(x, ϕ_disjunction)

# ╔═╡ c9d104b4-3c07-4994-b652-3fa2fdc5c8fc
ρ̃(x, ϕ_disjunction)

# ╔═╡ f512b6c6-c726-4a3d-8fbe-1177f9105c99
ρ(x, @formula (xₜ -> μ(xₜ) > 0.5) ∨ (xₜ -> μ(xₜ) > 0))

# ╔═╡ 2543584d-28d3-4e3c-bb35-59ffb693c3fb
ϕ_implies = @formula (xₜ -> μ(xₜ) > 0.5) ⟹ (xₜ -> μ(xₜ) > 0)

# ╔═╡ b998a448-b4f7-4cce-8f8f-80e6f4728f78
ϕ_implies(x)

# ╔═╡ 6933b884-ecc0-40ac-851b-5d30d24be2e2
ρ(x, ϕ_implies)

# ╔═╡ 28168ab3-1401-4867-845f-2d6a5df705ec
ρ̃(x, ϕ_implies)

# ╔═╡ f58a9304-aca8-4524-ae7d-f5bf7d556714
ϕ_eventually = @formula ◊([3,5], xₜ -> μ(xₜ) > 0.5)

# ╔═╡ 08d19d11-678f-40a8-86c4-41f5635cd01d
ρ(x, ϕ_eventually)

# ╔═╡ 4519edec-4540-456a-9717-a0434d9b5343
∇ρ(x, ϕ_eventually)

# ╔═╡ f0347915-6f10-4a28-8797-76e13c61481e
∇ρ̃(x, ϕ_eventually)

# ╔═╡ 735b1f6e-278e-4566-8d1b-5222ff203160
ρ(x, @formula ◊(0.1:4.4, xₜ -> μ(xₜ) > 0.5))

# ╔═╡ 40269dfd-c968-431b-a74b-9956cafe6614
ϕ_always = @formula □(xₜ -> xₜ > 0.5)

# ╔═╡ 6da89434-ff90-4aa7-8c75-f578efc12009
ρ(x, ϕ_always)

# ╔═╡ 53ef7008-3c1e-4fb6-9a8d-91796a9ea55e
ρ̃(x, ϕ_always)

# ╔═╡ 52b8d155-dfcf-4f3a-a8e0-93399ef48b5c
∇ρ(x, ϕ_always)

# ╔═╡ d1051f1d-dc34-4e3d-bc85-71e738f1a835
∇ρ̃(x, ϕ_always)

# ╔═╡ 6dd5301b-a641-4343-91d3-3b442bb7c90f
ρ(x, @formula □(5:6, xₜ -> xₜ > 0.5))

# ╔═╡ 0f661852-d1b4-4e48-946f-33c111230047
_ϕ = @formula xₜ -> μ(xₜ) > 0;

# ╔═╡ b74bd2ee-eb33-4c41-b3b0-e2544166a8ae
_ϕ.μ(x)

# ╔═╡ 64e31569-5749-448b-836d-0714d5fd12bd
_ϕ.(x)

# ╔═╡ 66ac721c-2392-4420-943d-cebdc9710d9a
_ϕ(x[1])

# ╔═╡ 14f52f51-ec7b-4a30-af2d-4dfeed8618c0
_ψ = @formula xₜ -> -μ(xₜ) > 0;

# ╔═╡ 2c8c423e-ed23-4be9-90f6-d96e9ca8c3cb
U = @formula 𝒰(xₜ -> μ(xₜ) > 0, xₜ -> -μ(xₜ) > 0);

# ╔═╡ ba9e4d5a-e791-4f04-9be1-bbdd5de09d6c
U([0.1, 1, 2, 3, -10, -9, -8])

# ╔═╡ d79856be-3c2f-4ff7-a9c6-94a3a4bf8ffe
U(x)

# ╔═╡ 4efe597d-a2b3-4a2e-916a-323e4c86a823
begin
	x1 = [0.001, 1, 2, 3, 4, 5, 6, 7, -8, -9, -10]
	ϕ1 = @formula xᵢ -> xᵢ > 0
	ψ1 = @formula xᵢ -> -xᵢ > 0 # xᵢ < 0
end;

# ╔═╡ b9643ca4-58aa-4902-a103-2c8140eb6e74
x1

# ╔═╡ 562d3796-bf48-4260-9683-0999f628b43c
U(x1)

# ╔═╡ 482600d2-e1a7-446c-934d-3234885ba14c
begin
	time = 1:length(x1)
	steptype = :steppost
	plot(time, miss(ϕ1.(x1)) .+ 1, lw=5, c=:blue, lab=false, lt=steptype)
	plot!(time, miss(ψ1.(x1)), lw=5, c=:red, lab=false, lt=steptype)
	plot!(time, .∨(ϕ1.(x1), ψ1.(x1)) .- 1, lw=5, c=:purple, lab=false, lt=steptype)
	plot!(ytickfont=12, xtickfont=12)

	yticks!(0:2, [L"\phi \mathcal{U} \psi", L"\psi", L"\phi"])
	ylims!(-1.1, 3)

	xlabel!("time")
	xticks!(time)

	title!("Until: $(U(x1))")
end

# ╔═╡ 6af6965b-22a4-44dd-ac6f-2aefca4e3b80
ϕ_until = @formula 𝒰(xₜ -> μ(xₜ) > 0, xₜ -> -μ(xₜ) > 0)

# ╔═╡ 83eda8b3-1cf0-44e1-91af-c2140e8c8f50
ϕ_until(x2)

# ╔═╡ 532cb215-740e-422a-8d36-0ecf8b7a528f
ϕ_until

# ╔═╡ 4a66d029-dfcb-4480-8807-88ce28289722
ρ(x2, ϕ_until)

# ╔═╡ 71cf4068-e617-4604-a2cb-295cbd6d82b8
ρ̃(x2, ϕ_until)

# ╔═╡ fbf26cbf-ec93-478d-8677-f79e1382802e
∇ρ(x2, ϕ_until)

# ╔═╡ d32bf800-51d5-455f-ab50-91bb31f67e83
∇ρ̃(x2, ϕ_until)

# ╔═╡ c738c26d-10a7-488a-976e-cc5f69fc4526
ρ(x, @formula 𝒰(2:4, xₜ -> xₜ > 0, xₜ -> -xₜ > 0))

# ╔═╡ 26a3441c-9128-46c6-8b5a-6858d642509c
begin
	plot(1:length(x2), fill(ρ(x2, ϕ_until), length(x2)), label="ρ(x,ϕ)")
	plot!(1:length(x2), vec(∇ρ(x2, ϕ_until)), label="∇ρ(x,ϕ)")
	plot!(1:length(x2), vec(∇ρ̃(x2, ϕ_until)), label="soft ∇ρ̃(x,ϕ; w=1)")
	plot!(1:length(x2), vec(∇ρ̃(x2, ϕ_until; w=2)), label="soft ∇ρ̃(x,ϕ; w=2)")
end

# ╔═╡ ab72fec1-8266-4064-8a58-6de08b318ada
begin
    x_comb = [4, 3, 2, 1, 0, -1, -2, -3, -4]
    ϕ₁ = @formula xₜ -> xₜ > 0
    ϕ₂ = @formula xₜ -> -xₜ > 0
    ϕc1 = ϕ₁ ∨ ϕ₂

    ϕ₃ = @formula xₜ -> xₜ > 0
    ϕ₄ = @formula xₜ -> xₜ > 1
    ϕc2 = ϕ₃ ∧ ϕ₄
end

# ╔═╡ e0b079d5-8527-4e81-a8c5-f1e354e21717
ϕc1.(x_comb)

# ╔═╡ 4ee8c66a-394c-4ad1-aa69-7121835611bc
ϕc2.(x_comb)

# ╔═╡ ee8e2823-72bc-420d-8069-767a2c31bdec
begin
	@assert (false ⟹ false) == true
    @assert (false ⟹ true) == true
    @assert (true ⟹ false) == false
    @assert (true ⟹ true) == true
end

# ╔═╡ 0051fd25-f970-4706-a1b5-57e9ac04a766
minish(1, 3)

# ╔═╡ 7048bca5-a116-4af0-a601-32d7dd313d1d
minish(x, w=w)

# ╔═╡ 59507e0b-2955-4112-ab19-66ffe45e5a8f
maxish(x, w=w)

# ╔═╡ 034edeaf-8158-4bac-8db2-f41bcab44ba2
smoothmax(x2), smoothmin(x2)

# ╔═╡ 89704458-de6b-493f-bb74-491bea9dc877
smoothmax(xᵢ for xᵢ in [1,2,3,4])

# ╔═╡ c5101fe8-6617-434e-817e-eeac1caa3170
q = @formula ◊(xᵢ->μ(xᵢ) > 0.5)

# ╔═╡ 7ea907bd-d46e-42dc-8bfa-12264f9935b7
∇ρ(x2, q)

# ╔═╡ e0b47a72-6e21-4751-a441-a49b5bad9175
∇ρ̃(x2, q)

# ╔═╡ af384ae1-a6bc-4f5c-a19d-3b90bf50254f
ρ(x2,q)

# ╔═╡ 9f692e34-ecf1-44ae-8f99-68606e8a1b09
ρ̃(x2,q)

# ╔═╡ ea0be409-4fc6-42a8-a1d9-98aa8db843d6
smoothmax.([1,2,3,4], [0,1,2,5])

# ╔═╡ e2a50d76-07df-40b6-9b82-0fddd3785208
∇ρ(x2, ϕ_until)

# ╔═╡ fe39c9df-ecc3-43ac-aa75-0a4ca704afb7
ρ(x2, ϕ_until)

# ╔═╡ 405f53c4-e273-42f8-9465-e70370d9ec5c
∇ρ̃(x2, ϕ_until)

# ╔═╡ cdbad3c0-375c-486f-86e9-991ce660f76e
ρ̃(x,ϕ_until)

# ╔═╡ 4cce6436-76f7-4b19-831f-b0c63757c16e
ϕ_md = @formula ¬(xₜ->mu3(xₜ) > 0) && ¬(xₜ->-mu3(xₜ) > 0)

# ╔═╡ 53775e8e-c933-4fe1-b23e-28218633ad82
ϕ_md.(X)

# ╔═╡ 0c8e5d02-377c-4e47-98b9-dceeef518e77
map(x->ρ(x, ϕ_md), X) # ρ.(X, ϕ) doesn't work

# ╔═╡ 29b0e762-9b4e-4cde-adc3-9ead18115917
map(x->ρ̃(x, ϕ_md), X) # ρ.(X, ϕ) doesn't work

# ╔═╡ 8ebb7717-7563-4202-ae47-2d6c6646a874
transmission = @formula □(1:10, x -> x[1] < 120) ∧ □(1:5, x -> x[2] < 4750)

# ╔═╡ fb56bf20-317b-41bc-b0ad-33fac8d54dc2
@test transmission(signals)

# ╔═╡ 61a54891-d15d-4747-bd29-ee9d3d24fb2e
# Get the robustness at each time step.
function ρ_overtime(x, ϕ)
	return [ρ(fill2size(x[1:t], (-Inf, -Inf), length(x)), ϕ) for t in 1:length(x)]
end

# ╔═╡ 01ea793a-52b4-45a8-b829-4b7acfb5b49d
ρ_overtime(signals, transmission)

# ╔═╡ 67d1440d-42f6-4255-ba27-d041b45fec78
@test ρ(signals, transmission) == 1

# ╔═╡ 324c7c0a-b627-46d3-945d-573c960d57e6
∇ρ(signals, transmission)

# ╔═╡ e0cc216e-8565-4ca5-8ee8-fe9516bc6c1a
∇ρ̃(signals, transmission)

# ╔═╡ 282fa1af-7670-4384-b303-3b5359a31fc0
ρ(x, @formula □(1:3, (xₜ -> xₜ > 0.5) ⟹ ◊(xₜ -> xₜ > 0.5)))

# ╔═╡ 7fe34fde-7a21-44bb-8965-d680cfed8aab
ρ(x, @formula □(1:3, ◊(xₜ -> ¬(xₜ > 0.5)) ⟹ (xₜ -> xₜ > 0.5)))

# ╔═╡ 45e19fc0-5819-4df9-8eea-5460dcc5543b
big_formula = @formula □(1:10, (xᵢ -> xᵢ[1] > 0.5) ⟹ ◊(3:5, xᵢ -> xᵢ[2] > 0.5))

# ╔═╡ 5f18a00a-b7d0-482a-8201-0905b8857d90
get_type = SignalTemporalLogic.parse_formula

# ╔═╡ a5f918e4-81a7-410d-81b0-3a31acdff7ec
@formula(xₜ -> true)

# ╔═╡ f67bfa55-3d82-4783-8f8d-34288b05229c
@test isa(@formula(xₜ -> true), Atomic)

# ╔═╡ fbf51c72-4e21-4918-a928-10defa4832dd
@test isa(@formula(xₜ -> ¬(μ(xₜ) > 0.5)), Negation)

# ╔═╡ 1d6af625-92a5-45bc-ade3-d0a3ace4b9f1
@test isa(@formula(xₜ -> μ(xₜ) > 0.5), Predicate)

# ╔═╡ bc7cca16-207b-4ddc-a204-f1ecacd6985a
@test isa(@formula(xₜ -> ¬(xₜ > 0.5)), Negation)

# ╔═╡ 0bf6dd4c-c750-4e17-9bb3-31436d3dfa67
@test isa(@formula(xₜ -> xₜ > 0.5), Predicate)

# ╔═╡ 3fb98fd1-94f0-4b0f-b721-af0bfc8cacde
@test isa(@formula(xₜ -> xₜ > 0.5), Predicate)

# ╔═╡ ff2b7631-2325-4580-9cf0-1caee91add30
@test isa(@formula((xₜ -> xₜ > 0.5) && (xₜ -> xₜ > 0)), Conjunction)

# ╔═╡ 9874e9ab-4431-45c4-8ece-e2b8f4a4cd43
@test isa(@formula((xₜ -> xₜ > 0.5) || (xₜ -> xₜ > 0)), Disjunction)

# ╔═╡ dd8dc778-e87a-4f62-9041-6be2ba9eb6a9
@test isa(@formula(◊(xₜ -> xₜ > 0.5)), Eventually)

# ╔═╡ b2a24987-1518-4542-9f6c-50e700759e12
@test isa(@formula(□(xₜ -> xₜ > 0.5)), Always)

# ╔═╡ fa5eaecc-e9bd-4d0f-9be5-5515f4e4fd10
@test isa(@formula(𝒰(xₜ -> xₜ > 0.5, xₜ -> xₜ < 0.5)), Until)

# ╔═╡ 71027432-bc47-4de8-bb34-8a3e20e619b0
@test SignalTemporalLogic.strip_negation(neg_ex) == non_neg_ex

# ╔═╡ aea4bd82-6a4f-4347-b8f0-f0e2870c3401
@test (@formula x->¬(x > 0))(x) == (@formula ¬(x->x > 0))(x)

# ╔═╡ 473ef134-f689-4eeb-b4e9-d116cbda4101
@test isa(@formula((xₜ -> xₜ > 0.5) ⟺ (xₜ -> xₜ < 1.0)), Biconditional)

# ╔═╡ a087ed1a-ef52-423e-83c7-9669ff42ccc0
@test begin
	local ϕ = @formula(xₜ -> xₜ == 0.5)
	ϕ(0.5) && !ϕ(1000)
end

# ╔═╡ 5833958c-53cb-4ed5-8416-97168f6425de
function test_local_variable(λ)
	return @eval @formula s->s > $λ # Note to interpolate variable with $
end

# ╔═╡ f725ac4b-d8b7-4955-bea0-f3d3d83265aa
@test test_local_variable(1234).c == 1234

# ╔═╡ 5ccc7a0f-c3b2-4429-9bd5-d7fd9bcb97b5
@test begin
	local upright = @formula s -> abs(s[1]) < π / 4
	local ψ = @eval @formula □($upright) # input anonymous function MUST be a Formula
	ψ([π/10]) && !(ψ([π/3]))
end

# ╔═╡ e2313bcd-dd8f-4ffd-ac1e-7e08304c37b5
@test_throws "Symbol " begin
	local variable
	local ψ = @formula □(variable)
end

# ╔═╡ aea96bbd-d006-4933-a8cb-5165a0158499
@test begin
	local conjunc_test = @formula s->(s[1] < 50) && (s[4] < 1)
	conjunc_test([49, 0, 0, 0.9]) == true && conjunc_test([49, 0, 0, 1.1]) == false
end

# ╔═╡ 781e31e0-1688-48e0-9a22-b5aea40ffb87
@test begin
	local conjunc_test2 = @formula (s->s[1] < 50) && (s->s[4] < 1)
	conjunc_test2([49, 0, 0, 0.9]) == true && conjunc_test2([49, 0, 0, 1.1]) == false
end

# ╔═╡ 6c843d45-4c30-4dcd-a30b-27a12c2e1195
@test begin
	local ϕ = @formula □(s->s[1] < 50 && s[4] < 1)
	ϕ([[49, 0, 0, 0], [49, 0, 0, -1]]) &&
	ϕ([(49, 0, 0, 0), (49, 0, 0, -1)]) &&
	ϕ(([49, 0, 0, 0], [49, 0, 0, -1])) &&
	ϕ(((49, 0, 0, 0), (49, 0, 0, -1)))
end

# ╔═╡ c4f343f7-8c63-4f71-8f46-668675841de7
@test begin
	# Signals (i.e., trace)
	# x = [-0.25, 0, 0.1, 0.6, 0.75, 1.0]
	
	# STL formula: "eventually the signal will be greater than 0.5"
	ϕ = @formula ◊(xₜ -> xₜ > 0.5)
	
	# Check if formula is satisfied
	ϕ(x)
end

# ╔═╡ 0705ce64-9e9d-427e-8cdf-6d958a10c238
∇ρ(x2, q)

# ╔═╡ 38e9a99b-c89c-4973-9538-90d5c4bbb017
∇ρ̃(x2, q)

# ╔═╡ 450f79d5-3393-4aa0-85d6-9bbd8b0b3224
IS_NOTEBOOK && TableOfContents()

# ╔═╡ Cell order:
# ╟─d8a7facd-1ad8-413d-9037-054472fdc50f
# ╠═752d2f6b-a2bb-45bc-9fac-299f88d13f00
# ╠═b04a190f-948f-48d6-a173-f2c8ef5f1280
# ╠═450f79d5-3393-4aa0-85d6-9bbd8b0b3224
# ╠═d383bf0a-3ff1-46d5-b285-63a803463bc0
# ╠═c27ce933-8a2f-4384-bb3f-d843c1112740
# ╟─0259067a-b538-4dd2-8665-d308273c1a21
# ╠═09e292b6-d253-471b-9985-97485b8be5b6
# ╠═bfa42119-da7c-492c-ac80-83d9f765645e
# ╟─3846c63f-32e7-4f96-8e7a-ff62a5b5a21c
# ╠═c321f5cc-d35c-4ef9-9411-6bfec0ed4a70
# ╠═82a6d9d9-6693-4c7e-88b5-3a9776a51df7
# ╠═ac98fe7e-378c-44a2-940e-1acb805b7ad7
# ╠═499161ae-ee5b-43ae-b313-203c70318771
# ╠═745b4f91-2671-4b11-a8af-84f1d98f3c1f
# ╟─0398e51a-7c72-4fd9-8884-387ee256a9cb
# ╠═674ff4b6-e832-4c98-bcc9-bf240a9dd45d
# ╠═b9643ca4-58aa-4902-a103-2c8140eb6e74
# ╠═6cf6b47a-64da-4967-be77-190e192e3771
# ╠═3a212a95-32f2-49f2-9903-114b8da8e4cf
# ╠═e67582ba-ea43-4a78-b49e-dd1bc40ca5d9
# ╟─016fa961-5f8a-4993-9fdf-a0c2c8d3c540
# ╠═6062be75-cacb-4d7b-90fa-be76a9a3adf0
# ╠═bfdbe9f2-6288-4c00-923b-6cdd7b865f16
# ╠═13a7ce7f-62c7-419f-a961-84257fd087dd
# ╠═9b04cffe-a87e-4b6f-b2ca-e9f158f3767e
# ╠═00847a03-890f-4397-b162-607251ecbe70
# ╠═d30a3fd9-4719-426d-b766-01eda690b76d
# ╠═31851f20-4030-404e-9dc2-46c8cb099ed8
# ╠═758e16d1-c2f9-4051-9af1-7270e5794699
# ╟─3e02651f-fffd-47d7-956d-5ba405ecbfaa
# ╠═8e4780db-ec27-4db9-a5ab-3360db1a69e6
# ╠═dba58b15-fcb5-4627-bcce-9225302e1a6c
# ╠═8b9ee613-8036-43b1-bb0f-a4c3df72ca55
# ╠═c9d104b4-3c07-4994-b652-3fa2fdc5c8fc
# ╠═f512b6c6-c726-4a3d-8fbe-1177f9105c99
# ╟─74fabd52-861f-46dd-a509-cb10914ba332
# ╠═2543584d-28d3-4e3c-bb35-59ffb693c3fb
# ╠═b998a448-b4f7-4cce-8f8f-80e6f4728f78
# ╠═6933b884-ecc0-40ac-851b-5d30d24be2e2
# ╠═28168ab3-1401-4867-845f-2d6a5df705ec
# ╟─e9cad561-10d3-48dd-ac13-090906b7c1e0
# ╠═f58a9304-aca8-4524-ae7d-f5bf7d556714
# ╠═08d19d11-678f-40a8-86c4-41f5635cd01d
# ╠═4519edec-4540-456a-9717-a0434d9b5343
# ╠═f0347915-6f10-4a28-8797-76e13c61481e
# ╠═735b1f6e-278e-4566-8d1b-5222ff203160
# ╟─d5fb1b62-574f-4025-9cf8-8e62e357f29f
# ╠═40269dfd-c968-431b-a74b-9956cafe6614
# ╠═6da89434-ff90-4aa7-8c75-f578efc12009
# ╠═53ef7008-3c1e-4fb6-9a8d-91796a9ea55e
# ╠═52b8d155-dfcf-4f3a-a8e0-93399ef48b5c
# ╠═d1051f1d-dc34-4e3d-bc85-71e738f1a835
# ╠═6dd5301b-a641-4343-91d3-3b442bb7c90f
# ╟─00b37481-0a05-4f5a-a6d0-2fdddaa6ee97
# ╠═1d0e135e-6cc3-422e-ba44-fee53cc1965f
# ╠═0f661852-d1b4-4e48-946f-33c111230047
# ╠═14f52f51-ec7b-4a30-af2d-4dfeed8618c0
# ╠═2305b206-0c6d-440d-81b7-0f485cc8a6a8
# ╠═2c8c423e-ed23-4be9-90f6-d96e9ca8c3cb
# ╠═b74bd2ee-eb33-4c41-b3b0-e2544166a8ae
# ╠═ba9e4d5a-e791-4f04-9be1-bbdd5de09d6c
# ╠═d79856be-3c2f-4ff7-a9c6-94a3a4bf8ffe
# ╠═4efe597d-a2b3-4a2e-916a-323e4c86a823
# ╠═562d3796-bf48-4260-9683-0999f628b43c
# ╟─2d65db96-f8cf-4ccc-b4f5-1c642249ed7b
# ╠═39ceaac5-1084-44fa-9388-18593600eb11
# ╠═e74099af-ea14-46d6-a61d-d71d176f5e45
# ╠═ef4d7b05-d4b3-4498-9e5f-c26d9b47fb60
# ╠═482600d2-e1a7-446c-934d-3234885ba14c
# ╟─d1c3412a-373b-47e2-b3d1-383d4ce1fa61
# ╠═6af6965b-22a4-44dd-ac6f-2aefca4e3b80
# ╠═56d37e18-c978-4757-9ed4-e4bd412af310
# ╠═83eda8b3-1cf0-44e1-91af-c2140e8c8f50
# ╠═4a66d029-dfcb-4480-8807-88ce28289722
# ╠═71cf4068-e617-4604-a2cb-295cbd6d82b8
# ╠═fbf26cbf-ec93-478d-8677-f79e1382802e
# ╠═d32bf800-51d5-455f-ab50-91bb31f67e83
# ╠═c738c26d-10a7-488a-976e-cc5f69fc4526
# ╠═26a3441c-9128-46c6-8b5a-6858d642509c
# ╟─b30d0b1e-493b-48c0-b492-5f7dd2ad872b
# ╟─ce82cf55-0e32-412e-b6c6-f95563796e7e
# ╠═ab72fec1-8266-4064-8a58-6de08b318ada
# ╠═e0b079d5-8527-4e81-a8c5-f1e354e21717
# ╠═4ee8c66a-394c-4ad1-aa69-7121835611bc
# ╟─ec6ff814-1179-4525-b138-094ca6bec408
# ╠═78c782a1-0db2-4c97-a10d-8df036d1c409
# ╠═64e31569-5749-448b-836d-0714d5fd12bd
# ╠═66ac721c-2392-4420-943d-cebdc9710d9a
# ╟─d68f9268-b807-4a76-a1ba-707938b1a589
# ╠═ee8e2823-72bc-420d-8069-767a2c31bdec
# ╟─31317201-432b-47fa-818d-6690010788b0
# ╠═ab57fd9b-9bec-48fc-8530-483a5d4ddb11
# ╟─ce7dcbba-9546-4b40-8e14-79f80865241b
# ╠═0051fd25-f970-4706-a1b5-57e9ac04a766
# ╠═ead8d084-7e83-4908-b0cd-7a284aaa8c33
# ╠═aee6eeb8-9f08-402a-8283-bdd19fa88894
# ╠═7048bca5-a116-4af0-a601-32d7dd313d1d
# ╠═59507e0b-2955-4112-ab19-66ffe45e5a8f
# ╟─86cb96ff-5291-4617-848f-36fc1181d122
# ╠═034edeaf-8158-4bac-8db2-f41bcab44ba2
# ╠═222eb11e-1b01-4050-8233-22ef24692c10
# ╠═89704458-de6b-493f-bb74-491bea9dc877
# ╟─1681bbe3-0327-495c-a3e4-0fc34cc9f298
# ╠═c5101fe8-6617-434e-817e-eeac1caa3170
# ╠═7ea907bd-d46e-42dc-8bfa-12264f9935b7
# ╠═e0b47a72-6e21-4751-a441-a49b5bad9175
# ╠═af384ae1-a6bc-4f5c-a19d-3b90bf50254f
# ╠═9f692e34-ecf1-44ae-8f99-68606e8a1b09
# ╠═cb623b6e-f91a-4dab-95a7-525ed0cf3476
# ╠═b70197e9-7cc1-44d0-82d8-96cfe3a5de76
# ╠═ea0be409-4fc6-42a8-a1d9-98aa8db843d6
# ╟─084904b0-1c60-4358-8369-50d56c456b2a
# ╠═532cb215-740e-422a-8d36-0ecf8b7a528f
# ╠═e2a50d76-07df-40b6-9b82-0fddd3785208
# ╠═fe39c9df-ecc3-43ac-aa75-0a4ca704afb7
# ╠═405f53c4-e273-42f8-9465-e70370d9ec5c
# ╠═cdbad3c0-375c-486f-86e9-991ce660f76e
# ╟─9c354e0c-4e11-4611-81db-b87bd4c5854b
# ╠═d06d3ce6-d13b-4ab6-bb66-8a07835e1ce7
# ╠═8ac3d316-6048-42c5-8c80-a75baa5b32b2
# ╠═c0e942a5-1c67-403a-abd2-8d9805a304e2
# ╠═c8084849-b06c-465a-a69d-1051ab4b085e
# ╠═4cce6436-76f7-4b19-831f-b0c63757c16e
# ╠═53775e8e-c933-4fe1-b23e-28218633ad82
# ╠═0c8e5d02-377c-4e47-98b9-dceeef518e77
# ╠═29b0e762-9b4e-4cde-adc3-9ead18115917
# ╟─1c5eaf4b-68aa-4ec1-95d0-268cff0bebf6
# ╠═8ebb7717-7563-4202-ae47-2d6c6646a874
# ╠═88403601-59c3-4e67-9e02-90fdf5800e4a
# ╠═f4ccd76d-fdf8-436a-83d3-5b062e45152e
# ╠═46036c23-797f-4f62-b9fa-64f43950747f
# ╠═811f6836-e5c8-447f-aa26-dda644fecc1b
# ╠═d0b29940-303b-41ac-9313-ee290bde89c5
# ╠═fb56bf20-317b-41bc-b0ad-33fac8d54dc2
# ╠═84496823-db6a-4070-b4e3-c8aff24c54a7
# ╠═61a54891-d15d-4747-bd29-ee9d3d24fb2e
# ╠═01ea793a-52b4-45a8-b829-4b7acfb5b49d
# ╠═67d1440d-42f6-4255-ba27-d041b45fec78
# ╠═324c7c0a-b627-46d3-945d-573c960d57e6
# ╠═e0cc216e-8565-4ca5-8ee8-fe9516bc6c1a
# ╠═d143a411-7824-411c-be71-a7fb6b9745a5
# ╟─3903012f-d2d9-4a8a-b246-ec778459a06e
# ╠═282fa1af-7670-4384-b303-3b5359a31fc0
# ╠═7fe34fde-7a21-44bb-8965-d680cfed8aab
# ╠═61d62b0c-7ea9-4220-87aa-150d801d2f10
# ╠═45e19fc0-5819-4df9-8eea-5460dcc5543b
# ╠═5f18a00a-b7d0-482a-8201-0905b8857d90
# ╠═a5f918e4-81a7-410d-81b0-3a31acdff7ec
# ╠═f67bfa55-3d82-4783-8f8d-34288b05229c
# ╠═fbf51c72-4e21-4918-a928-10defa4832dd
# ╠═1d6af625-92a5-45bc-ade3-d0a3ace4b9f1
# ╠═bc7cca16-207b-4ddc-a204-f1ecacd6985a
# ╠═0bf6dd4c-c750-4e17-9bb3-31436d3dfa67
# ╠═3fb98fd1-94f0-4b0f-b721-af0bfc8cacde
# ╠═ff2b7631-2325-4580-9cf0-1caee91add30
# ╠═9874e9ab-4431-45c4-8ece-e2b8f4a4cd43
# ╠═dd8dc778-e87a-4f62-9041-6be2ba9eb6a9
# ╠═b2a24987-1518-4542-9f6c-50e700759e12
# ╠═fa5eaecc-e9bd-4d0f-9be5-5515f4e4fd10
# ╠═4b8cddcd-b180-4e97-b897-ef47a471d941
# ╠═9ce4cb7e-7ec6-429d-99a8-e5c523c45ba9
# ╠═71027432-bc47-4de8-bb34-8a3e20e619b0
# ╠═aea4bd82-6a4f-4347-b8f0-f0e2870c3401
# ╠═473ef134-f689-4eeb-b4e9-d116cbda4101
# ╠═a087ed1a-ef52-423e-83c7-9669ff42ccc0
# ╟─d0722372-8e7a-409a-abd6-088b9a49ec8b
# ╠═5833958c-53cb-4ed5-8416-97168f6425de
# ╠═f725ac4b-d8b7-4955-bea0-f3d3d83265aa
# ╠═5ccc7a0f-c3b2-4429-9bd5-d7fd9bcb97b5
# ╠═e2313bcd-dd8f-4ffd-ac1e-7e08304c37b5
# ╟─fda28f2d-255f-4fd6-b08f-59d61c20eb08
# ╠═aea96bbd-d006-4933-a8cb-5165a0158499
# ╠═781e31e0-1688-48e0-9a22-b5aea40ffb87
# ╠═6c843d45-4c30-4dcd-a30b-27a12c2e1195
# ╟─41dd7143-8783-45ea-9414-fa80b68b4a6c
# ╟─cc3e80a3-b3e6-46ab-888c-2b1795d8d3d4
# ╠═c4f343f7-8c63-4f71-8f46-668675841de7
# ╟─c8441616-025f-4755-9925-2b68ab49f341
# ╠═fafeca97-78e5-4a7d-8dd2-ee99b1d41cc3
# ╠═0705ce64-9e9d-427e-8cdf-6d958a10c238
# ╠═38e9a99b-c89c-4973-9538-90d5c4bbb017
# ╟─319a2bf8-8761-4367-a3f8-c896bd144ee4
# ╠═bf3977db-5fd3-4440-9c01-39d5268181b9
