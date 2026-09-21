# Reinforcement-Learning Framework for Robust and Universal Analog Quantum Control on Superconducting Qubits

LaTeX sources of the bachelor's thesis in physics by Francesco Giuseppe Minisini (University of Milan,
Department of Physics, academic year 2025/2026), together with the defense slides, a plain-language
summary and a preprint drawn from the thesis. The work is an independent reproduction and extension of
Niu, Boixo, Smelyanskiy and Neven, *Universal quantum control through deep reinforcement learning*,
npj Quantum Information **5**, 33 (2019).

The simulation code and the full experiment data are in the companion repository
[RL-for-Universal-Analog-Quantum-Control](https://github.com/FrancescoMinisini/RL-for-Universal-Analog-Quantum-Control).

## Contents

| Path | Content |
| --- | --- |
| `Tesi.tex`, `chapters/`, `references.bib` | the thesis; `Tesi.pdf` is the current build |
| `Thesis_Francesco_Giuseppe_Minisini_final.pdf` | the version submitted for the degree (see [Data](#data)) |
| `plots/` | pgfplots sources of the data figures |
| `chapters/plots/` | the rendered figures included by the thesis |
| `data/` | the CSVs plotted by the figures |
| `presentation/` | beamer defense slides (`Presentation.pdf`) and speaker notes |
| `Summary/summary.tex` | a two-page plain-language summary |
| `paper/` | the preprint *Robust analog two-qubit gates from deep reinforcement learning: an independent reproduction and family-resolved assessment* (REVTeX; see [`paper/README.md`](paper/README.md)) |

## Building

The documents use MiKTeX or TeX Live with `latexmk`.

```bash
latexmk                                                   # thesis, from the repository root (reads .latexmkrc)
cd presentation && latexmk -pdf -shell-escape Presentation.tex
cd Summary && latexmk -pdf -outdir=out summary.tex
cd paper && pdflatex preprint && bibtex preprint && pdflatex preprint && pdflatex preprint
```

`.latexmkrc` writes the thesis build to `out/` and runs `pdflatex -shell-escape`, which TikZ
externalization requires. Its last step copies `out/Tesi.pdf` to the root with a Windows `copy`
command. On Linux or macOS, copy the file by hand.

Data figures are not compiled at build time. Each figure's pgfplots source is kept next to its
`\includegraphics` as a comment, and the pre-rendered PDF is what gets included. To change a figure,
compile its source from `plots/` (for example with `plots/_standalone_wrapper.tex`) and replace the PDF.

## Data

Every CSV in `data/` is a byte-identical copy of a file in the companion repository's
`final_results/` folder, and the scripts in its `analysis/` folder regenerate each one byte-for-byte.
The companion repository's `final_results/README.md` maps each figure to its data and to the runs it
comes from.

The robustness figures use `data/robustness_analysis/combined_ewma_data.csv`, the unmodified Monte
Carlo evaluation. Before 2026-09-21 the thesis used a post-processed version of that dataset. The
submitted PDF `Thesis_Francesco_Giuseppe_Minisini_final.pdf` predates the correction, so its robustness
figures and the conclusions drawn from them differ from the current `Tesi.pdf`.
[`data/robustness_analysis/README.md`](data/robustness_analysis/README.md) documents the difference.

## Citation

See [`CITATION.cff`](CITATION.cff).

## License

Text, figures and data: [CC BY 4.0](LICENSE). The code that produced the data is MIT-licensed in the
companion repository.
