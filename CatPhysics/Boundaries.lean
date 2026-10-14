import CatPhysics.Decision

namespace CatPhysics
noncomputable section

/- Explicit discrete completions of qualitative source statements. -/
def foragingStep (current alpha cues delta satiation dt : ℝ) : ℝ :=
  current + dt * (alpha * cues - delta * satiation)

theorem foraging_grows_iff (F a c d s dt : ℝ) (ht : 0 < dt) :
    F ≤ foragingStep F a c d s dt ↔ d * s ≤ a * c := by
  unfold foragingStep
  constructor <;> intro h
  · nlinarith
  · have := mul_nonneg (le_of_lt ht) (sub_nonneg.mpr h)
    linarith

theorem balanced_foraging (F a c d s dt : ℝ) (h : a * c = d * s) :
    foragingStep F a c d s dt = F := by simp [foragingStep, h]

def couchStep (entropy disruption cleanup : ℝ) : ℝ := entropy + disruption - cleanup

theorem couch_increases_iff (S d c : ℝ) : S ≤ couchStep S d c ↔ c ≤ d := by
  unfold couchStep
  constructor <;> intro h <;> linarith

theorem couch_can_decrease : couchStep 10 1 3 < 10 := by norm_num [couchStep]

def entropyTrajectory (initial : ℝ) (disruption cleanup : ℕ → ℝ) : ℕ → ℝ
  | 0 => initial
  | n + 1 => couchStep (entropyTrajectory initial disruption cleanup n) (disruption n) (cleanup n)

theorem entropyTrajectory_monotone (S : ℝ) (d c : ℕ → ℝ) (h : ∀ n, c n ≤ d n) :
    Monotone (entropyTrajectory S d c) := by
  apply monotone_nat_of_le_succ
  intro n
  exact (couch_increases_iff _ _ _).2 (h n)

def humanServitudeConstant : ℝ := 1

theorem humanServitudeConstant_value : humanServitudeConstant = 1 := rfl

/- Negativity is an explicit parameter assumption, not a deduction about all real boxes. -/
theorem box_preferred_to_zero (boxPotential : ℝ) (h : boxPotential < 0) :
    boxPotential < (0 : ℝ) := h

end
end CatPhysics
