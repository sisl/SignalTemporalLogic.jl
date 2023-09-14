### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 9adccf3d-1b74-4abb-87c4-cb066c65b3b6
using Zygote

# ╔═╡ 8be19ab0-6d8c-11ec-0e32-fb14ef6c2970
md"""
# Signal Temporal Logic
This notebook defines all of the code for the `SignalTemporalLogic.jl` package.
"""

# ╔═╡ a5d51b71-3685-4e1f-a4be-374623e3702b
md"""
## Propositional Logic
"""

# ╔═╡ ad439cdd-8d94-4c9f-8519-aa4077d11c8e
begin
	¬ = ! # \neg
	∧(a,b) = a && b # \wedge
	∨(a,b) = a || b # \vee
	⟹(p,q) = ¬p ∨ q	# \implies
	⟺(p,q) = (p ⟹ q) ∧ (q ⟹ p)	# \iff
end;

# ╔═╡ 3003c9d3-df19-45ba-a37a-3111f473cb1a
md"""
## Formulas
"""

# ╔═╡ 579f207a-7ad6-45de-b4f0-30062ec1c8af
abstract type Formula end

# ╔═╡ 331fa4f8-b02c-4c30-bcc5-4d09c9234f37
const Interval = Union{UnitRange, Missing}

# ╔═╡ bae83d07-50ec-4f03-bd84-36fc41fa44f0
md"""
## Eventually $\lozenge$
$$\lozenge_{[a,b]}\phi = \top \mathcal{U}_{[a,b]} \phi$$
```julia
◊(x, ϕ, I) = any(ϕ(x[i]) for i in I)
any(ϕ(x.[I]))
```

```julia
function eventually(ϕ, x, I=[1,length(x)])
	T = xₜ->true
	return 𝒰(T, ϕ, x, I)
end
```
"""

# ╔═╡ f0db9fff-59c8-439e-ba03-0a9fb09383a6
md"""
## Always $\square$
$$\square_{[a,b]}\phi = \neg\lozenge_{[a,b]}(\neg\phi)$$

```julia
all(ϕ(x[i]) for i in I)
```

```julia
function always(ϕ, x, I=[1,length(x)])
	return ¬◊(¬ϕ, x, I)
end
```

```julia
□(ϕ, x, I=1:length(x)) = all(ϕ(x[t]) for t in I)
```
"""

# ╔═╡ 8c2a500b-8d62-48a3-ac22-b6466858eef9
md"""
## Combining STL formulas
"""

# ╔═╡ dc6bec3c-4ca0-457e-886d-0b2a3f8845e8
begin
	∧(ϕ1::Formula, ϕ2::Formula) = xᵢ->ϕ1(xᵢ) ∧ ϕ2(xᵢ)
	∨(ϕ1::Formula, ϕ2::Formula) = xᵢ->ϕ1(xᵢ) ∨ ϕ2(xᵢ)
end

# ╔═╡ 50e69922-f07e-48dd-981d-d68c8cd07f7f
md"""
# Robustness
The notion of _robustness_ is defined to be some _quantitative semantics_ (i.e., numerical meaning) that calculates the degree of satisfaction or violation a signal has for a given STL formula. Positive values indicate satisfaction, while negative values indicate violation.

The quantitative semantics of a formula with respect to a signal $x_t$ is defined as:

$$\begin{align}
\rho(x_t, \top) &= \rho_\text{max} \qquad \text{where } \rho_\text{max} > 0\\
\rho(x_t, \mu_c) &=  \mu(x_t) - c\\
\rho(x_t, \neg\phi) &= -\rho(x_t, \phi)\\
\rho(x_t, \phi \wedge \psi) &= \min\Bigl(\rho(x_t, \phi), \rho(x_t, \psi)\Bigr)\\
\rho(x_t, \phi \vee \psi) &= \max\Bigl(\rho(x_t, \phi), \rho(x_t, \psi)\Bigr)\\
\rho(x_t, \phi \implies \psi) &= \max\Bigl(-\rho(x_t, \phi), \rho(x_t, \psi)\Bigr)\\
\rho(x_t, \lozenge_{[a,b]}\phi) &= \max_{t^\prime \in [t+a,t+b]} \rho(x_{t^\prime}, \phi)\\
\rho(x_t, \square_{[a,b]}\phi) &= \min_{t^\prime \in [t+a,t+b]} \rho(x_{t^\prime}, \phi)\\
\rho(x_t, \phi\mathcal{U}_{[a,b]}\psi) &= \max_{t^\prime \in [t+a,t+b]} \biggl(\min\Bigl(\rho(x_{t^\prime},\psi), \min_{t^{\prime\prime}\in[0,t^\prime]} \rho(x_{t^{\prime\prime}}, \phi)\Bigr)\biggr)
\end{align}$$
"""

