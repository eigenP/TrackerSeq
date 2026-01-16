import subprocess
import os
import pytest

def test_run_pipeline():
    """
    Runs the demo/run_pipeline.sh script and asserts it completes successfully.
    """
    # Ensure run_pipeline.sh exists
    script_path = os.path.join("demo", "run_pipeline.sh")
    assert os.path.exists(script_path), f"{script_path} not found"

    # Run the pipeline script
    # capture_output=True allows us to see stdout/stderr if needed, but for now we just check returncode
    result = subprocess.run(["bash", script_path], capture_output=True, text=True)

    # Check if the script failed
    if result.returncode != 0:
        print("Pipeline stdout:", result.stdout)
        print("Pipeline stderr:", result.stderr)

    assert result.returncode == 0, f"{script_path} failed with exit code {result.returncode}"
