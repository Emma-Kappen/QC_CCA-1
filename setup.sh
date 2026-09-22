#!/usr/bin/env bash
# One-shot venv setup for macOS / Linux.  Usage:  bash setup.sh
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Creating virtual environment in .venv"
python3 -m venv .venv

echo "==> Upgrading pip"
./.venv/bin/python -m pip install --upgrade pip

echo "==> Installing requirements (this pulls ~400MB and takes a few minutes)"
./.venv/bin/python -m pip install -r requirements.txt

echo
echo "==> Verifying install"
./.venv/bin/python - <<'PY'
import qiskit, qiskit_aer, qiskit_machine_learning, sklearn, numpy
print("  qiskit                 ", qiskit.__version__)
print("  qiskit-aer             ", qiskit_aer.__version__)
print("  qiskit-machine-learning", qiskit_machine_learning.__version__)
print("  scikit-learn           ", sklearn.__version__)
print("  numpy                  ", numpy.__version__)
PY

echo
echo "Done. Next:"
echo "  1. Open THIS FOLDER in VS Code (File > Open Folder)."
echo "  2. Open quantum_vs_classical_kernels.ipynb"
echo "  3. Kernel picker (top right) > Select Another Kernel... > Python Environments..."
echo "     > choose the interpreter under .venv"
echo "  4. Run All."