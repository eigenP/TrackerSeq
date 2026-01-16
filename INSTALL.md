# Installation Instructions

This project uses `conda` (or `mamba`) to manage dependencies. `environment.yml` is the single source of truth for the environment configuration.

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
- `bartender`
- `umi_tools`

Note: The pipeline scripts are designed to detect the installed tools automatically.

## Running Tests

To run the pipeline tests:
```bash
pytest -v
```
