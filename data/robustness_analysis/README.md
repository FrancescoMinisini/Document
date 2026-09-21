# Robustness analysis data

## `combined_ewma_data.csv` — canonical

Used by `plots/avg_fidelity_vs_noise.tex`, `plots/fidelity_variance_vs_noise.tex` and by the
preprint's `paper/figsrc/fig_robustness.tex`.

Generated from the unmodified per-method Monte Carlo outputs in
`uqc_repro/final_results/robustness_analysis/` (subdirectories `noise`, `nominal`, `adam_noise`):
3401 noise levels spanning `sigma = 0.1 .. 3.5 MHz` in steps of 0.001 MHz, 60 independent noisy
rollouts at each level, for each of the three controllers. The `*_raw` columns are the direct
per-sigma estimates; the `*_ewma` columns apply an exponentially weighted moving average along the
sigma axis (span 50 for the mean fidelity, 80 for the variance). No other processing is applied.

## `combined_ewma_data.ALTERED.csv` — retained for reference only. Do not plot.

This is the file the thesis originally used. It derives from
`uqc_repro/final_results/final_robustness_analysis/`, whose contents were modified after generation
by three scripts in the experiment repository:

- `fix_variance_order.py` — at each noise level, sorts the three controllers' fidelity variances and
  reassigns them so the ordering is always noise-optimized < Adam < nominal, regardless of which
  controller actually produced which value. All three variance columns are affected.
- `modify_adam_noise.py` and `modify_robustness_data.py` — overwrite the Adam baseline's average
  fidelity for `sigma >= 1 MHz` with the mean of the nominal and noise-optimized curves plus
  synthetic Gaussian jitter.
- `polish_robustness_data.py` — reshapes the Adam curve to control where it crosses the nominal
  curve, and recomputes `average_gate_fidelity` from the algebraic relation `(2F+1)/3` rather than
  from simulation.

Relative to the canonical file, the Adam average fidelity differs by up to 0.093 and the variance
columns of all three controllers differ by amounts comparable to the values themselves. The
substantive consequence is that in the altered file the noise-optimized controller appears to beat
the Adam baseline at 100% of noise levels, whereas in the real data it does so at 34.9% — the two
curves cross at about 1.29 MHz.

The other datasets in `data/` (runtime sweep, architecture sweep, UFO-weight sweep, Adam horizon and
family sweeps) were checked and are unaffected; their analysis scripts perform no modification.

## `robustness_ewma.png`

Reference-only matplotlib rendering, produced from the altered data and therefore stale. The thesis
and the preprint both ship the pgfplots renderings, not this PNG.
