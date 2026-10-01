# Robustness analysis data

> **Warning.** The `noise_*` columns come from the plan in `uqc_repro/final_results/noise/`, which
> targets `N(0, 0, pi/2)` (the alpha = 0 phase of the curriculum sweep) and is scored against that
> target, not against `N(2.2, 2.2, pi/2)`. Comparisons between the `noise` columns and the other two
> are therefore not valid. This file is kept because the thesis and the slides plot it. The preprint
> uses `data/robustness_analysis_3/` instead, where every plan targets `N(2.2, 2.2, pi/2)`.

## `combined_ewma_data.csv`

Used by `plots/avg_fidelity_vs_noise.tex`, `plots/fidelity_variance_vs_noise.tex` and the slide copies in
`presentation/images/`. Until 2026-09-22 the preprint's `paper/figsrc/fig_robustness.tex` used it too.

Built from the unmodified per-method Monte Carlo outputs of `benchmark_robustness.py` in
`uqc_repro/final_results/robustness_analysis/` (subdirectories `noise`, `nominal`, `adam_noise`):
3401 noise levels spanning `sigma = 0.1 .. 3.5 MHz` in steps of 0.001 MHz, 60 independent noisy
rollouts at each level, for each of the three controllers. The `*_raw` columns are the direct
per-sigma estimates; the `*_ewma` columns apply an exponentially weighted moving average along the
sigma axis (span 50 for the mean fidelity, 80 for the variance). No other processing is applied.

Regenerate it with `python analysis/export_ewma_data.py` in `uqc_repro`, which writes
`final_results/robustness_analysis/combined_ewma_data.csv`; the output is byte-identical to this file.

## `robustness_comparison.png`

Reference-only matplotlib rendering of the same raw curves, written by `benchmark_robustness.py --plot`.
The thesis, the slides and the preprint ship the pgfplots renderings, not this PNG.

## History

Until 2026-09-21 (commit `363c808`) the thesis used a version of this dataset whose Adam and variance
columns had been post-processed after simulation. That version, the scripts that produced it and the
affected result directories were taken out of version control on 2026-09-21. They are kept on disk in
the gitignored `archive/` folders of both repositories and remain in the git history. `Thesis_Francesco_Giuseppe_Minisini_final.pdf` predates the correction and still
shows the earlier robustness figures.
