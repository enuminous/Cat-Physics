import CatPhysics.Operators
import Mathlib.Analysis.InnerProductSpace.Calculus
import Mathlib.Analysis.Calculus.MeanValue

namespace CatPhysics
noncomputable section

/- A conditional conservation theorem for completion C1; no existence theorem is assumed
to follow from the source panels. ℏ = 1, finite-dimensional complex Hilbert space. -/
abbrev HilbertState (n : ℕ) := EuclideanSpace ℂ (Fin n)

theorem schrodinger_inner_derivative_zero {n : ℕ}
    (H : ℝ → HilbertState n →ₗ[ℂ] HilbertState n)
    (ψ : ℝ → HilbertState n) (t : ℝ)
    (hH : (H t).IsSymmetric)
    (hψ : HasDerivAt ψ ((-Complex.I) • H t (ψ t)) t) :
    HasDerivAt (fun s => inner ℂ (ψ s) (ψ s)) 0 t := by
  have hd := hψ.inner ℂ hψ
  have hz : inner ℂ (ψ t) ((-Complex.I) • H t (ψ t)) +
      inner ℂ ((-Complex.I) • H t (ψ t)) (ψ t) = 0 := by
    simp only [inner_smul_right, inner_smul_left, map_neg, Complex.conj_I, neg_neg]
    rw [hH (ψ t) (ψ t)]
    ring
  simpa only [hz] using hd

theorem schrodinger_inner_conserved {n : ℕ}
    (H : ℝ → HilbertState n →ₗ[ℂ] HilbertState n)
    (ψ : ℝ → HilbertState n)
    (hH : ∀ t, (H t).IsSymmetric)
    (hψ : ∀ t, HasDerivAt ψ ((-Complex.I) • H t (ψ t)) t) (s t : ℝ) :
    inner ℂ (ψ s) (ψ s) = inner ℂ (ψ t) (ψ t) := by
  have hd := fun x => schrodinger_inner_derivative_zero H ψ x (hH x) (hψ x)
  exact is_const_of_deriv_eq_zero (fun x => (hd x).differentiableAt)
    (fun x => (hd x).deriv) s t

theorem schrodinger_norm_conserved {n : ℕ}
    (H : ℝ → HilbertState n →ₗ[ℂ] HilbertState n)
    (ψ : ℝ → HilbertState n)
    (hH : ∀ t, (H t).IsSymmetric)
    (hψ : ∀ t, HasDerivAt ψ ((-Complex.I) • H t (ψ t)) t) (s t : ℝ) :
    ‖ψ s‖ = ‖ψ t‖ := by
  have he := schrodinger_inner_conserved H ψ hH hψ s t
  rw [@norm_eq_sqrt_re_inner ℂ, @norm_eq_sqrt_re_inner ℂ, he]

theorem schrodinger_normalization_preserved {n : ℕ}
    (H : ℝ → HilbertState n →ₗ[ℂ] HilbertState n)
    (ψ : ℝ → HilbertState n)
    (hH : ∀ t, (H t).IsSymmetric)
    (hψ : ∀ t, HasDerivAt ψ ((-Complex.I) • H t (ψ t)) t)
    (h0 : ‖ψ 0‖ = 1) (t : ℝ) : ‖ψ t‖ = 1 := by
  exact (schrodinger_norm_conserved H ψ hH hψ t 0).trans h0

theorem matrix_schrodinger_norm_conserved {n : ℕ}
    (H : ℝ → Operator n) (ψ : ℝ → HilbertState n)
    (hH : ∀ t, (H t).IsHermitian)
    (hψ : ∀ t, HasDerivAt ψ ((-Complex.I) • (H t).toEuclideanLin (ψ t)) t)
    (s t : ℝ) : ‖ψ s‖ = ‖ψ t‖ := by
  exact schrodinger_norm_conserved (fun t => (H t).toEuclideanLin) ψ
    (fun t => Matrix.isHermitian_iff_isSymmetric.mp (hH t)) hψ s t

theorem totalHamiltonian_norm_conserved {n : ℕ}
    (f : ℝ → Fields n) (human : ℝ → Operator n) (gamma : ℝ) (power : ℝ → ℝ)
    (ψ : ℝ → HilbertState n)
    (hE : ∀ t, (f t).exploration.IsHermitian) (hF : ∀ t, (f t).foraging.IsHermitian)
    (hM : ∀ t, (f t).tactile.IsHermitian) (hW : ∀ t, (f t).coherence.IsHermitian)
    (hH : ∀ t, (human t).IsHermitian)
    (hψ : ∀ t, HasDerivAt ψ ((-Complex.I) •
      (totalHamiltonian (f t) (human t) gamma (power t)).toEuclideanLin (ψ t)) t)
    (s t : ℝ) : ‖ψ s‖ = ‖ψ t‖ := by
  exact matrix_schrodinger_norm_conserved
    (fun t => totalHamiltonian (f t) (human t) gamma (power t)) ψ
    (fun t => totalHamiltonian_hermitian _ _ _ _ (hE t) (hF t) (hM t) (hW t) (hH t))
    hψ s t

end
end CatPhysics