# ╔═╡ 175946fd-9de7-4efb-811d-1b52d6444614
md"""
## Atomic Operator (Truth/False)
"""

# ╔═╡ a7af8bca-1870-4ce5-8cce-9d9d04604f31
md"""
$$\rho(x_t, \top) = \rho_\text{max} \qquad \text{where } \rho_\text{max} > 0$$
$$\rho(x_t, \bot) = -\rho_\text{max} \qquad \text{where } \rho_\text{max} > 0$$
"""

# ╔═╡ 851997de-b0f5-4273-a15b-0e1440c2e6cd
begin
	Base.@kwdef struct Atomic <: Formula
		value::Bool
		ρ_bound = value ? Inf : -Inf
	end

	(ϕ::Atomic)(x) = ϕ.value
	ρ(xₜ, ϕ::Atomic) = ϕ.ρ_bound
	ρ̃(xₜ, ϕ::Atomic) = ρ(xₜ, ϕ)
end

# ╔═╡ 296c7321-db0d-4878-a4d9-6e2b6ee76e4e
md"""
## Predicate
"""

# ╔═╡ 0158daf7-bc8d-4764-81b1-b5e73e02dc8a
md"""
$$\rho(x_t, \mu_c) =  \mu(x_t) - c \qquad (\text{when}\; \mu(x_t) > c)$$
"""

# ╔═╡ 1ec0bddb-28d8-420b-856d-2c1ed70a77a4
begin
	mutable struct Predicate <: Formula
		μ::Function # ℝⁿ → ℝ
		c::Union{Real, Vector}
	end

	(ϕ::Predicate)(x) = map(xₜ->all(xₜ .> ϕ.c), ϕ.μ(x))
	ρ(x, ϕ::Predicate) = map(xₜ->xₜ - ϕ.c, ϕ.μ(x))
	ρ̃(x, ϕ::Predicate) = ρ(x, ϕ)
end

# ╔═╡ 5d2e634f-c483-4707-a53d-aa71e17dd3f5
md"""
$$\rho(x_t, \mu_c) =  c - \mu(x_t) \qquad (\text{when}\; \mu(x_t) < c)$$
"""

# ╔═╡ 3ed8b19e-6518-40b6-9320-3ab01d03f8f6
begin
	mutable struct FlippedPredicate <: Formula
		μ::Function # ℝⁿ → ℝ
		c::Union{Real, Vector}
	end

	(ϕ::FlippedPredicate)(x) = map(xₜ->all(xₜ .< ϕ.c), ϕ.μ(x))
	ρ(x, ϕ::FlippedPredicate) = map(xₜ->ϕ.c - xₜ, ϕ.μ(x))
	ρ̃(x, ϕ::FlippedPredicate) = ρ(x, ϕ)
end

# ╔═╡ 00189191-c0ec-41c2-85f0-f362c4b8bb69
md"""
## Negation
"""

# ╔═╡ 944e81cc-ef05-4541-bf04-441d2a59af0c
md"""
$$\rho(x_t, \neg\phi) = -\rho(x_t, \phi)$$
"""

# ╔═╡ 9e477ba3-9e0e-42ae-9fe2-97adc7ae8faa
begin
	mutable struct Negation <: Formula
		ϕ_inner::Formula
	end

	(ϕ::Negation)(x) = .¬ϕ.ϕ_inner(x)
	ρ(xₜ, ϕ::Negation) = -ρ(xₜ, ϕ.ϕ_inner)
	ρ̃(xₜ, ϕ::Negation) = -ρ̃(xₜ, ϕ.ϕ_inner)
end

# ╔═╡ 94cb97f7-ddc0-4ab3-bf90-9e38d2a19de0
md"""
## Conjunction
"""

# ╔═╡ b04f0e12-06a0-4955-add4-ae3dcbb5c25a
md"""
$$\rho(x_t, \phi \wedge \psi) = \min\Bigl(\rho(x_t, \phi), \rho(x_t, \psi)\Bigr)$$
"""

# ╔═╡ e75cafd9-1d30-496e-82d5-f7b353036d81
md"""
## Disjunction
"""

# ╔═╡ 8330f2e8-c6a5-45ac-a812-ffc358f06ea6
md"""
$$\rho(x_t, \phi \vee \psi) = \max\Bigl(\rho(x_t, \phi), \rho(x_t, \psi)\Bigr)$$
"""

# ╔═╡ f45fbd6d-f02b-44ca-a846-f8f8792e7c32
md"""
## Implication
"""

