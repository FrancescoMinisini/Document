# Preprint source bundle

`preprint.tex` — *Robust analog two-qubit gates from deep reinforcement learning: an independent
reproduction and family-resolved assessment.* REVTeX 4.2, APS two-column preprint style, 16 pages.
`supplement.tex` is its Supplemental Material (5 pages): derivation of the leakage bound, algorithmic
details, complete configuration, parameter sweeps, horizon and family sweeps of the direct optimizer,
relation to hardware.

## Build

```powershell
pdflatex preprint
bibtex   preprint
pdflatex preprint
pdflatex preprint
pdflatex supplement
bibtex   supplement
pdflatex supplement
pdflatex supplement
```

Build the main text first: the supplement reads `preprint.aux` (package `xr-hyper`, prefix `M-`) to quote
the main text's equation, table and section numbers. The main text cites the supplement as reference
`supp` and names its sections by hand (S1 to S7), so if the order of the supplement's sections changes,
update those mentions in `preprint.tex`.

No `-shell-escape` is needed: unlike the thesis, these documents contain no live TikZ and no
externalization. All figures are pre-rendered PDFs in `figures/`. `references.bib` here is the thesis
bibliography plus the entries used only by the preprint (Zhang2003, Makhlin2002, VidalDawson2004,
ShendeMarkovBullock2004, Foxen2020, Green2012, Green2013, Cerfontaine2021, KhodjastehViola2009, Wu2019,
Paladino2014, Abad2022, Arute2019, Sung2021, GoogleQAI2025, and `supp` for the Supplemental Material).

## Terminology

The text uses one name for each thing. The two RL agents are the *noise-free* agent (trained in the
deterministic environment; `final_results/nominal/` in the code repository) and the *noise-trained* agent
(trained under noise; "noise-optimized" in Niu et al. and in the thesis). The gradient method is the
*direct optimizer* (Adam is named once, in the methods). What a method produces is a *pulse* (a "control
plan" in the code). "Nominal" is kept only for quantities evaluated without noise (nominal fidelity,
nominal cost). TRPO is named only where the algorithm itself is meant.

## Authorship

Three authors since 2026-10-09: the thesis author and both supervisors. The acknowledgments and the Data
availability section are commented out in `preprint.tex`; whether they come back is the author's decision
(the text still mentions "the released data" in the evaluation protocol).

## Figures

The main text has four figures, all built for this paper; their pgfplots sources are in `figsrc/` and read
the CSVs under `../data/` directly. Legends sit outside the plot area or in an empty corner, so that they
cover no data.

| File | Source | Content |
| --- | --- | --- |
| `robustness_v3.pdf` | `figsrc/fig_robustness.tex` | Fig. 1: average fidelity and variance versus noise strength for the three pulses of Table I and the 60 ns pulse of the direct optimizer, from `data/robustness_analysis_3/`. |
| `noise_training_mechanism.pdf` | `figsrc/fig_mechanism.tex` | Fig. 2: (a) excess infidelity versus duration with the first-order prediction, (b) matched-pair paired differences, (c) closed versus open loop. |
| `noise_with_memory.pdf` | `figsrc/fig_memory.tex` | Fig. 3: filter functions of three 70 ns pulses of the direct optimizer, excess infidelity against the noise correlation time, quasi-static excess infidelity against duration for all pulses. |
| `runtime_vs_alpha_v4.pdf` | `figsrc/fig_runtime.tex` | Fig. 4: runtime, fidelity and leakage across `N(a, a, pi/2)` for the RL curriculum and the direct optimizer, with both synthesis references and the bandwidth-limited exchange time (grey band). |

The supplement reuses four figures unchanged from the thesis (`adam_single_target_horizon_sweep`,
`adam_family_sweep`, `architecture_sweep_pareto_combined`, `ufo_weight_sweep_robustness`); their labels
still say "Adam" and "TRPO".

