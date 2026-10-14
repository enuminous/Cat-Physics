# Source transcription and equation coverage

Target frozen from the user-supplied August 16, 2025 article, six mathematical PNG panels and one illustrative PNG. Image hashes and original names are in `source-manifest.json`. The picture of the professor cat is decorative; its blackboard marks are not treated as additional model equations.

## P1 — state and missing evolution law

“EFMW-H: Cat Cognition as Coupled Field Harmonics.” The state is Ψ(t) ∈ ℂᴺ, with components explore, hunt, eat, groom, nap, play, social, territory, … . The panel ends: “We evolve Ψ with an EFMW harmonic Hamiltonian plus a human-control coupling:”. **No following equation (1) is visible in this panel or the remaining supplied panels.**

`State n`, `HilbertState n`, `Normalized`, and `statePower` formalize finite complex states. Normalization and the differential equation are explicit additions, not recovered source text.

## P2 — fields and purr

Normalized mathematical readings (punctuation glitches retained as ambiguities below):

- E / exploration: H_E = g_E ∇·E(x,t), E(x,t) = Σ_k ε_k u_k(x) exp(iω_k t).
- F / foraging: H_F = g_F F(t), Ḟ = α(cues) − δ(satiation).
- M / whisker–tactile: H_M = g_M ‖∇×M(x,t)‖, M(x,t) = Σ_k m_k v_k(x) exp(iΩ_k t).
- W / coherence–will: H_W = g_W W(t), described as boosting mode synchrony.
- Purr: p(t) = p₀ sin(2π f_p t + φ), f_p ≈ 25 Hz.
- A broken raw LaTeX line supplies Γ_p |p(t)|² H_human as a coupling to equation (1), and claims increased human compliance when purr power rises.

The rendering includes commas after several g coefficients, a stray `!` near ∇ in the E line, punctuation in the harmonic sums, and an unrendered final formula. We interpret adjacency as multiplication only where declared in `CONVENTIONS.md`. The F line could mean α evaluated at cues or α times cues; the discrete implementation chooses multiplication and records it as completion C4.

`harmonicStack` handles finite complex harmonic sums; x-dependent amplitudes can be supplied at a fixed x. `purr`, `purrPower` and their bounds are formalized. `Fields` takes four finite operators as **inputs**; the source does not supply a spatial domain or operator lift, so no divergence/curl PDE derivation is claimed. `foragingStep` is an explicitly added discrete approximation, not a proof of the continuous field law.

## P3 — readout and compliance, equation (2)

Y(t) = ⟨Ψ(t)|H_human|Ψ(t)⟩ = β_B⟨B⟩ + β_N⟨N⟩ + β_L⟨L⟩ + β_μ⟨μ⟩.

The four signals are slow-blink B, head-butt N, loaf L, and meow μ. The source’s displayed code normalizes to:

P_comply = σ(α₀ + α_p overline(|p|²)^Δ + α_Y overline(Y)^Δ),
σ(z) = 1/(1 + exp(−z)).

The averaging symbol is undefined. The prose interpretation connects slow-blink and purring to humans opening cans. In this repository `mastery`, `mastery_yield`, and `expectation_real` handle the operator readout; `sampledMean` is completion C3; `compliance` is precisely the normalized logistic formula. The bracket readout is real when the operator is Hermitian. Probability bounds do not imply calibration or causal effects.

## P4 — harmonics and coupling

Ψ_c(t) = Σ_n a_(c,n) exp(i(ω_(c,n)t + φ_(c,n))).

The listed proposed bands are nap 0.01–0.05 Hz, zoomies 4–10 Hz, hunt focus 2–8 Hz, purr carrier 20–30 Hz. The nap line labels its parameter ω while giving units Hz. We resolve **f in Hz, ω = 2πf in radians per unit time**. No data are attached to establish these behavioral frequency bands. The “human-bone-mending” phrase is an unsupported health-related flourish of the source and is not an output or scientific conclusion of the repository.

C_cf = λ_cf a_c a_f cos(φ_c − φ_f).

`harmonicStack`, `angularFrequency`, and `coupling` encode these finite models. Symmetry requires λ_cf = λ_fc; the two-argument coupling theorem uses the same strength in both directions. Synchronized phases maximize this expression only if λ a_c a_f ≥ 0. A negative opposite-phase counterexample is included.

## P5 — control equation (3) and boundaries

Actions A = {scratch, meow, stare, loaf, knock glass}.

a* ∈ argmax_a { E[Treats | a] + η ΔV_status(a) + κ P_comply(a) }.

The source writes equality to argmax, without a tie convention. We formalize the optimality predicate and prove existence; we do not assume a unique action. `toy_meow_unique` proves uniqueness only for its disclosed invented toy scores.

Boundary prose:

- H_s = 1 (“Human Servitude Constant”, fixed by history).
- Couch entropy increases unless trimmed by N (“head-butt tax”).
- V_box ≪ 0 regardless of box size.

These are satirical modeling choices. `humanServitudeConstant_value` is a definition check only. The source gives no entropy law; `couchStep` and `entropyTrajectory` are completion C4 and their monotonicity is conditional on disruption ≥ cleanup. The informal ≪ relation has no numerical threshold: `box_preferred_to_zero` merely carries an explicit negative-potential assumption and is identified as such, not counted as an independent physical discovery.

## P6 — engineering recipe

Use (1) to evolve Ψ, inject purr power as a human-operator gain, use (2) for compliance and (3) for actions. Tune g_E,g_F,g_M,g_W,Γ_p,α,β,λ_cf per cat; measure bands to fit. This is a proposed program, not supplied measurements. No fit, prediction accuracy, or subject experiment is claimed here.

## P7 — illustration

The cat professor image is bundled unchanged, attributed with the source article. No separate authorship or generation provenance is asserted.