# ╔═╡ 413d8927-cae0-4425-ab2b-f22cac074ac6
md"""
$$\rho(x_t, \phi \implies \psi) = \max\Bigl(-\rho(x_t, \phi), \rho(x_t, \psi)\Bigr)$$
"""

# ╔═╡ 4ec409ed-24cd-4b23-93aa-34da33644289
md"""
## Biconditional
"""

# ╔═╡ a0653887-537c-4792-acfc-4849b79d6970
md"""
$$\rho(x_t, \phi \iff \psi) = \rho\bigl(x_t, (\phi \implies \psi) \wedge (\psi \implies \phi)\bigr)$$
"""

# ╔═╡ acbe9641-ac0b-43c6-9cb2-2aea65efb431
md"""
## Eventually
"""

# ╔═╡ 3829b9dc-bbba-48aa-9e95-996589886bfa
md"""
$$\rho(x_t, \lozenge_{[a,b]}\phi) = \max_{t^\prime \in [t+a,t+b]} \rho(x_{t^\prime}, \phi)$$
"""

# ╔═╡ baed163f-b9f6-4c34-9432-529c683ae43e
get_interval(ϕ::Formula, x) = ismissing(ϕ.I) ? (1:length(x)) : ϕ.I

# ╔═╡ 15870045-7238-4e75-9aea-3d6824e21bbe
md"""
## Always
"""

# ╔═╡ 069b6736-bc83-4a9b-8319-bcb6dedadcc6
md"""
$$\rho(x_t, \square_{[a,b]}\phi) = \min_{t^\prime \in [t+a,t+b]} \rho(x_{t^\prime}, \phi)$$
"""

# ╔═╡ fef07e51-227b-4558-b8bd-aa33d7a6c8ce
md"""
## Until
"""

# ╔═╡ 31589b2c-e0ad-478a-9a51-c18d83b67d07
md"""
$$\rho(x_t, \phi\mathcal{U}_{[a,b]}\psi) = \max_{t^\prime \in [t+a,t+b]} \biggl(\min\Bigl(\rho(x_{t^\prime},\psi), \min_{t^{\prime\prime}\in[0,t^\prime]} \rho(x_{t^{\prime\prime}}, \phi)\Bigr)\biggr)$$
"""

# ╔═╡ d72cffdc-60d9-4b0a-a787-89e2ba3ca858
md"""
# Minimum/maximum approximations
"""

# ╔═╡ 4c07b312-8fa3-48bb-95e7-5005674265aa
md"""
## Smooth minimum
$$\widetilde{\min}(x; w) = \frac{\sum_i^n x_i \exp(-wx_i)}{\sum_j^n \exp(-wx_j)}$$

This approximates the $\min$ function and will return the true solution when $w \to \infty$ and will return the mean of $x$ when $w=0$.
"""

# ╔═╡ ba0a977e-3dea-4b87-900d-d7e2e4281f79
W_DEFAULT = 1

# ╔═╡ 8c9c3777-30f9-4de2-b80d-cc05aaf21ea5
minish(x; w=W_DEFAULT) = sum(xᵢ*exp(-w*xᵢ) for xᵢ in x) / sum(exp(-w*xⱼ) for xⱼ in x)

# ╔═╡ f7c4d4a1-c3f4-4196-8a92-50294480555c
minish(x1, x2; w=W_DEFAULT) = minish([x1,x2]; w=w)

# ╔═╡ 967af87a-d0d7-42ea-871d-492d9406f9c6
begin
	mutable struct Always <: Formula
		ϕ::Formula
		I::Interval
	end

	(□::Always)(x) = all(□.ϕ(x[t]) for t ∈ get_interval(□, x))

	ρ(x, □::Always) = minimum(ρ(x[t′], □.ϕ) for t′ ∈ get_interval(□, x))
	ρ̃(x, □::Always) = minish(ρ̃(x[t′], □.ϕ) for t′ ∈ get_interval(□, x))
end

# ╔═╡ 980379f9-3544-4363-aa6c-595d0c509124
md"""
## Smooth maximum
$$\widetilde{\max}(x; w) = \frac{\sum_i^n x_i \exp(wx_i)}{\sum_j^n \exp(wx_j)}$$
"""

# ╔═╡ 0bbd170b-ef3d-4a4a-99f7-df6cfd16dcc6
maxish(x; w=W_DEFAULT) = sum(xᵢ*exp(w*xᵢ) for xᵢ in x) / sum(exp(w*xⱼ) for xⱼ in x)

# ╔═╡ e5e59d1d-f6ec-4bde-90fe-4715b15239a2
maxish(x1, x2; w=W_DEFAULT) = maxish([x1,x2]; w=w)

