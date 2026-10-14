# Frozen conventions, v1.0

## Mathematical types

- Finite dimension N; all formal theorems state their dimension explicitly. The zero-dimensional case is allowed algebraically but has no normalized state.
- Complex amplitudes. Hermitian finite matrices represent real observables. `rawExpectation` is the complex quadratic form; `expectation` is its real part. `expectation_real` supplies the condition under which this loses no imaginary component.
- `statePower` is Σ|ψ_i|². A physical probability interpretation additionally requires normalization and a measurement model; the repository does not infer that cats have quantum cognitive states.
- Couplings, signal weights, logistic coefficients, phases, times and frequencies are real. Amplitude signs are allowed unless a theorem explicitly restricts a product.
- Time is in chosen model units, seconds when reporting Hz. Frequencies f are cycles per unit time; angular frequencies are 2πf. Argument of exp, sin, cos and sigmoid must be dimensionless.
- Finite Fourier sums avoid an unsupported infinite-series convergence assumption.

## C1 — supplied completion of the missing equation (1)

Proposed finite-dimensional model, with ℏ = 1 in model units:

H(t) = H_E(t) + H_F(t) + H_M(t) + H_W(t) + Γ_p p(t)² H_human(t),

Ψ′(t) = −i H(t) Ψ(t).

This is an added modeling choice, not a transcription or a derivation from the EFMW root equation. `totalHamiltonian_hermitian` shows that real linear combinations of Hermitian components remain Hermitian. `Dynamics.lean` proves conservation for a differentiable trajectory **if it satisfies this ODE with symmetric operators**. It does not prove solution existence or uniqueness, derive a spatial field theory, or show that arbitrary fitted harmonic stacks solve this ODE.

No physical energy/time conversion has been supplied by the source; ℏ = 1 here fixes units within the model, not a measured value for cognition.

## C2 — spatial fields and operator lifting remain open

∇·E and ‖∇×M‖ are scalar expressions under ordinary vector-field conventions. Turning them into finite matrices needs an explicit basis, domain, regularity, and boundary conditions. They are therefore exposed as independent operator inputs. Multiplying a scalar by the identity is a possible lift but cannot by itself transfer probability between modes. A complex-valued divergence is not automatically a real Hermitian potential. Taking a real part would be an additional repair, not an unnoticed simplification.

No arbitrary operator inputs are advertised as a formalization of the missing spatial construction. `Fields` is an interface with stated obligations.

## C3 — averaging

`sampledMean` uses a finite equally weighted set of samples. Theorems requiring a genuine mean include n > 0. Lean defines zero-denominator division as zero, so n = 0 evaluates algebraically to zero; the experimental protocol excludes it. The source's Δ window is interpreted only by a chosen sampling grid within that window. No continuous integral or quadrature-error theorem is claimed.

## C4 — illustrative discrete boundaries

F_next = F + Δt(α cues − δ satiation).
S_next = S + disruption − cleanup.

These are disclosed toy completions. They are not recovered differential equations for couch thermodynamic entropy. The foraging update is forward Euler; no accuracy theorem is claimed. The proof `euler_step_grows` demonstrates why forward Euler should not be called a unitary integrator for C1.

## Decision and fitting

The five actions are finite and nonempty. `Optimal` is set-valued in spirit: all tied maxima satisfy it. The Python demo chooses the first action in a documented list on ties. `expectedTreats` is an input conditional expectation estimate, not a formalized probability measure. Treats, status and probability enter compatible utility units through η and κ.

Purr→compliance monotonicity requires α_p ≥ 0, and yield→compliance requires α_Y ≥ 0. These signs must be independently justified or fitted on training data; they are not empirical facts proved by Lean. When α_p < 0 the predicted direction reverses, and this is itself proved.
