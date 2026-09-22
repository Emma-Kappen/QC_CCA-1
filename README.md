# Quantum vs. Classical Kernels — local VS Code setup

A 3-way kernel comparison (RBF, polynomial, simulated quantum)
converted from Google Colab to run locally in VS Code inside a virtual environment.

## 1. Create the venv

From this folder, in a terminal.

**macOS / Linux**

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

**Windows (PowerShell)**

```powershell
py -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
```

If PowerShell blocks the activate script, run
`Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` first — it applies to that
terminal session only.

Requires **Python 3.9–3.13**. Check with `python3 --version`. Installation pulls about
400 MB and takes a few minutes.

## 2. Point VS Code at the venv

1. Install the **Python** and **Jupyter** extensions if you don't already have them.
2. Open this folder in VS Code (`File → Open Folder`, not a single file — the notebook's
   relative paths depend on it).
3. Open `quantum_vs_classical_kernels.ipynb`.
4. Click the **kernel picker** in the top-right of the notebook →
   **Select Another Kernel… → Python Environments…** → pick the interpreter whose path
   contains `.venv`.

If `.venv` doesn't show up in the list, run **Developer: Reload Window** from the command
palette (`Ctrl/Cmd+Shift+P`) and try again.

**Cell 1 of the notebook verifies this for you** — it prints the interpreter path and warns
loudly if you are not on a venv. Run it first.

## 3. Run

`Run All`, or work down cell by cell. On a typical laptop the whole notebook takes
**1–3 minutes**, essentially all of it in the Section 4 quantum kernel cell.

The notebook uses only the local Aer simulator. It does not authenticate with IBM Quantum
or submit real QPU jobs.

## Choosing the dataset

In the first code cell of Section 1:

```python
DATASET = "breast_cancer"   # or "iris"
N_QUBITS = 4
```

| Value | Data | Samples | Features | Classes |
|---|---|---|---|---|
| `"breast_cancer"` | Breast Cancer Wisconsin (Diagnostic) | 569 | 30 → PCA to `N_QUBITS` | malignant / benign |
| `"iris"` | Fisher's Iris | 100 used | 4 (no PCA) | versicolor / virginica |

Both load from `sklearn.datasets`, so there is no download and the notebook works offline.

Breast cancer gets PCA because one qubit is used per feature — 30 raw features would mean a
30-qubit circuit. Iris is reduced to the versicolor/virginica pair because kernel-target
alignment is defined for binary labels, and because setosa is linearly separable from both
others (any setosa pair scores ~100% for every kernel, which makes the comparison useless).

## Runtime knobs

`SUBSAMPLE_SIZE` in Section 1 drives everything, because quantum kernel cost is *O(N²)*
fidelity circuits:

| `SUBSAMPLE_SIZE` | Train points | Circuits | Section 4 time (CPU) |
|---|---|---|---|
| 50 | 35 | ~1,100 | a few seconds |
| 100 (default) | 70 | ~4,500 | ~40 s |
| 200 | 140 | ~18,000 | several minutes |

## What changed from the Colab version

| Colab | Here |
|---|---|
| `%pip install` cell, then "restart runtime and re-run from the top" | `requirements.txt` installed once into `.venv` before opening the notebook |
| `qiskit-aer-gpu-cu11`, assumed a T4 | CPU `qiskit-aer`; GPU tried first and falls back automatically |
| Banknote via `ucimlrepo` (network fetch) | `sklearn.datasets` breast cancer / iris, offline |
| — | StandardScaler + PCA for breast cancer, fit on train only |
| `ZZFeatureMap` class + `.decompose()` | `zz_feature_map()` function (the class is deprecated); falls back to the old form on older Qiskit |
| Real-hardware comparison and IBM authentication | Removed; the project comparison now contains the three local kernels only |
| `polynomial_kernel()` rebuilt with a different `gamma` than the grid search scored | `gamma` passed explicitly so the rebuilt Gram matrix matches |
| Test points could scale outside `[0, π]` | clipped after transform |
| Colab-specific instructions ("Runtime → Change runtime type → T4") | VS Code kernel-selection instructions + a venv verification cell |

## Troubleshooting

**`ModuleNotFoundError: No module named 'qiskit'`** — the notebook kernel isn't the venv.
Redo step 2. Cell 1 will confirm.

**No `.venv` option in the kernel picker** — make sure you opened the *folder*, then
`Developer: Reload Window`.

**`AerError: unknown instruction: ZZFeatureMap`** — only happens on old Qiskit taking the
legacy fallback path; `pip install -U qiskit` fixes it.

**Section 4 is slow** — expected; it's `N*(N-1)/2` circuit simulations. Lower
`SUBSAMPLE_SIZE`.

**Plots don't show** — confirm `ipykernel` installed in the venv and that the first code
cell ran (it sets `%matplotlib inline`).