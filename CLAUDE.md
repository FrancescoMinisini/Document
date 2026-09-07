# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A LaTeX bachelor's thesis in physics (Reinforcement-Learning framework for robust analog quantum control on superconducting qubits), plus two independent LaTeX documents built from the same figure/data pool:

- `Tesi.tex` — the thesis (`report` class), the main document.
- `presentation/Presentation.tex` — beamer defense slides.
- `Summary/summary.tex` — a standalone plain-language summary (`article`, self-contained, no shared assets).

There is no application code here; the simulation code that produced `data/` lives in a separate repository. Only its outputs (CSV/PNG) are checked in.

## Build

Toolchain is MiKTeX + `latexmk` on Windows.

```powershell
# Thesis — run from the repo root; picks up ./.latexmkrc
latexmk

# Force a full rebuild after changing figures/bibliography
latexmk -g

# Slides / summary — .latexmkrc is NOT read outside the root, so pass flags explicitly
cd presentation; latexmk -pdf -shell-escape -outdir=out Presentation.tex
cd Summary;      latexmk -pdf -outdir=out summary.tex
```

`.latexmkrc` sets `$out_dir = 'out'`, `$bibtex_use = 1`, and `pdflatex -shell-escape`, then copies `out/Tesi.pdf` to the repo root as `Tesi.pdf` via `$success_cmd = 'copy /Y ...'` — **cmd.exe syntax**, so invoke `latexmk` from PowerShell/cmd. Under the Bash tool that `copy` step fails and `Tesi.pdf` at the root silently goes stale; copy it manually if you build from Bash.

`-shell-escape` is mandatory: both `Tesi.tex` and `Presentation.tex` use `\tikzexternalize[prefix=out/]`, which shells out to compile each TikZ picture into `out/Tesi-figureN.pdf`.

### TikZ externalization gotchas

Externalized figures are cached by MD5 in `out/out/Tesi-figureN.md5`. If a picture renders stale or the build dies with an `auxlock`/figure error, delete the cache and rebuild:

```powershell
Remove-Item out\Tesi-figure*.*, out\out\*.md5, out\Tesi.auxlock
```

`out/` is gitignored; a broken state there is always safe to wipe.

## Figure workflow (the main convention to respect)

Figures are **not** compiled from source at build time. Each figure's TikZ/pgfplots source is kept in the repo but commented out, and a pre-rendered PDF is included instead:

```latex
\begin{figure}[t]
\centering
\includegraphics[width=\textwidth]{chapters/plots/control_dynamics_pipeline.pdf}
% \begin{tikzpicture}[...]   <- the real source, left commented in place
% ...
```

Two source locations:

- **Inline diagrams** (schematics, pipelines) — commented `tikzpicture` blocks directly inside `chapters/*.tex`.
- **Data plots** — separate files in `plots/*.tex`, referenced by a commented `\input{plots/<name>.tex}` next to the `\includegraphics`.

The rendered PDFs live in `chapters/plots/` (thesis) and `presentation/images/` (slides) and **are committed**.

To change a figure: uncomment the source, build, take the resulting PDF (from the externalization output or by wrapping the source in a `standalone` document — see the leftover `plots/*_standalone.log`), write it to `chapters/plots/<name>.pdf`, then re-comment the source. Keep the commented source in sync with the shipped PDF; it is the only record of how the figure was drawn.

### Data paths are relative to the compiling document

`plots/*.tex` address CSVs as `data/<dir>/<file>.csv` — valid only when `\input` from `Tesi.tex` at the repo root. The slide copies in `presentation/images/*.tex` use `../data/...` instead. When copying a plot between the two documents, fix this prefix.

## Document structure

`Tesi.tex` holds the whole preamble and title page and `\include`s, in order:

| File | Content |
| --- | --- |
| `chapters/01_introduction.tex` | motivation, thesis objectives |
| `chapters/02_background.tex` | quantum control, fidelity metrics, leakage, robustness, RL basics (largest chapter) |
| `chapters/03_implementation.tex` | gmon model, TSWT leakage bound, UFO cost function, TRPO formulation, baselines |
| `chapters/04_empirical_assessment.tex` | protocol, parameter sweeps, single-target results, robustness under noise, runtime |
| `chapters/05_conclusion.tex` | conclusion |
| `chapters/appendix.tex` | three `\chapter`s after `\appendix`: TSWT leakage-bound derivation, three-level rotating-frame Hamiltonian, algorithmic details |

Cross-reference label prefixes are used consistently and cited via `\eqref`/`\ref`: `eq:`, `subsec:`, `fig:`, `app:`, `alg:`, `tab:`, `sec:`. Bibliography is BibTeX (`references.bib`, `plain` style, `\cite`) — no biblatex.

`chapters/04_empirical_assessment.tex` contains several fully commented-out earlier versions of result subsections (superseded orderings, alternative figure blocks). Check whether a block is live before editing it.

## Data

`data/<experiment>/` pairs the CSVs consumed by `plots/*.tex` with the matplotlib PNGs originally produced by the simulation code. The PNGs are reference only — the thesis ships the pgfplots renderings, not the PNGs. Experiment directories: `adam`, `adam_vs_nominal_results`, `cost_function_sweep_results`, `nn_size_sweep_results`, `robustness_analysis`, `runtime_results`, `trpo_nominal_results`.

## Misc

- `codeexport.config.psd1` configures an external (not-in-repo) PowerShell exporter that concatenates `Tesi.tex` + `chapters/**/*.tex` into `exported_cb/codebase.txt` for pasting into an LLM. `exported_cb/` is gitignored and can be regenerated or ignored.
- `Tesi.pdf` (root) and `Thesis_Francesco_Giuseppe_Minisini_final.pdf` (the submitted snapshot) are both committed; the root `Tesi.pdf` is the build output and is expected to be refreshed alongside source changes.
- Commit messages in this repo are in Italian; the thesis text is in English.
