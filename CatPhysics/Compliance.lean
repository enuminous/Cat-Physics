import CatPhysics.Harmonics
import Mathlib.Tactic.FieldSimp

namespace CatPhysics
noncomputable section
open scoped BigOperators

def sigmoid (z : ℝ) : ℝ := 1 / (1 + Real.exp (-z))

theorem sigmoid_pos (z : ℝ) : 0 < sigmoid z := by
  unfold sigmoid
  positivity

theorem sigmoid_lt_one (z : ℝ) : sigmoid z < 1 := by
  have he := Real.exp_pos (-z)
  unfold sigmoid
  apply (div_lt_one (by positivity)).2
  linarith

theorem sigmoid_zero : sigmoid 0 = 1 / 2 := by norm_num [sigmoid]

theorem sigmoid_strictMono : StrictMono sigmoid := by
  intro x y h
  have he : Real.exp (-y) < Real.exp (-x) := Real.exp_lt_exp.mpr (neg_lt_neg h)
  apply one_div_lt_one_div_of_lt
  · positivity
  · linarith

theorem sigmoid_injective : Function.Injective sigmoid := sigmoid_strictMono.injective

theorem sigmoid_neg (z : ℝ) : sigmoid (-z) = 1 - sigmoid z := by
  have h := Real.exp_pos z
  rw [sigmoid, neg_neg, sigmoid, Real.exp_neg]
  field_simp
  ring

structure ComplianceParameters where
  intercept : ℝ
  powerGain : ℝ
  yieldGain : ℝ

def compliance (p : ComplianceParameters) (meanPower meanYield : ℝ) : ℝ :=
  sigmoid (p.intercept + p.powerGain * meanPower + p.yieldGain * meanYield)

theorem compliance_bounds (p : ComplianceParameters) (power yield : ℝ) :
    0 < compliance p power yield ∧ compliance p power yield < 1 :=
  ⟨sigmoid_pos _, sigmoid_lt_one _⟩

theorem compliance_mono_power (p : ComplianceParameters) (h : 0 ≤ p.powerGain)
    {x y : ℝ} (hxy : x ≤ y) (yield : ℝ) :
    compliance p x yield ≤ compliance p y yield := by
  apply sigmoid_strictMono.monotone
  have := mul_le_mul_of_nonneg_left hxy h
  linarith

theorem compliance_mono_yield (p : ComplianceParameters) (h : 0 ≤ p.yieldGain)
    {x y : ℝ} (hxy : x ≤ y) (power : ℝ) :
    compliance p power x ≤ compliance p power y := by
  apply sigmoid_strictMono.monotone
  have := mul_le_mul_of_nonneg_left hxy h
  linarith

theorem zero_powerGain (p : ComplianceParameters) (h : p.powerGain = 0) (x y z : ℝ) :
    compliance p x z = compliance p y z := by simp [compliance, h]

theorem negative_powerGain_reverses {p : ComplianceParameters} (h : p.powerGain < 0)
    {x y : ℝ} (hxy : x < y) (z : ℝ) : compliance p y z < compliance p x z := by
  apply sigmoid_strictMono
  have := mul_lt_mul_of_neg_left hxy h
  linarith

/- A finite sampled mean is an explicit completion of the undefined bar-Delta notation. -/
def sampledMean {n : ℕ} (x : Fin n → ℝ) : ℝ := (∑ i, x i) / n

theorem sampledMean_nonneg {n : ℕ} (x : Fin n → ℝ) (h : ∀ i, 0 ≤ x i) :
    0 ≤ sampledMean x := by
  apply div_nonneg (Finset.sum_nonneg (fun i _ => h i))
  exact Nat.cast_nonneg n

theorem sampledMean_const {n : ℕ} (hn : 0 < n) (c : ℝ) :
    sampledMean (fun _ : Fin n => c) = c := by
  have h : (n : ℝ) ≠ 0 := by exact_mod_cast (Nat.ne_of_gt hn)
  simp [sampledMean, h]

theorem sampledMean_le {n : ℕ} (hn : 0 < n) (x : Fin n → ℝ) (B : ℝ)
    (h : ∀ i, x i ≤ B) : sampledMean x ≤ B := by
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  apply (div_le_iff₀ hn').2
  calc
    ∑ i, x i ≤ ∑ _i : Fin n, B := Finset.sum_le_sum (fun i _ => h i)
    _ = B * n := by simp [mul_comm]

theorem sampled_purr_power_bounds {n : ℕ} (hn : 0 < n) (a f p : ℝ) (t : Fin n → ℝ) :
    0 ≤ sampledMean (fun i => purrPower a f p (t i)) ∧
    sampledMean (fun i => purrPower a f p (t i)) ≤ a ^ 2 := by
  exact ⟨sampledMean_nonneg _ (fun _ => purrPower_nonneg _ _ _ _),
    sampledMean_le hn _ _ (fun _ => purrPower_le_amplitude_sq _ _ _ _)⟩

end
end CatPhysics
