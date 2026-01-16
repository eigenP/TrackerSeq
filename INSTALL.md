# Installation Instructions

This project uses `conda` (or `mamba`) to manage dependencies, use `environment.yml` for the environment configuration.

## Prerequisites

- [Conda](https://docs.conda.io/en/latest/) or [Mamba](https://mamba.readthedocs.io/en/latest/) installed.

## Setting up the Environment

1.  Clone the repository:
    ```bash
    git clone <repository_url>
    cd <repository_directory>
    ```

2.  Create the Conda environment:
    ```bash
    conda env create -f environment.yml
    ```
    Or with Mamba (faster):
    ```bash
    mamba env create -f environment.yml
    ```

3.  Activate the environment:
    ```bash
    conda activate ci-env
    ```

## External Tools

The environment includes the following bioinformatics tools:
- `samtools`
- `bbmap` (provides `bbduk.sh`, `repair.sh`, etc.)
- `umi_tools`

### Installing Bartender 1.1 (Manual Step)

`bartender` is not available in the Conda channels and must be installed manually:

1.  Clone the repository:
    ```bash
    git clone https://github.com/LaoZZZZZ/bartender-1.1.git
    cd bartender-1.1
    ```

2.  Compile:
    ```bash
    make
    ```

3.  Install binaries to your PATH (e.g., `/usr/local/bin` or your Conda environment's bin):
    ```bash
    # System-wide (requires sudo)
    sudo cp bartender_single* /usr/local/bin/

    # Or, to your active Conda environment
    cp bartender_single* $CONDA_PREFIX/bin/
    ```

4.  Verify installation:
    ```bash
    bartender_single_com --help
    ```

Note: The pipeline scripts are designed to detect the installed tools automatically.

## Running Tests

To run the pipeline tests:
```bash
pytest -v
```
