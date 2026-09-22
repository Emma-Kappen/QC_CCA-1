# One-shot venv setup for Windows.  Usage:  powershell -ExecutionPolicy Bypass -File setup.ps1
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "==> Creating virtual environment in .venv"
py -m venv .venv

Write-Host "==> Upgrading pip"
& .\.venv\Scripts\python.exe -m pip install --upgrade pip

Write-Host "==> Installing requirements (this pulls ~400MB and takes a few minutes)"
& .\.venv\Scripts\python.exe -m pip install -r requirements.txt

Write-Host ""
Write-Host "==> Verifying install"
& .\.venv\Scripts\python.exe -c "import qiskit, qiskit_aer, qiskit_machine_learning, sklearn, numpy; print('  qiskit                 ', qiskit.__version__); print('  qiskit-aer             ', qiskit_aer.__version__); print('  qiskit-machine-learning', qiskit_machine_learning.__version__); print('  scikit-learn           ', sklearn.__version__); print('  numpy                  ', numpy.__version__)"

Write-Host ""
Write-Host "Done. Next:"
Write-Host "  1. Open THIS FOLDER in VS Code (File > Open Folder)."
Write-Host "  2. Open quantum_vs_classical_kernels.ipynb"
Write-Host "  3. Kernel picker (top right) > Select Another Kernel... > Python Environments..."
Write-Host "     > choose the interpreter under .venv"
Write-Host "  4. Run All."