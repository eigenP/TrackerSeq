import subprocess
import os
import pytest

def test_run_pipeline():
    """
    Runs the run_pipeline.sh script and asserts it completes successfully.
    """
    # Ensure run_pipeline.sh exists
    assert os.path.exists("run_pipeline.sh"), "run_pipeline.sh not found in the root directory"

    # Run the pipeline script
    # capture_output=True allows us to see stdout/stderr if needed, but for now we just check returncode
    result = subprocess.run(["bash", "run_pipeline.sh"], capture_output=True, text=True)

    # Check if the script failed
    if result.returncode != 0:
        print("Pipeline stdout:", result.stdout)
        print("Pipeline stderr:", result.stderr)

    assert result.returncode == 0, f"run_pipeline.sh failed with exit code {result.returncode}"
