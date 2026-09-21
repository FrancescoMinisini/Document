# Preprint source bundle

`preprint.tex` — *Robust analog two-qubit gates from deep reinforcement learning: an independent
reproduction and family-resolved assessment.* REVTeX 4.2, APS two-column preprint style, 16 pages.

## Build

```powershell
pdflatex preprint
bibtex   preprint
pdflatex preprint
pdflatex preprint
```

No `-shell-escape` is needed: unlike the thesis, this document contains no live TikZ and no
externalization. All figures are pre-rendered PDFs in `figures/`.

## Authorship

The paper is set with the thesis author as sole author and both supervisors thanked in the
acknowledgments, which is the usual convention for a preprint drawn from a bachelor's thesis. If they
should instead appear as co-authors, add `\author{...}` / `\affiliation{...}` blocks after the
existing one and trim the first sentence of the acknowledgments.

## Figures

Six figures are reused unchanged from the thesis. Three were rebuilt for this paper; their pgfplots
sources are in `figsrc/` and read the CSVs under `../../data/` directly.

| File | Source | Notes |
| --- | --- | --- |
| `robustness_v2.pdf` | `figsrc/fig_robustness.tex` | Rebuilt. Two panels with (a)/(b) labels, a `sigma_train` marker, and the canonical robustness data (see below). |
| `runtime_vs_alpha_v2.pdf` | `figsrc/fig_runtime.tex` | Rebuilt. Adds (a)/(b)/(c) labels and the `T_syn = 215 ns` gate-synthesis reference line; axis label corrected. |
| `single_target_comparison_v2.pdf` | `figsrc/fig_single_target.tex` | Rebuilt from scratch. Replaces `single_target_adam_vs_nominal_trpo.pdf`, which was unusable: it plotted the 60 ns Adam solution while the surrounding text discusses the 70 ns one (so the bars showed TRPO winning on cost and fidelity, the opposite of the caption), labelled both bars "Adam", and rendered the log-scale leakage panel with inverted bars annotated with log-values. The replacement shows all three controllers with the values of Table III. |

Rebuild any of them with `pdflatex fig_<name>` from inside `figsrc/`, then copy the resulting PDF into
`figures/`.

## Verification

Every numerical value in the text, in Tables II–V and in the rebuilt figures was checked against the
source CSVs and run summaries. All figures are cited in the text, all `\ref`s resolve, and all
citations resolve to `references.bib`. The build is free of LaTeX errors, undefined references and
overfull boxes above 2 pt.

## Data provenance

The robustness figure and Table IV are built from `../data/robustness_analysis/combined_ewma_data.csv`,
which holds the unmodified Monte Carlo outputs taken from
`uqc_repro/final_results/robustness_analysis/` (subdirectories `noise`, `nominal`, `adam_noise`) and is
reproduced byte-for-byte by `uqc_repro/analysis/export_ewma_data.py`. The thesis uses the same file,
so the two documents are consistent. See `../data/robustness_analysis/README.md` for its history.

The runtime sweep, the architecture sweep and the UFO-weight sweep were checked as well; their analysis
scripts only read and aggregate the simulation outputs.