Rebuild a figure with `pdflatex fig_<name>` from inside `figsrc/`, then copy the resulting PDF into
`figures/` under the name above. The `*_v2.pdf` files in `figures/` belong to the version of 2026-09-07
and are no longer included; `runtime_vs_alpha_v3.pdf` is the version of 2026-09-22;
`gmon_architecture_schematic.pdf`, `ufo_cost_structure.pdf` and `single_target_comparison_v3.pdf`
(source `figsrc/fig_single_target.tex`) were dropped on 2026-10-08. Figure and table numbers above are
those of the current version.

## Changes of 2026-10-09

A second readability pass: 21 pages to 16, plus a 5-page supplement; about 15 000 to 11 700 words of
source in the main text. No result, dataset or number was changed.

- **Consistency pass after the audit of the same day.** The caveat that the noise scale differs from the
  original's (coarser time step, sixteen times more infidelity at equal sigma) is now stated in the noise
  model section and in the abstract, and the Discussion and Appendix C no longer repeat each other; the
  factor sixteen against a step ratio of twenty is explained. The abstract and the conclusion no longer
  count "three" unsupported claims (Table V lists them). Stale cross-references in the Limitations and in
  the supplement were fixed, and the fifth evaluated pulse (104 ns) is named where it is used.
- **One story in the main text.** Everything that is specific to this implementation or secondary moved
  out: the domination of the noisy objective by the leakage bound and its time-step scaling (new
  Appendix B), the details of the noise-scale comparison (new Appendix C), and to the supplement the TSWT
  derivation, the algorithmic details, the configuration table, the parameter sweeps, the horizon sweep of
  the direct optimizer, the per-target curriculum table, the family-sweep figure and four of the five
  hardware remarks in full.
- **Fewer parallel tracks.** The single-target section is one table and three paragraphs, with one pulse
  per method (the 60 ns pulse of the direct optimizer appears only in the robustness section, and the
  iteration-91 pulse in a footnote). The first matched pair and the three retrained pairs are presented
  together as four pairs (Table III). The rows with the leakage bound taken from the noise-free controls
  left Table IV and are summarized in Appendix B.
- **Runtime section.** Five subsections became four; the comparison with synthesis and with the direct
  optimizer is one subsection.
- **Names.** See Terminology above. Table and figure labels were changed to match.
- **Figures.** Legends were moved off the data in all four figures. In `noise_with_memory` panel (c) the
  old legend hid the points at 100 and 130 ns. The panels of `noise_training_mechanism` were reordered so
  that they are cited in order. The robustness figure has one legend above both panels, and the runtime
  figure one legend above panel (a).

## Changes of 2026-10-08

A readability pass: 24 pages to 21, about 17 400 to 15 000 words of source. No result, dataset or number
was changed; section, figure, table and equation numbers quoted in the older entries below are those of
their own date.

- **Stated once.** The abstract is about 200 words (from 330); "What we find" has four short items; the Discussion
  opens with a claim-by-claim table (Table V) in place of "What reproduces" / "What does not"; the
  robustness "Interpretation" subsection is gone and the Conclusion is shorter.
- **Explanation first.** The white-noise result, Eq. (18), now opens the robustness section (Sec. V B)
  and the selected controllers, matched histories and direct-optimizer tests follow as checks of it. The
  structure of the `gamma = pi/2` subfamily moved from Sec. II to the start of the runtime section
  (Sec. VI A).
- **Tables and figures.** The configuration table (Table VII) and the per-target curriculum table
  (Table VIII) moved to Appendices D and E. The robustness table keeps three noise strengths, the
  three-seed table four rows, and the Adam noise-model table lost its constant white-noise column (the
  three values are in the text). The gmon and UFO schematics and the single-target bar chart were removed.
- **Shorter restatement of the original.** Sec. II is about half its length; the Adam horizon sweep,
  the hardware remarks, the limitations and Appendices B and F were tightened.

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