# ╔═╡ e4df40fb-dc10-421c-9cab-39ebfc73b320
begin
	mutable struct Disjunction <: Formula
		ϕ::Formula
		ψ::Formula
	end
	
	(q::Disjunction)(x) = any(q.ϕ(x) .∨ q.ψ(x))

	ρ(xₜ, q::Disjunction) = max.(ρ(xₜ, q.ϕ), ρ(xₜ, q.ψ))
	ρ̃(xₜ, q::Disjunction) = maxish.(ρ̃(xₜ, q.ϕ), ρ̃(xₜ, q.ψ))
end

# ╔═╡ b0b10df8-07f0-4317-8f3a-3620a3cb8e8e
begin
	mutable struct Implication <: Formula
		ϕ::Formula
		ψ::Formula
	end
	
	(q::Implication)(x) = q.ϕ(x) .⟹ q.ψ(x)

	ρ(xₜ, q::Implication) = max.(-ρ(xₜ, q.ϕ), ρ(xₜ, q.ψ))
	ρ̃(xₜ, q::Implication) = maxish.(-ρ̃(xₜ, q.ϕ), ρ̃(xₜ, q.ψ))
end

# ╔═╡ d2e95e25-f1df-4807-bc41-fb7ebb7a3d55
begin
	mutable struct Eventually <: Formula
		ϕ::Formula
		I::Interval
	end

	(◊::Eventually)(x) = any(◊.ϕ(x[t]) for t ∈ get_interval(◊, x))

	ρ(x, ◊::Eventually) = maximum(ρ(x[t′], ◊.ϕ) for t′ ∈ get_interval(◊, x))
	ρ̃(x, ◊::Eventually) = maxish(ρ̃(x[t′], ◊.ϕ) for t′ ∈ get_interval(◊, x))
end

# ╔═╡ b12507a8-1a50-4e88-9271-1fa5413c93a8
begin
	mutable struct Until <: Formula
		ϕ::Formula
		ψ::Formula
		I::Interval
	end

	function (𝒰::Until)(x)
		ϕ, ψ, I = 𝒰.ϕ, 𝒰.ψ, get_interval(𝒰, x)
		return any(ψ(x[i]) && all(ϕ(x[j]) for j ∈ I[1]:i-1) for i ∈ I)
	end

	function ρ(x, 𝒰::Until)
		ϕ, ψ, I = 𝒰.ϕ, 𝒰.ψ, get_interval(𝒰, x)
		return maximum(map(I) do t′
			ρ1 = ρ(x[t′], ψ)
			ρ2_trace = [ρ(x[t′′], ϕ) for t′′ ∈ 1:t′-1]
			ρ2 = isempty(ρ2_trace) ? 10e100 : minimum(ρ2_trace)
			min(ρ1, ρ2)
		end)
	end
	
	function ρ̃(x, 𝒰::Until; kwargs...)
		ϕ, ψ, I = 𝒰.ϕ, 𝒰.ψ, get_interval(𝒰, x)
		return maxish(map(I) do t′
			ρ̃1 = ρ̃(x[t′], ψ)
			ρ̃2_trace = [ρ̃(x[t′′], ϕ) for t′′ ∈ 1:t′-1]
			ρ̃2 = isempty(ρ̃2_trace) ? 10e100 : minish(ρ̃2_trace; kwargs...)
			minish([ρ̃1, ρ̃2]; kwargs...)
		end; kwargs...)
	end
end

# ╔═╡ ef7fc726-3a27-463b-8c40-4eb549d983be
const TemporalOperator = Union{Eventually, Always, Until}

# ╔═╡ c2ed7097-0728-468f-a4e7-83fabc7f4ce3
md"""
## Log-sum-exp version
"""

# ╔═╡ 1bb4465b-52a8-48d9-aed5-3805fa7d5745
function logsumexp(x)
	@show x
	m = maximum(x)
	return m + log.(sum(exp.(x .- m)))
end

# ╔═╡ b613b840-bb6f-41a9-ac8e-749e742ab1af
smoothmax(x) = logsumexp(x)

# ╔═╡ 8dbcaccb-aa34-4c80-946d-1ad82d323ee8
smoothmax(x1,x2) = smoothmax([x1,x2])

# ╔═╡ 96679522-ed33-4850-8519-39c7b6353087
smoothmin(x) = -logsumexp(.-x)

# ╔═╡ 9543b7f3-9680-492e-a2ae-7502c6f5f2ef
smoothmin(x1,x2) = smoothmin([x1,x2])

# ╔═╡ c93b2ad2-1b5c-490e-b7fc-9fc0495fe6fa
begin
	mutable struct Conjunction <: Formula
		ϕ::Formula
		ψ::Formula
	end
	
	(q::Conjunction)(x) = all(q.ϕ(x) .∧ q.ψ(x))

	ρ(xₜ, q::Conjunction) = min.(ρ(xₜ, q.ϕ), ρ(xₜ, q.ψ))
	ρ̃(xₜ, q::Conjunction) = smoothmin.(ρ̃(xₜ, q.ϕ), ρ̃(xₜ, q.ψ))
