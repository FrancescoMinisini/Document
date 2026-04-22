## Slide 1 — Why this problem matters

“Let me start from the physical motivation.
In superconducting qubits, implementing high-quality two-qubit gates is not just a matter of reaching high logical fidelity. Real devices are multilevel, weakly anharmonic, and affected by control noise. So if we try to make gates faster, we often increase leakage outside the computational subspace.

This means that the control problem is intrinsically multi-objective. We do not want only accurate gates, but also low leakage, short runtime, and robustness against perturbations.
This is exactly why pulse-level analog quantum control is interesting: it lets us optimize the dynamics directly at the Hamiltonian level, instead of working only at the circuit-compilation level.”

## Slide 2 — Thesis objective and guiding question

“The thesis had a double goal.
The first goal was reconstructive: I wanted to rebuild as faithfully as possible the framework proposed by Niu and collaborators, including the multilevel gmon model, the UFO cost function, the reinforcement-learning formulation, and the stochastic training setting.

The second goal was critical assessment. So I did not want only to restate the paper, but to evaluate whether the framework is actually convincing from a physical and empirical point of view.
For this reason, I tested it in three directions: nominal single-target performance, robustness under stochastic control noise, and runtime across the gate family N(α,α,γ).

So the guiding question of the thesis became: can reinforcement learning provide a physically meaningful and robust strategy for universal analog quantum control on superconducting qubits?”

## Slide 3 — What I actually did: rebuilding the framework from scratch

“This slide is important because it highlights my actual contribution.
The original paper did not provide a usable public codebase, so this was not a simple reproduction in the sense of running existing scripts. I had to reconstruct the whole framework independently from scratch.

That means I implemented the multilevel gmon simulator, rebuilt the TSWT-based leakage estimator, implemented the UFO cost function, and developed the full TRPO actor–critic training loop together with the stochastic environment used for robustness learning. On top of that, I also implemented the Adam baseline, the curriculum-based experiments, and the evaluation pipeline for robustness and runtime.

So a significant part of the thesis was not only theoretical interpretation, but also rebuilding a nontrivial computational framework that combines quantum simulation, leakage analysis, and reinforcement learning.”

