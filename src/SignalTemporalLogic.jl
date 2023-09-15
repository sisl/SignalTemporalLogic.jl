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
    Atomic,
    ⊤,
    ⊥,
    Predicate,
    FlippedPredicate,
    Negation,
    Conjunction,
    Disjunction,
    Implication,
    Biconditional,
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