end

# ╔═╡ f1f170a8-2902-41f7-8c21-99c90d752459
begin
	mutable struct Biconditional <: Formula
		ϕ::Formula
		ψ::Formula
	end
	
	(q::Biconditional)(x) = q.ϕ(x) .⟺ q.ψ(x)

	ρ(xₜ, q::Biconditional) =
		ρ(xₜ, Conjunction(Implication(q.ϕ, q.ψ), Implication(q.ψ, q.ϕ)))
	ρ̃(xₜ, q::Biconditional) =
		ρ̃(xₜ, Conjunction(Implication(q.ϕ, q.ψ), Implication(q.ψ, q.ϕ)))
end

# ╔═╡ 7502b631-a7a1-4d2d-a881-7f1c8f685d66
robustness = ρ

# ╔═╡ 5c1e16b3-1b3c-4c7a-a484-44b935eaa2a9
smooth_robustness = ρ̃

# ╔═╡ 182aa82d-302a-4719-9ec2-b8df937acb7b
md"""
# Gradients
"""

# ╔═╡ 80787178-e17d-4066-8544-609a4ed76613
∇ρ(x, ϕ; kwargs...) = first(jacobian(x->ρ(x, ϕ; kwargs...), x))

# ╔═╡ f5b37004-f30b-4a59-8aab-ecc775e856b3
∇ρ̃(x, ϕ; kwargs...) = first(jacobian(x->ρ̃(x, ϕ; kwargs...), x))

# ╔═╡ 067dadb1-1312-4035-930c-65b1068f7013
md"""
# Robustness helpers
"""

# ╔═╡ 4bba7170-e7b7-4ccf-b6f4-a32b7ee4b809
function split_lambda(λ)
	var, body = λ.args
	if body.head == :block
		body = body.args[1]
	end
	return var, body
end

# ╔═╡ 15dc4645-b08e-4a5a-a65d-1858b948f324
function split_predicate(ϕ)
	var, body = split_lambda(ϕ)
	μ_body, c = body.args[2:3]
	μ = Expr(:(->), var, μ_body)
	return μ, c
end

# ╔═╡ b90947cb-2cbe-4410-abbe-4869b5caa313
function strip_negation(ϕ)
	if ϕ.head == :call
		# negation outside lambda definition ¬(x->x)
		return ϕ.args[2]
	else
		var, body = split_lambda(ϕ)
		formula = body.args[end]
		if formula.args[1] ∈ [:(¬), :(!)]
			inner = formula.args[end]
		else
			inner = formula
		end
		return Expr(:(->), var, inner)
	end
end

# ╔═╡ 982ac681-79a0-4c69-a5cc-0546a5ebd3be
function split_junction(ϕ_ψ)
	ϕ, ψ = ϕ_ψ.args[end-1:end]
	return ϕ, ψ
end

# ╔═╡ 84effb59-b744-4bd7-b724-6f3e4056a737
function split_interval(interval_ex)
	interval = eval(interval_ex)
	a, b = first(interval), last(interval)
	a, b = ceil(Int, a), floor(Int, b)
	I = a:b
	return I
end

# ╔═╡ 78f8ce9c-9563-4ea1-89fc-c5c65ce4bb29
function split_temporal(temporal_ϕ)
	if length(temporal_ϕ.args) == 3
		interval_ex = temporal_ϕ.args[2]
		I = split_interval(interval_ex)
		ϕ_ex = temporal_ϕ.args[3]
	else
		I = missing
		ϕ_ex = temporal_ϕ.args[2]
	end
	return (ϕ_ex, I)
end

# ╔═╡ 460bba5d-ebac-46b1-80fc-72fe845046a7
function split_until(until)
	if length(until.args) == 4
		interval_ex = until.args[2]
		I = split_interval(interval_ex)
		ϕ_ex, ψ_ex = until.args[3:4]
	else
		I = missing
		ϕ_ex, ψ_ex = until.args[2:3]
	end
	return (ϕ_ex, ψ_ex, I)
end

