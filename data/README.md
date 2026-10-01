# data

CSVs plotted by the thesis (`plots/*.tex`), the slides (`presentation/images/*.tex`) and the preprint
(`paper/figsrc/*.tex`). Every file is a byte-identical copy of a file in the companion repository's
`final_results/` folder, written by the script named below; `final_results/README.md` there maps each
figure to its data file and source run.

## Used by the thesis and the slides

| Directory | Written by (`uqc_repro/`) |
| --- | --- |
| `adam/`, `adam_vs_nominal_results/` | `analysis/generate_adam_plots.py`, `analysis/generate_comparison_plots.py` |
| `cost_function_sweep_results/` | `analysis/analyze_cost_sweep.py` |
| `nn_size_sweep_results/` | `analysis/analyze_nn_size_sweep.py` |
| `robustness_analysis/` | `analysis/export_ewma_data.py`; its `noise` columns belong to a plan for `N(0, 0, pi/2)`, see its README |
| `runtime_results/` | `analysis/analyze_runtime.py` |
| `trpo_nominal_results/` | `analysis/generate_nominal_trpo_plots.py` |

## Added for the preprint (2026-09-22)

All plans evaluated here target `N(2.2, 2.2, pi/2)` unless the directory is about the family sweep.

| Directory | Content | Written by (`uqc_repro/`) |
| --- | --- | --- |
| `robustness_analysis_3/` | dense-grid robustness curves (raw and EWMA) of the two Adam plans (60 and 70 ns), the nominal TRPO plan and the two noise-trained TRPO candidates; representative values and crossovers | `benchmark_robustness.py`, `analysis/export_ewma_data.py`, `analysis/summarize_robustness_3.py` |
| `trajectory_robustness_results/` | robustness of every per-iteration plan (iterations 1–100) of the matched nominal and noise-trained TRPO runs, with summary statistics and bootstrap intervals | `analysis/robustness_training_trajectories.py` |
| `closed_loop_results/` | the same checkpoints acting in closed loop on the noisy propagator versus their open-loop plans | `analysis/closed_loop_vs_open_loop.py` |
| `white_noise_results/` | first-order infidelity rate of the white-noise model and the measured excess infidelity of every plan | `analysis/white_noise_first_order.py` |
| `noisy_leakage_results/` | UFO cost terms, leakage bound and leakage population under the training noise | `analysis/analyze_noisy_leakage.py` |
| `gate_structure_results/` | exchange angle, Weyl coordinate, CNOT count and synthesis times of `N(a, a, pi/2)` merged with both runtime sweeps; curriculum plans mirrored onto `pi - alpha` | `analysis/analyze_gate_structure.py`, `analysis/analyze_mirror_symmetry.py` |
