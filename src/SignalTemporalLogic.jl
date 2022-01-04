module SignalTemporalLogic

export
    ¬,
    ∧,
    ∨,
    ⟹,
    Formula,
    Interval,
    eventually,
    always,
    Truth,
    ⊤,
    Predicate,
    FlippedPredicate,
    Negation,
    Conjunction,
    Disjunction,
    Implication,
    Eventually,
    Always,
    Until,
    ρ,
    ρ̃,
    robustness,
    smooth_robustness,
    TemporalOperator,
    get_interval,
    minish,
    maxish,
    smoothmin,
    smoothmax,
    ∇ρ,
    ∇ρ̃,
    @formula

include("stl.jl")

end # module
