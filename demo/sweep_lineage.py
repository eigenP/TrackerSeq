import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import subprocess
import os

# Configuration
N_READS_VALUES = [1, 2, 3, 4, 5, 7, 10]
N_UMI_VALUES = [1, 2, 3, 4, 5, 7, 10]
SAMPLE_NAME = "test_sample"
OUTPUT_DIR = "output" # Relative to demo/
TRACKER_SEQ_DIR = "../TrackerSeq" # Relative to demo/
SCRIPT_NAME = "4.1_lineage_analysis.sh"

metrics_list = []

print("Starting sweep...")

for n_reads in N_READS_VALUES:
    for n_umi in N_UMI_VALUES:
        print(f"Running for n_reads={n_reads}, n_umi={n_umi}...")

        # Construct command
        # bash 4.1_lineage_analysis.sh <dir> <sample> <n_reads> <n_umi>
        # dir path must be relative to TrackerSeq directory since we run with cwd=TRACKER_SEQ_DIR
        # If we are in demo/, TrackerSeq is ../TrackerSeq.
        # From TrackerSeq/, demo/output is ../demo/output

        cmd = [
            "bash",
            SCRIPT_NAME,
            f"../demo/{OUTPUT_DIR}",
            SAMPLE_NAME,
            str(n_reads),
            str(n_umi)
        ]

        try:
            subprocess.run(cmd, cwd=TRACKER_SEQ_DIR, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error running pipeline for {n_reads}, {n_umi}: {e}")
            continue

        # Load results
        matrix_path = os.path.join(OUTPUT_DIR, f"{SAMPLE_NAME}_matrix_UMI5.csv")
        if not os.path.exists(matrix_path):
            print(f"Warning: Output file {matrix_path} not found.")
            continue

        try:
            # Clone matrix: rows=cells, cols=clones (barcodes)
            df = pd.read_csv(matrix_path, index_col=0)

            n_cells = df.shape[0]
            n_barcodes = df.shape[1]

            # Clone sizes (number of cells per clone)
            clone_sizes = df.sum(axis=0)

            avg_clone_size = clone_sizes.mean() if not clone_sizes.empty else 0
            max_clone_size = clone_sizes.max() if not clone_sizes.empty else 0
            median_clone_size = clone_sizes.median() if not clone_sizes.empty else 0
            n_multicell_clones = (clone_sizes > 1).sum()
            clone_size_variance = clone_sizes.var() if not clone_sizes.empty else 0

            metrics_list.append({
                "n_reads": n_reads,
                "n_umi": n_umi,
                "n_recovered_barcodes": n_barcodes,
                "n_retained_cells": n_cells,
                "avg_clone_size": avg_clone_size,
                "max_clone_size": max_clone_size,
                "median_clone_size": median_clone_size,
                "n_multicell_clones": n_multicell_clones,
                "clone_size_variance": clone_size_variance
            })

        except Exception as e:
            print(f"Error processing results for {n_reads}, {n_umi}: {e}")

# Save metrics
metrics_df = pd.DataFrame(metrics_list)
metrics_csv_path = os.path.join(OUTPUT_DIR, "sweep_metrics.csv")
metrics_df.to_csv(metrics_csv_path, index=False)
print(f"Metrics saved to {metrics_csv_path}")

# Plotting
if not metrics_df.empty:
    sns.set_theme(style="whitegrid")

    # Metrics to plot
    plot_metrics = [
        ("n_recovered_barcodes", "Number of Recovered Barcodes"),
        ("n_retained_cells", "Number of Retained Cells"),
        ("avg_clone_size", "Average Clone Size"),
        ("n_multicell_clones", "Number of Multicell Clones"),
        ("max_clone_size", "Max Clone Size"),
        ("clone_size_variance", "Clone Size Variance")
    ]

    n_plots = len(plot_metrics)
    n_cols = 3
    n_rows = (n_plots + n_cols - 1) // n_cols

    fig, axes = plt.subplots(n_rows, n_cols, figsize=(5 * n_cols, 4 * n_rows))
    axes = axes.flatten()

    for i, (metric, title) in enumerate(plot_metrics):
        if metric in metrics_df.columns:
            sns.lineplot(
                data=metrics_df,
                x="n_reads",
                y=metric,
                hue="n_umi",
                palette="viridis",
                marker="o",
                ax=axes[i]
            )
            axes[i].set_title(title)
            axes[i].set_ylabel(metric)
            # Remove legend from individual plots to avoid clutter, maybe keep on one
            if i != 0:
                axes[i].get_legend().remove()
        else:
            axes[i].axis('off')

    # Adjust layout
    plt.tight_layout()
    plot_path = os.path.join(OUTPUT_DIR, "sweep_results.png")
    plt.savefig(plot_path)
    print(f"Plots saved to {plot_path}")

else:
    print("No data gathered.")
