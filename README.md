# Cat Physics

<!-- ENUMINOUS-UNIFIED-NAV:START -->
## Repository navigation

**eNuminous network:** [All public repositories](https://github.com/enuminous/EFMW/blob/main/REPOSITORY_NAVIGATION.md) · [EFMW](https://github.com/enuminous/EFMW) · [102 equations](https://github.com/enuminous/Monolithic_102_EFMW) · [Frozen Lean](https://github.com/enuminous/Monolithic-102-Zoo-Lean4) · [Zoo](https://github.com/enuminous/Tortoise) · [Papers](https://github.com/enuminous/papers) · [Quantum geometry](https://github.com/enuminous/Base888-Quantum-Geometry)

**This project:** [Repository home](https://github.com/enuminous/Cat-Physics) · [Subject index](https://github.com/enuminous/EFMW/blob/main/REPOSITORY_NAVIGATION.md#fundamental-physics-cosmology-and-quantum-geometry)

<details open>
<summary><strong>On this page</strong></summary>

- [What is included](#what-is-included)
- [What Lean proves](#what-lean-proves)
- [Build and audit](#build-and-audit)
- [Run the illustration](#run-the-illustration)
- [Repository and article site](#repository-and-article-site)
- [Attribution](#attribution)


</details>

**Related repositories:** [Universe5](https://github.com/enuminous/Universe5) · [FieldSpace](https://github.com/enuminous/FieldSpace) · [Music-of-the-Spheres](https://github.com/enuminous/Music-of-the-Spheres) · [Cosmology](https://github.com/enuminous/Cosmology) · [EFMW](https://github.com/enuminous/EFMW) · [papers](https://github.com/enuminous/papers)

> **Evidence boundary:** A link between projects is navigation, not an assertion of proven equivalence, experimental validation, or shared authorship. See each repository’s own status and review notes.
<!-- ENUMINOUS-UNIFIED-NAV:END -->


**The Universe is Just a Complicated Cat Toy, and Humans are the Staff Who Keep it Running.**

Matthew Chenoweth Wright · Original article August 16, 2025 · Formal edition October 13, 2026.

The source repository for the original satire, all seven original images, and a Lean 4 formalization of a precisely stated finite harmonic model. **65 named theorems were checked through Lean 4.28.0's frontend and kernel library interface.** No unfinished proof or custom axiom is present. The dependency audit permits only the usual Lean foundational axioms (`propext`, `Classical.choice`, `Quot.sound`). These mathematical implications do not establish empirical feline cognition or new physical laws.

Open **[index.html](index.html)** for the illustrated article and searchable theorem register.

## What is included

| Content | Location |
|---|---|
| Original article and images | [Article](docs/ARTICLE.md), `images/` |
| Every source panel transcribed and mapped | [Coverage](docs/SOURCE_TRANSCRIPTION.md) |
| Frozen mathematical types and added assumptions | [Conventions](docs/CONVENTIONS.md) |
| Evidence, negative results, unresolved obligations | [Audit](docs/AUDIT.md) |
| Formal proof sources | `CatPhysics/`, [umbrella module](CatPhysics.lean) |
| Theorem statements | [Registry](docs/theorems.json) |
| Local check details and logs | [Verification](verification/STATUS.md) |
| Synthetic executable model | [Python demo](tools/demo.py), [saved output](verification/demo-output.json) |
| Repeatable CI | [.github/workflows/lean.yml](.github/workflows/lean.yml) |

## What Lean proves

- Purr power is nonnegative and bounded by amplitude squared; amplitude sign has no effect on power.
- Cosine phase coupling is symmetric for the same strength. Synchronization maximizes it only under the stated sign condition.
- Real weighted Hermitian signals give a real readout, and Hermitian total Hamiltonians remain Hermitian.
- The completed Schrödinger-form evolution conserves norm for a supplied differentiable solution, including time-dependent Hermitian operators. Unit-modulus global phases preserve every mode's power.
- The logistic readout lies in (0,1), is strictly monotone and has the expected complement identity. Negative purr gain reverses the proposed monotonic effect.
- Finite action maxima exist; ties are possible. Utility is invariant to a common shift or positive scale. A disclosed toy example has a unique optimum.
- Discrete foraging and couch updates obey their explicit conditional inequalities. Naïve Euler evolution need not preserve norm.

**The missing equation (1):** the supplied images refer to it but do not contain it. We supply a clearly marked finite-dimensional completion C1. The spatial divergence/curl operator construction, solution existence/uniqueness and empirical cognitive-frequency claims remain open. The harmonics and the completed ODE are not asserted to be mutually compatible without additional constraints.

## Build and audit

Install [elan](https://github.com/leanprover/elan), which reads the included `lean-toolchain`.

```sh
lake update
lake exe cache get
lake build
python3 tools/audit.py --generate
lake env lean CatPhysics/Audit.lean > verification/axioms.log
python3 tools/audit.py --check-log verification/axioms.log
python3 -m unittest discover -s tests -v
python3 tools/demo.py --output verification/demo-output.json
```

Lean is pinned to **4.28.0**. Mathlib is pinned to commit
`8f9d9cff6bd728b17a24e163c9402775d9e6a365`. Transitive dependencies are in `lake-manifest.json`.
The CI workflow fetches only the required Mathlib cache roots and allows 45 minutes.
Compiled dependencies, build artifacts and the compiler are deliberately excluded from the source ZIP.
A network connection is required for the first dependency setup; the HTML site itself uses local assets only.

The local environment could not start the stock Lean CLI because its process-path lookup was unavailable. All modules were nevertheless checked using the **unmodified installed Lean frontend/kernel libraries with an explicit sysroot**, and the exact driver is included. The standard `lake build` command and remote GitHub Actions have **not** been observed running here. To reproduce the local route after dependencies are available:

```sh
python3 tools/check_frontend.py --sysroot /absolute/path/to/lean-4.28.0
```

## Run the illustration

The Python demo needs only Python 3. It uses a two-mode, real-symmetric Hamiltonian with invented disclosed parameters, midpoint-frozen exact 2×2 exponentials, sampled purr power, a logistic readout and the five source actions. The numerical integrator's exact frozen-step formula does not make the full time-dependent approximation exact. Real-number probability bounds in Lean can saturate to 0 or 1 in floating-point arithmetic for extreme inputs; the tests document this distinction.

## Repository and article site

Published source: [enuminous/Cat-Physics](https://github.com/enuminous/Cat-Physics).

```sh
git clone https://github.com/enuminous/Cat-Physics.git
cd Cat-Physics
```

Use the build commands above to check the project locally. The
[Lean proofs and reproducibility workflow](https://github.com/enuminous/Cat-Physics/actions/workflows/lean.yml)
runs on pushes and pull requests.

The article site is included as `index.html`. To serve it with GitHub Pages, use
**Settings → Pages → Deploy from a branch → main → /(root)**. Once enabled, its
expected URL is `https://enuminous.github.io/Cat-Physics/`.
The site has no external JavaScript, font, or image dependencies.

## Attribution

Original: [Cat Physics on Medium](https://medium.com/@enuminous/cat-physics-b960c0f6f243).
Text and images are author-supplied. See [rights](LICENSE.md), [sources](docs/REFERENCES.md), and [image hashes](docs/source-manifest.json).
