module SignalTemporalLogic

const STL = SignalTemporalLogic

export
    STL,
    ¬,
    ∧,
    ∨,
    ⟹,
    ⟺,
    Formula,
    Interval,
    eventually,
    always,
    Atomic,
    AtomicFunction,
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
    smoothmin,
    smoothmax,
    get_interval,
    ∇ρ,
    ∇ρ̃,
    @formula

include("stl.jl")

end # module