# ╔═╡ e44e21ed-36f6-4d2c-82bd-fa1575cc49f8
function parse_formula(ex)
    if ex.head ∈ (:(&&), :(||))
        ϕ_ex, ψ_ex = split_junction(ex)
        ϕ = parse_formula(ϕ_ex)
        ψ = parse_formula(ψ_ex)
        if ex.head == :(&&)
            return :(Conjunction($ϕ, $ψ))
        elseif ex.head == :(||)
            return :(Disjunction($ϕ, $ψ))
        end
    else
        var, body = ex.args
        body = Base.remove_linenums!(body)
        if var ∈ [:◊, :□]
            ϕ_ex, I = split_temporal(ex)
            ϕ = parse_formula(ϕ_ex)
            if var == :◊
                return :(Eventually($ϕ, $I))
            elseif var == :□
                return :(Always($ϕ, $I))
            end
        elseif var == :𝒰
            ϕ_ex, ψ_ex, I = split_until(ex)
            ϕ = parse_formula(ϕ_ex)
            ψ = parse_formula(ψ_ex)
            return :(Until($ϕ, $ψ, $I))
        else
            core = body.head == :block ? body.args[end] : body
			if typeof(core) == Bool
				return :(Atomic(value=$(esc(core))))
			else
                if var ∈ (:⟺, :(==), :⟹, :∧, :∨)
                    ϕ_ex, ψ_ex = split_junction(ex)
                    ϕ = parse_formula(ϕ_ex)
                    ψ = parse_formula(ψ_ex)
					if var ∈ [:⟺, :(==)]
						return :(Biconditional($ϕ, $ψ))
					elseif var == :⟹
                        return :(Implication($ϕ, $ψ))
                    elseif var == :∧
                        return :(Conjunction($ϕ, $ψ))
                    elseif var == :∨
                        return :(Disjunction($ϕ, $ψ))
                    end
                elseif var ∈ [:¬, :!]
                    ϕ_inner = parse_formula(strip_negation(ex))
                    return :(Negation($ϕ_inner))
                else
                    formula_type = core.args[1]
                    if formula_type ∈ [:¬, :!]
                        ϕ_inner = parse_formula(strip_negation(ex))
                        return :(Negation($ϕ_inner))
                    elseif formula_type == :>
                        μ, c = split_predicate(ex)
                        return :(Predicate($(esc(μ)), $c))
                    elseif formula_type == :<
                        μ, c = split_predicate(ex)
                        return :(FlippedPredicate($(esc(μ)), $c))
					elseif formula_type ∈ [:⟺, :(==)]
                        μ, c = split_predicate(ex)
						return :(Conjunction(Negation(Predicate($(esc(μ)), $c)), Negation(FlippedPredicate($(esc(μ)), $c))))
                    else
                        error("No type for formula: $(formula_type) and var $(var)")
                    end
                end
            end
        end
    end
end

# ╔═╡ 97adec7a-75fd-40b1-9e46-e302c1dd6b9e
macro formula(ex)
	return parse_formula(ex)
end

# ╔═╡ 7b96179d-1a55-42b4-a934-74b57a1d0cc6
eventually = @formula 𝒰(xₜ->true, xₜ -> xₜ > 0) # alternate derived form

# ╔═╡ 5c454ece-de05-4cce-9996-037df54024e5
always = @formula ¬◊(¬(xₜ -> xₜ > 0))

# ╔═╡ 916d7fae-6599-41c6-b909-4e1dd66e48f1
⊤ = @formula xₜ -> true

# ╔═╡ c1e17481-91c3-430f-99f3-1b328ec31417
⊥ = @formula xₜ -> false

# ╔═╡ e16f2079-f028-46c6-b4e7-bf23fe9dcbfb
md"""
# Notebook
"""

# ╔═╡ c66d8ffa-44d0-4550-9456-870aae5db796
IS_NOTEBOOK = @isdefined PlutoRunner

# ╔═╡ eeabb14a-7ca8-4446-b3d6-39a41b5b452c
if IS_NOTEBOOK
	using PlutoUI
end

# ╔═╡ 210d23f1-2374-4511-a012-852f1f2dc3be
IS_NOTEBOOK && TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[compat]
PlutoUI = "~0.7.52"
Zygote = "~0.6.64"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "4b9ee7224cae064f92ebbf11c75bafe1a0f702a5"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.ChainRules]]
deps = ["Adapt", "ChainRulesCore", "Compat", "Distributed", "GPUArraysCore", "IrrationalConstants", "LinearAlgebra", "Random", "RealDot", "SparseArrays", "SparseInverseSubset", "Statistics", "StructArrays", "SuiteSparse"]
git-tree-sha1 = "dbeca245b0680f5393b4e6c40dcead7230ab0b3b"
uuid = "082447d4-558c-5d27-93f4-14fc19e9eca2"
version = "1.54.0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e30f2f4e20f7f186dc36529910beaedc60cfa644"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.16.0"

