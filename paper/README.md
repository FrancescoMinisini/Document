# Preprint source bundle

`preprint.tex` — *Robust analog two-qubit gates from deep reinforcement learning: an independent
reproduction and family-resolved assessment.* REVTeX 4.2, APS two-column preprint style, 23 pages.

## Build

```powershell
pdflatex preprint
bibtex   preprint
pdflatex preprint
pdflatex preprint
```

No `-shell-escape` is needed: unlike the thesis, this document contains no live TikZ and no
externalization. All figures are pre-rendered PDFs in `figures/`. `references.bib` here is the thesis
bibliography plus fifteen entries used only by the preprint (Zhang2003, Makhlin2002, VidalDawson2004,
ShendeMarkovBullock2004, Foxen2020, Green2012, Green2013, Cerfontaine2021, KhodjastehViola2009, Wu2019,
Paladino2014, Abad2022, Arute2019, Sung2021, GoogleQAI2025).

## Authorship

The paper is set with the thesis author as sole author and both supervisors thanked in the
acknowledgments, which is the usual convention for a preprint drawn from a bachelor's thesis. If they
should instead appear as co-authors, add `\author{...}` / `\affiliation{...}` blocks after the
existing one and trim the first sentence of the acknowledgments.

## Figures

Six figures are reused unchanged from the thesis (`gmon_architecture_schematic`, `ufo_cost_structure`,
`architecture_sweep_pareto_combined`, `ufo_weight_sweep_robustness`, `adam_single_target_horizon_sweep`,
`adam_family_sweep`). Five were built for this paper; their pgfplots sources are in `figsrc/` and read the
CSVs under `../data/` directly.

| File | Source | Content |
| --- | --- | --- |
| `single_target_comparison_v3.pdf` | `figsrc/fig_single_target.tex` | Fig. 4: nominal cost, fidelity, leakage and runtime of Adam (70 ns) and the two TRPO agents, with both synthesis references. Values typed from the nominal re-evaluation of the stored plans (listed in the source header). |
| `robustness_v3.pdf` | `figsrc/fig_robustness.tex` | Fig. 5: average fidelity and variance versus noise strength for the four controllers of Table II, from `data/robustness_analysis_3/`. |
| `noise_training_mechanism.pdf` | `figsrc/fig_mechanism.tex` | Fig. 6: matched-history paired differences, closed versus open loop, excess infidelity versus duration with the first-order prediction. |
| `noise_with_memory.pdf` | `figsrc/fig_memory.tex` | Fig. 7: filter functions of three 70 ns Adam pulses, excess infidelity against the noise correlation time, quasi-static excess infidelity against duration for all plans. |
| `runtime_vs_alpha_v4.pdf` | `figsrc/fig_runtime.tex` | Fig. 8: runtime, fidelity and leakage across `N(a, a, pi/2)` for the curriculum and the Adam sweep, with both synthesis references and the bandwidth-limited exchange time (grey band). |

Rebuild any of them with `pdflatex fig_<name>` from inside `figsrc/`, then copy the resulting PDF into
`figures/` under the name above. The `*_v2.pdf` files in `figures/` belong to the version of 2026-09-07
and are no longer included; `runtime_vs_alpha_v3.pdf` is the version of 2026-09-22. Figure and table
numbers above are those of the current version.

## Changes of 2026-10-01

Additions that use the stored runs, plus one new Adam experiment (minutes of CPU); no TRPO run was added.

- **Noise with memory (Sec. V E, Fig. 7, Table IV).** Every stored plan replayed under quasi-static and
  exponentially correlated noise, with the first-order (filter-function) prediction; Adam trained at fixed
  horizons without noise, under white noise and under quasi-static noise, eight seeds each. White-noise
  training helps in 0 of 24 runs; quasi-static training lowers the quasi-static sensitivity by 18-24%.
- **First-order formula (Appendix C).** Eq. (21) is now presented as the white-noise limit of the
  filter-function description, with the prior art cited, the exact per-plan rate and a per-channel table.
- **Noise scales (Sec. VII C).** Dependence of the rate on the noise interval, noise injected before the
  filter, and the equivalent dephasing time.
- **Bandwidth limit (Sec. VI E, Fig. 8).** Shortest time in which the filtered, bounded coupling delivers
  each target's exchange area; single-qubit rotation times under the same limit.
- **Structure.** The architecture and weight sweeps moved from Sec. IV to Appendix D, with a summary in
  Sec. III F; the simulator-step counts of the controllers are quoted in Sec. III C.
- **Relation to hardware (Sec. VII E).** Which noise is physical, what decoherence would cost and which
  coherence time the runtime weight encodes, the control bandwidth and gate times of real gmon-type
  processors, the conditional phase of the higher levels (it equals the residual infidelity of the
  noise-free Adam pulses to 1%), and experimental gate fidelities. Every hardware number was checked
  against its source.
- **Time step of the original (Secs. III B, VII C, VII D).** The published Niu et al. says its pulses have
  "around one thousand time steps"; the earlier text said the step was not stated. At 0.1 ns the same
  sigma costs 16 times less infidelity than at 2 ns, which accounts for the scale gap with their Fig. 4.
  The noisy leakage bound scales as dt^-4, so the paper now says that its domination of the noisy
  objective is a property of this implementation and may not apply to the original.
- **Why 2 ns, and the training noise (Secs. VII C, VII F).** The Limitations now say that the step was set
  by the computational budget and that no agent was trained at a finer one. Sec. VII C adds that the
  training noise of 1 MHz at 2 ns corresponds to about 4 MHz at 0.1 ns, above the range the original
  evaluates, and that no agent was trained at the matched weaker level.
- **Fidelities against the original (Secs. VII A, VII C).** The original's own numbers are now quoted:
  average fidelity 0.995-0.98 over 0.1-3.5 MHz against 0.9925-0.713 here, with the rescaling by the
  time-step factor (about 0.991 at 1 MHz, 0.975 at 3.5 MHz); and gate infidelity of order 1e-3 across the
  family against 0.8-1.8e-2 on the 13 converged targets here, with 7 of 21 not converging.
- **Adam with the leakage bound on the noise-free controls (Sec. V E, Table IV rows marked with an
  asterisk).** The 51 runs were repeated with that choice. White-noise training still helps in none of
  24 runs (48 of 48 over both variants); its cost in nominal fidelity is roughly halved. The
  quasi-static results do not change. The TRPO agent was not retrained with this choice.

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
