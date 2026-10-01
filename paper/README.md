# Preprint source bundle

`preprint.tex` — *Robust analog two-qubit gates from deep reinforcement learning: an independent
reproduction and family-resolved assessment.* REVTeX 4.2, APS two-column preprint style, 19 pages.

## Build

```powershell
pdflatex preprint
bibtex   preprint
pdflatex preprint
pdflatex preprint
```

No `-shell-escape` is needed: unlike the thesis, this document contains no live TikZ and no
externalization. All figures are pre-rendered PDFs in `figures/`. `references.bib` here is the thesis
bibliography plus five entries used only by the preprint (Zhang2003, Makhlin2002, VidalDawson2004,
ShendeMarkovBullock2004, Foxen2020).

## Authorship

The paper is set with the thesis author as sole author and both supervisors thanked in the
acknowledgments, which is the usual convention for a preprint drawn from a bachelor's thesis. If they
should instead appear as co-authors, add `\author{...}` / `\affiliation{...}` blocks after the
existing one and trim the first sentence of the acknowledgments.

## Figures

Six figures are reused unchanged from the thesis (`gmon_architecture_schematic`, `ufo_cost_structure`,
`architecture_sweep_pareto_combined`, `ufo_weight_sweep_robustness`, `adam_single_target_horizon_sweep`,
`adam_family_sweep`). Four were built for this paper; their pgfplots sources are in `figsrc/` and read the
CSVs under `../data/` directly.

| File | Source | Content |
| --- | --- | --- |
| `single_target_comparison_v3.pdf` | `figsrc/fig_single_target.tex` | Fig. 6: nominal cost, fidelity, leakage and runtime of Adam (70 ns) and the two TRPO agents, with both synthesis references. Values typed from the nominal re-evaluation of the stored plans (listed in the source header). |
| `robustness_v3.pdf` | `figsrc/fig_robustness.tex` | Fig. 7: average fidelity and variance versus noise strength for the four controllers of Table III, from `data/robustness_analysis_3/`. |
| `noise_training_mechanism.pdf` | `figsrc/fig_mechanism.tex` | Fig. 8: matched-history paired differences, closed versus open loop, excess infidelity versus duration with the first-order prediction. |
| `runtime_vs_alpha_v3.pdf` | `figsrc/fig_runtime.tex` | Fig. 9: runtime, fidelity and leakage across `N(a, a, pi/2)` for the curriculum and the Adam sweep, with both synthesis references. |

Rebuild any of them with `pdflatex fig_<name>` from inside `figsrc/`, then copy the resulting PDF into
`figures/` under the name above. The `*_v2.pdf` files in `figures/` belong to the version of 2026-09-07
and are no longer included.

## Changes of 2026-09-22

The version of 2026-09-07 rested on a controller that was not what it claimed to be, and on several
statements that did not match the data or the original paper. The current version corrects them:

- **Noise-trained controller.** The earlier "noise-optimized TRPO" plan (`uqc_repro/final_results/noise/`)
  targets `N(0, 0, pi/2)`, not `N(2.2, 2.2, pi/2)`, and was scored against its own target. The robustness
  section, Table III, Table IV, the abstract and the conclusions are now built on the genuine noise-trained
  run (`final_results/trpo_noise_alpha_2.2/`), a matched comparison of both training histories, a
  closed-loop test and a first-order analysis of the white-noise model. The earlier conclusion (stochastic
  training helps, crossover with Adam at 1.3 MHz) is withdrawn; the data show no benefit for the deployed
  pulse.
- **Adam baseline.** It was trained under 1 MHz noise (one noisy trajectory per step), not without noise,
  and its horizon is chosen by the lowest sampled loss. The text now says so, and the 70 ns plan was re-run
  and evaluated alongside the 60 ns one.
- **Original baseline.** The SGD baseline of Niu et al. also used Adam, a noisy objective (ten
  trajectories per step at 1 MHz) and about 2000 restarts, and was compared over 0.1–3.5 MHz; the earlier
  text said otherwise.
- **Target family.** Every member of `N(a, a, pi/2)` is an exchange rotation by `a - pi/2`; the "2 ns
  hardware-aligned solution" at `a = pi/2` is the identity. A target-specific two-CNOT synthesis reference
  (150 ns) is added next to the generic 215 ns one, and the runtime section is rewritten around the
  exchange angle and an exact mirror symmetry of the control problem.
- **Configuration.** Table I now records the two-stage training of both single-target agents and the real
  settings of the weight sweep.

## Verification

Every number in the text and tables was checked against the CSVs and run files named in
`uqc_repro/final_results/README.md`, which maps each figure and table to its data file, analysis script
and source run. The build is free of LaTeX errors, undefined references, undefined citations and overfull
boxes.

## Data provenance

All robustness data used here come from `uqc_repro/final_results/robustness_analysis_3/` and the other
directories listed in `../data/README.md`, and every plan evaluated for the single-target results targets
`N(2.2, 2.2, pi/2)`. `../data/robustness_analysis/`, which the thesis and slides still plot, is not used.