[[deps.ChangesOfVariables]]
deps = ["InverseFunctions", "LinearAlgebra", "Test"]
git-tree-sha1 = "2fba81a302a7be671aefe194f0525ef231104e7f"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.8"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "e460f044ca8b99be31d35fe54fc33a5c33dd8ed7"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.9.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "a20eaa3ad64254c61eeb5f230d9306e937405434"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.6.1"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"

[[deps.GPUArrays]]
deps = ["Adapt", "GPUArraysCore", "LLVM", "LinearAlgebra", "Printf", "Random", "Reexport", "Serialization", "Statistics"]
git-tree-sha1 = "8ad8f375ae365aa1eb2f42e2565a40b55a4b69a8"
uuid = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
version = "9.0.0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.IRTools]]
deps = ["InteractiveUtils", "MacroTools", "Test"]
git-tree-sha1 = "eac00994ce3229a464c2847e956d77a2c64ad3a5"
uuid = "7869d1d1-7146-5819-86e3-90919afe41df"
version = "0.4.10"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "68772f49f54b479fa88ace904f6127f0a3bb2e46"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.12"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Printf", "Unicode"]
git-tree-sha1 = "a9d2ce1d5007b1e8f6c5b89c5a31ff8bd146db5c"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "6.2.1"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "7ca6850ae880cc99b59b88517545f91a52020afa"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.25+0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SparseInverseSubset]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "91402087fd5d13b2d97e3ef29bbdf9d7859e678a"
uuid = "dc90abb0-5640-4711-901d-7e5b23a2fada"
version = "0.1.1"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "51621cca8651d9e334a659443a74ce50a3b6dfab"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.3"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StructArrays]]
deps = ["Adapt", "ConstructionBase", "DataAPI", "GPUArraysCore", "StaticArraysCore", "Tables"]
git-tree-sha1 = "0a3db38e4cce3c54fe7a71f831cd7b6194a54213"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.16"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zygote]]
deps = ["AbstractFFTs", "ChainRules", "ChainRulesCore", "DiffRules", "Distributed", "FillArrays", "ForwardDiff", "GPUArrays", "GPUArraysCore", "IRTools", "InteractiveUtils", "LinearAlgebra", "LogExpFunctions", "MacroTools", "NaNMath", "PrecompileTools", "Random", "Requires", "SparseArrays", "SpecialFunctions", "Statistics", "ZygoteRules"]
git-tree-sha1 = "b97c927497c1de55a78dc9030f6068be5d83ef80"
uuid = "e88e6eb3-aa80-5325-afca-941959d7151f"
version = "0.6.64"

