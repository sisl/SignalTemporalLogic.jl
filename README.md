# SignalTemporalLogic.jl
This package can define _signal temporal logic_ (STL) formulas using the `@formula` macro and then check if the formulas satisfy a signal trace. It can also measure the _robustness_ of a trace through an STL formula and compute the gradient of the robustness (as well as an approximate gradient using smooth min and max functions).

[![Pluto source](https://img.shields.io/badge/pluto-source/docs-4063D8)](https://sisl.github.io/SignalTemporalLogic.jl/notebooks/gda.html)
[![Build Status](https://github.com/sisl/SignalTemporalLogic.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/sisl/SignalTemporalLogic.jl/actions/workflows/CI.yml)
<!-- [![codecov](https://codecov.io/gh/sisl/SignalTemporalLogic.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/sisl/SignalTemporalLogic.jl) -->

## Installation
```julia
] add https://github.com/sisl/SignalTemporalLogic.jl
```

## Examples
[![Pluto tests](https://img.shields.io/badge/pluto-tests-4063D8)](https://sisl.github.io/SignalTemporalLogic.jl/notebooks/runtests.html)

See the tests for more elaborate examples: https://sisl.github.io/SignalTemporalLogic.jl/notebooks/runtests.html


### Example STL formula

```julia
# Signals (i.e., trace)
x = [-0.25, 0, 0.1, 0.6, 0.75, 1.0]

# STL formula: "eventually the signal will be greater than 0.5"
ϕ = @formula ◊(xₜ -> xₜ > 0.5)

# Check if formula is satisfied
ϕ(x)
```

### Example robustness

```julia
# Signals
x = [1, 2, 3, 4, -9, -8]

# STL formula: "eventually the signal will be greater than 0.5"
ϕ = @formula ◊(xₜ -> xₜ > 0.5)

# Robustness
∇ρ(x, ϕ)
# Outputs: [0.0  0.0  0.0  1.0  0.0  0.0]

# Smooth approximate robustness
∇ρ̃(x, ϕ)
# Outputs: [-0.0478501  -0.0429261  0.120196  0.970638  -1.67269e-5  -4.15121e-5]
```

---

[Robert Moss](https://github.com/mossr)
