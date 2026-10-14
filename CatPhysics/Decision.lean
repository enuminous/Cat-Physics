import CatPhysics.Compliance
import Mathlib.Data.Finset.Max
import Mathlib.Tactic.FinCases

namespace CatPhysics
noncomputable section

inductive Action where
  | scratch | meow | stare | loaf | knockGlass
  deriving DecidableEq, Repr, Fintype

structure ActionValues where
  expectedTreats : Action → ℝ
  statusChange : Action → ℝ
  complyProbability : Action → ℝ
  eta : ℝ
  kappa : ℝ

def utility (v : ActionValues) (a : Action) : ℝ :=
  v.expectedTreats a + v.eta * v.statusChange a + v.kappa * v.complyProbability a

def Optimal (score : Action → ℝ) (a : Action) : Prop := ∀ b, score b ≤ score a

theorem optimal_exists (score : Action → ℝ) : ∃ a, Optimal score a := by
  obtain ⟨a, _, ha⟩ := Finset.exists_max_image Finset.univ score
    (by exact ⟨Action.meow, Finset.mem_univ _⟩)
  exact ⟨a, fun b => ha b (Finset.mem_univ b)⟩

theorem optimal_shift_iff (score : Action → ℝ) (c : ℝ) (a : Action) :
    Optimal (fun b => score b + c) a ↔ Optimal score a := by
  simp [Optimal]

theorem optimal_scale_iff (score : Action → ℝ) (c : ℝ) (hc : 0 < c) (a : Action) :
    Optimal (fun b => c * score b) a ↔ Optimal score a := by
  simp [Optimal, mul_le_mul_iff_right₀ hc]

theorem constant_score_ties (c : ℝ) (a : Action) : Optimal (fun _ => c) a := by
  intro b
  exact le_rfl

theorem maximizer_need_not_be_unique :
    ∃ score : Action → ℝ, Optimal score .meow ∧ Optimal score .loaf ∧
      Action.meow ≠ Action.loaf := by
  exact ⟨fun _ => 0, constant_score_ties _ _, constant_score_ties _ _, by decide⟩

theorem optimal_scores_equal {score : Action → ℝ} {a b : Action}
    (ha : Optimal score a) (hb : Optimal score b) : score a = score b :=
  le_antisymm (hb a) (ha b)

theorem compliance_utility_bounded (v : ActionValues) (hk : 0 ≤ v.kappa)
    (hp : ∀ a, 0 ≤ v.complyProbability a ∧ v.complyProbability a ≤ 1) (a : Action) :
    v.expectedTreats a + v.eta * v.statusChange a ≤ utility v a ∧
    utility v a ≤ v.expectedTreats a + v.eta * v.statusChange a + v.kappa := by
  have h0 := mul_nonneg hk (hp a).1
  have h1 := mul_le_mul_of_nonneg_left (hp a).2 hk
  dsimp [utility]
  constructor <;> linarith

def toyScore : Action → ℝ
  | .scratch => 1
  | .meow => 7
  | .stare => 3
  | .loaf => 2
  | .knockGlass => 0

theorem toy_meow_optimal : Optimal toyScore .meow := by
  intro a
  cases a <;> norm_num [toyScore]

theorem toy_meow_unique {a : Action} (h : Optimal toyScore a) : a = .meow := by
  have hm := h .meow
  cases a <;> simp_all [toyScore] <;> norm_num at hm

end
end CatPhysics
