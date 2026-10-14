# Verification status

Formal edition: October 13, 2026, America/Los_Angeles (execution logs may use UTC).

## Checked locally

- Six Lean proof modules plus `CatPhysics.lean`: elaborated and checked using Lean 4.28.0's unmodified frontend/kernel libraries, with explicit installation and import paths. Successful module exit codes are in `build.log`.
- All 65 named theorems: `#print axioms` reports captured in `axioms.log` and checked against the allowlist `{propext, Classical.choice, Quot.sound}`.
- No `sorry`, `admit`, custom `axiom`, `unsafe`, `native_decide`, or `implemented_by` declarations in project Lean proof sources (comments excluded).
- Six Python regression tests pass. They cover norm preservation, a zero/diagonal Hamiltonian, ties, probability/gain behavior, sampled purr power and Euler drift.
- Offline HTML: desktop and mobile rendered in headless Chromium; theorem filtering works, no page script errors or mobile horizontal overflow, all seven images load. All 97 local/external HTML reference entries were inspected for local resolution (external URLs were not link-checked).
- Source image bytes match the original attachment SHA-256 values recorded in `docs/source-manifest.json`.

## Method and limits

The stock `lean` executable's startup requires a process-path lookup unavailable in the execution environment. Instead, `tools/lean_frontend.c` initializes the installed Lean runtime and calls its existing `Lean.initSearchPath` and `Lean.Elab.runFrontend` functions. The sysroot is supplied explicitly. The driver does not patch Lean, fabricate a theorem, skip the elaborator/kernel, or add an axiom. Import initializers execute as they do in the normal compiler. The optional Python driver builds the same modules in dependency order.

Mathlib and its transitive sources are pinned; required compiled artifacts were obtained from the official Mathlib cache using the pinned source's cache hashing implementation. These build caches are not inside the ZIP.

**Native `lake build` and a remote GitHub Actions run were not executed successfully in this environment.** The included workflow performs those checks after upload. The actual local success reported here is the frontend/kernel route, not an invented remote build badge.

Numerical checks are not formal verification of Python. Formal proofs are not empirical tests. Spatial EFMW field derivation, the source's absent equation (1), behavioral band measurements, parameter calibration and the ODE existence/uniqueness problem are not proved by this project. Definitions and hypotheses such as the servitude constant and negative box potential are not experimental findings.
