import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

/-! Finite harmonic models. Frequencies are in cycles per unit time; phases in radians.
These definitions formalize a proposed model, not measurements of cat cognition. -/
namespace CatPhysics
noncomputable section
open scoped BigOperators

def angularFrequency (f : ℝ) : ℝ := 2 * Real.pi * f
def purr (amplitude frequency phase time : ℝ) : ℝ :=
  amplitude * Real.sin (angularFrequency frequency * time + phase)
def purrPower (amplitude frequency phase time : ℝ) : ℝ :=
  (purr amplitude frequency phase time) ^ 2

theorem angularFrequency_pos {f : ℝ} (hf : 0 < f) : 0 < angularFrequency f := by
  unfold angularFrequency
  positivity

theorem purrPower_nonneg (a f p t : ℝ) : 0 ≤ purrPower a f p t := sq_nonneg _

theorem purrPower_le_amplitude_sq (a f p t : ℝ) : purrPower a f p t ≤ a ^ 2 := by
  have h := Real.sin_sq_add_cos_sq (angularFrequency f * t + p)
  have hc := sq_nonneg (Real.cos (angularFrequency f * t + p))
  have ha := sq_nonneg a
  have hs : Real.sin (angularFrequency f * t + p) ^ 2 ≤ 1 := by linarith
  unfold purrPower purr
  nlinarith [mul_le_mul_of_nonneg_left hs ha]

theorem silent_purr (f p t : ℝ) : purrPower 0 f p t = 0 := by
  simp [purrPower, purr]

theorem purr_at_origin (a f : ℝ) : purr a f 0 0 = 0 := by
  simp [purr]

theorem purrPower_sign_invariant (a f p t : ℝ) :
    purrPower (-a) f p t = purrPower a f p t := by
  unfold purrPower purr
  ring

def harmonicStack {n : ℕ} (a : Fin n → ℂ) (f phase : Fin n → ℝ) (t : ℝ) : ℂ :=
  ∑ k, a k * Complex.exp (Complex.I * ((angularFrequency (f k) * t + phase k : ℝ) : ℂ))

theorem empty_harmonicStack (a : Fin 0 → ℂ) (f p : Fin 0 → ℝ) (t : ℝ) :
    harmonicStack a f p t = 0 := by simp [harmonicStack]

theorem harmonicStack_add {n : ℕ} (a b : Fin n → ℂ) (f p : Fin n → ℝ) (t : ℝ) :
    harmonicStack (a + b) f p t = harmonicStack a f p t + harmonicStack b f p t := by
  simp [harmonicStack, add_mul, Finset.sum_add_distrib]

def coupling (strength a b phaseA phaseB : ℝ) : ℝ :=
  strength * a * b * Real.cos (phaseA - phaseB)

theorem coupling_symmetric (l a b p q : ℝ) : coupling l a b p q = coupling l b a q p := by
  have h : Real.cos (p - q) = Real.cos (q - p) := by
    rw [← Real.cos_neg (q - p)]
    congr 1
    ring
  unfold coupling
  rw [h]
  ring

theorem coupling_synchronized (l a b p : ℝ) : coupling l a b p p = l * a * b := by
  simp [coupling]

theorem coupling_zero_strength (a b p q : ℝ) : coupling 0 a b p q = 0 := by
  simp [coupling]

theorem coupling_le_synchronized (l a b p q : ℝ) (h : 0 ≤ l * a * b) :
    coupling l a b p q ≤ coupling l a b p p := by
  rw [coupling_synchronized]
  exact mul_le_of_le_one_right h (Real.cos_le_one _)

/- Explicit counterexample: coupling is negative at phase difference π. -/
theorem opposite_phase_coupling : coupling 1 1 1 Real.pi 0 = -1 := by
  simp [coupling]

end
end CatPhysics
