import CatPhysics.Harmonics
import Mathlib.Analysis.Matrix.Hermitian

namespace CatPhysics
noncomputable section
open scoped BigOperators Matrix

abbrev State (n : ℕ) := Fin n → ℂ
abbrev Operator (n : ℕ) := Matrix (Fin n) (Fin n) ℂ

def statePower {n : ℕ} (ψ : State n) : ℝ := ∑ i, Complex.normSq (ψ i)
def Normalized {n : ℕ} (ψ : State n) : Prop := statePower ψ = 1
def rawExpectation {n : ℕ} (A : Operator n) (ψ : State n) : ℂ :=
  star ψ ⬝ᵥ (A *ᵥ ψ)
def expectation {n : ℕ} (A : Operator n) (ψ : State n) : ℝ :=
  (rawExpectation A ψ).re

theorem statePower_nonneg {n : ℕ} (ψ : State n) : 0 ≤ statePower ψ :=
  Finset.sum_nonneg (fun _ _ => Complex.normSq_nonneg _)

theorem zero_state_not_normalized {n : ℕ} : ¬ Normalized (0 : State n) := by
  simp [Normalized, statePower]

theorem statePower_smul {n : ℕ} (c : ℂ) (ψ : State n) :
    statePower (c • ψ) = Complex.normSq c * statePower ψ := by
  simp [statePower, Complex.normSq_mul, Finset.mul_sum]

theorem unit_phase_preserves_normalization {n : ℕ} (c : ℂ) (hc : Complex.normSq c = 1)
    (ψ : State n) (hψ : Normalized ψ) : Normalized (c • ψ) := by
  simpa only [Normalized, statePower_smul, hc, one_mul] using hψ

theorem unit_phase_preserves_mode_power {n : ℕ} (c : ℂ) (hc : Complex.normSq c = 1)
    (ψ : State n) (i : Fin n) : Complex.normSq ((c • ψ) i) = Complex.normSq (ψ i) := by
  simp [Complex.normSq_mul, hc]

theorem expectation_real {n : ℕ} (A : Operator n) (hA : A.IsHermitian) (ψ : State n) :
    (rawExpectation A ψ).im = 0 := hA.im_star_dotProduct_mulVec_self ψ

theorem expectation_add {n : ℕ} (A B : Operator n) (ψ : State n) :
    expectation (A + B) ψ = expectation A ψ + expectation B ψ := by
  simp [expectation, rawExpectation, Matrix.add_mulVec, dotProduct_add]

theorem expectation_real_smul {n : ℕ} (r : ℝ) (A : Operator n) (ψ : State n) :
    expectation (r • A) ψ = r * expectation A ψ := by
  simp [expectation, rawExpectation, Matrix.smul_mulVec, dotProduct_smul]

theorem hermitian_real_smul {n : ℕ} (r : ℝ) (A : Operator n) (hA : A.IsHermitian) :
    (r • A).IsHermitian := by
  apply Matrix.IsHermitian.ext
  intro i j
  simpa using congrArg (fun z : ℂ => r • z) (hA.apply i j)

structure Signals (n : ℕ) where
  blink : Operator n
  headbutt : Operator n
  loaf : Operator n
  meow : Operator n

structure SignalWeights where
  blink : ℝ
  headbutt : ℝ
  loaf : ℝ
  meow : ℝ

def mastery {n : ℕ} (s : Signals n) (b : SignalWeights) : Operator n :=
  b.blink • s.blink + b.headbutt • s.headbutt + b.loaf • s.loaf + b.meow • s.meow

theorem mastery_yield {n : ℕ} (s : Signals n) (b : SignalWeights) (ψ : State n) :
    expectation (mastery s b) ψ =
      b.blink * expectation s.blink ψ + b.headbutt * expectation s.headbutt ψ +
      b.loaf * expectation s.loaf ψ + b.meow * expectation s.meow ψ := by
  simp only [mastery, expectation_add, expectation_real_smul]

theorem mastery_hermitian {n : ℕ} (s : Signals n) (b : SignalWeights)
    (hB : s.blink.IsHermitian) (hN : s.headbutt.IsHermitian)
    (hL : s.loaf.IsHermitian) (hM : s.meow.IsHermitian) :
    (mastery s b).IsHermitian := by
  exact (((hermitian_real_smul _ _ hB).add (hermitian_real_smul _ _ hN)).add
    (hermitian_real_smul _ _ hL)).add (hermitian_real_smul _ _ hM)

structure Fields (n : ℕ) where
  exploration : Operator n
  foraging : Operator n
  tactile : Operator n
  coherence : Operator n

/- Eq. (1) is absent from the source. This total operator is completion C1. -/
def totalHamiltonian {n : ℕ} (fields : Fields n) (human : Operator n)
    (gamma power : ℝ) : Operator n :=
  fields.exploration + fields.foraging + fields.tactile + fields.coherence +
    (gamma * power) • human

theorem totalHamiltonian_hermitian {n : ℕ} (f : Fields n) (human : Operator n)
    (gamma power : ℝ) (hE : f.exploration.IsHermitian) (hF : f.foraging.IsHermitian)
    (hM : f.tactile.IsHermitian) (hW : f.coherence.IsHermitian) (hH : human.IsHermitian) :
    (totalHamiltonian f human gamma power).IsHermitian :=
  (((hE.add hF).add hM).add hW).add (hermitian_real_smul _ _ hH)

/- Instantaneous algebraic norm-power rate for ψ' = -i H ψ (ℏ = 1). -/
def powerRate {n : ℕ} (H : Operator n) (ψ : State n) : ℝ :=
  2 * ((-Complex.I) * rawExpectation H ψ).re

theorem hermitian_powerRate_zero {n : ℕ} (H : Operator n) (hH : H.IsHermitian)
    (ψ : State n) : powerRate H ψ = 0 := by
  simp [powerRate, Complex.mul_re, expectation_real H hH ψ]

/- Explicit Euler is not unitary, even for a real one-mode Hamiltonian H = 1. -/
theorem euler_step_power (dt : ℝ) :
    Complex.normSq (1 - Complex.I * (dt : ℂ)) = 1 + dt ^ 2 := by
  simp [Complex.normSq_apply, pow_two]

theorem euler_step_grows {dt : ℝ} (h : dt ≠ 0) :
    1 < Complex.normSq (1 - Complex.I * (dt : ℂ)) := by
  rw [euler_step_power]
  have := sq_pos_of_ne_zero h
  linarith

end
end CatPhysics