[[deps.ZygoteRules]]
deps = ["ChainRulesCore", "MacroTools"]
git-tree-sha1 = "977aed5d006b840e2e40c0b48984f7463109046d"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─8be19ab0-6d8c-11ec-0e32-fb14ef6c2970
# ╠═210d23f1-2374-4511-a012-852f1f2dc3be
# ╟─a5d51b71-3685-4e1f-a4be-374623e3702b
# ╠═ad439cdd-8d94-4c9f-8519-aa4077d11c8e
# ╟─3003c9d3-df19-45ba-a37a-3111f473cb1a
# ╠═579f207a-7ad6-45de-b4f0-30062ec1c8af
# ╠═331fa4f8-b02c-4c30-bcc5-4d09c9234f37
# ╟─bae83d07-50ec-4f03-bd84-36fc41fa44f0
# ╠═7b96179d-1a55-42b4-a934-74b57a1d0cc6
# ╟─f0db9fff-59c8-439e-ba03-0a9fb09383a6
# ╠═5c454ece-de05-4cce-9996-037df54024e5
# ╟─8c2a500b-8d62-48a3-ac22-b6466858eef9
# ╠═dc6bec3c-4ca0-457e-886d-0b2a3f8845e8
# ╟─50e69922-f07e-48dd-981d-d68c8cd07f7f
# ╠═7502b631-a7a1-4d2d-a881-7f1c8f685d66
# ╠═5c1e16b3-1b3c-4c7a-a484-44b935eaa2a9
# ╟─175946fd-9de7-4efb-811d-1b52d6444614
# ╟─a7af8bca-1870-4ce5-8cce-9d9d04604f31
# ╠═851997de-b0f5-4273-a15b-0e1440c2e6cd
# ╠═916d7fae-6599-41c6-b909-4e1dd66e48f1
# ╠═c1e17481-91c3-430f-99f3-1b328ec31417
# ╟─296c7321-db0d-4878-a4d9-6e2b6ee76e4e
# ╟─0158daf7-bc8d-4764-81b1-b5e73e02dc8a
# ╠═1ec0bddb-28d8-420b-856d-2c1ed70a77a4
# ╟─5d2e634f-c483-4707-a53d-aa71e17dd3f5
# ╠═3ed8b19e-6518-40b6-9320-3ab01d03f8f6
# ╟─00189191-c0ec-41c2-85f0-f362c4b8bb69
# ╟─944e81cc-ef05-4541-bf04-441d2a59af0c
# ╠═9e477ba3-9e0e-42ae-9fe2-97adc7ae8faa
# ╟─94cb97f7-ddc0-4ab3-bf90-9e38d2a19de0
# ╟─b04f0e12-06a0-4955-add4-ae3dcbb5c25a
# ╠═c93b2ad2-1b5c-490e-b7fc-9fc0495fe6fa
# ╟─e75cafd9-1d30-496e-82d5-f7b353036d81
# ╟─8330f2e8-c6a5-45ac-a812-ffc358f06ea6
# ╠═e4df40fb-dc10-421c-9cab-39ebfc73b320
# ╟─f45fbd6d-f02b-44ca-a846-f8f8792e7c32
# ╟─413d8927-cae0-4425-ab2b-f22cac074ac6
# ╠═b0b10df8-07f0-4317-8f3a-3620a3cb8e8e
# ╟─4ec409ed-24cd-4b23-93aa-34da33644289
# ╟─a0653887-537c-4792-acfc-4849b79d6970
# ╠═f1f170a8-2902-41f7-8c21-99c90d752459
# ╟─acbe9641-ac0b-43c6-9cb2-2aea65efb431
# ╟─3829b9dc-bbba-48aa-9e95-996589886bfa
# ╠═ef7fc726-3a27-463b-8c40-4eb549d983be
# ╠═baed163f-b9f6-4c34-9432-529c683ae43e
# ╠═d2e95e25-f1df-4807-bc41-fb7ebb7a3d55
# ╟─15870045-7238-4e75-9aea-3d6824e21bbe
# ╟─069b6736-bc83-4a9b-8319-bcb6dedadcc6
# ╠═967af87a-d0d7-42ea-871d-492d9406f9c6
# ╟─fef07e51-227b-4558-b8bd-aa33d7a6c8ce
# ╟─31589b2c-e0ad-478a-9a51-c18d83b67d07
# ╠═b12507a8-1a50-4e88-9271-1fa5413c93a8
# ╟─d72cffdc-60d9-4b0a-a787-89e2ba3ca858
# ╟─4c07b312-8fa3-48bb-95e7-5005674265aa
# ╠═ba0a977e-3dea-4b87-900d-d7e2e4281f79
# ╠═8c9c3777-30f9-4de2-b80d-cc05aaf21ea5
# ╠═f7c4d4a1-c3f4-4196-8a92-50294480555c
# ╟─980379f9-3544-4363-aa6c-595d0c509124
# ╠═0bbd170b-ef3d-4a4a-99f7-df6cfd16dcc6
# ╠═e5e59d1d-f6ec-4bde-90fe-4715b15239a2
# ╟─c2ed7097-0728-468f-a4e7-83fabc7f4ce3
# ╠═1bb4465b-52a8-48d9-aed5-3805fa7d5745
# ╠═b613b840-bb6f-41a9-ac8e-749e742ab1af
# ╠═8dbcaccb-aa34-4c80-946d-1ad82d323ee8
# ╠═96679522-ed33-4850-8519-39c7b6353087
# ╠═9543b7f3-9680-492e-a2ae-7502c6f5f2ef
# ╟─182aa82d-302a-4719-9ec2-b8df937acb7b
# ╠═9adccf3d-1b74-4abb-87c4-cb066c65b3b6
# ╠═80787178-e17d-4066-8544-609a4ed76613
# ╠═f5b37004-f30b-4a59-8aab-ecc775e856b3
# ╟─067dadb1-1312-4035-930c-65b1068f7013
# ╠═97adec7a-75fd-40b1-9e46-e302c1dd6b9e
# ╠═e44e21ed-36f6-4d2c-82bd-fa1575cc49f8
# ╠═4bba7170-e7b7-4ccf-b6f4-a32b7ee4b809
# ╠═15dc4645-b08e-4a5a-a65d-1858b948f324
# ╠═b90947cb-2cbe-4410-abbe-4869b5caa313
# ╠═982ac681-79a0-4c69-a5cc-0546a5ebd3be
# ╠═84effb59-b744-4bd7-b724-6f3e4056a737
# ╠═78f8ce9c-9563-4ea1-89fc-c5c65ce4bb29
# ╠═460bba5d-ebac-46b1-80fc-72fe845046a7
# ╟─e16f2079-f028-46c6-b4e7-bf23fe9dcbfb
# ╠═c66d8ffa-44d0-4550-9456-870aae5db796
# ╠═eeabb14a-7ca8-4446-b3d6-39a41b5b452c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
