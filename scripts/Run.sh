#!/bin/bash
#SBATCH --job-name=BioinformaticsTutorial-preprocessing  # Job name
#SBATCH --output=logs/BioinformaticsTutorial-preprocessing_%j.out    # Output file name
#SBATCH --error=logs/BioinformaticsTutorial-preprocessing_%j.err     # Error file name
#SBATCH --mail-type=END                              # Email when the job finishes
#SBATCH --mail-user=lhillary@ucdavis.edu        # Change this to your own email address
#SBATCH --nodes=1                                 # Total number of nodes requested
#SBATCH -t 3-10:00:00                           # Run time (hh:mm:ss) - 10 hours
#SBATCH --ntasks=1                              # Total number of tasks - 1 per node
#SBATCH --cpus-per-task=2                     # Total number of processors per task - 2 per node
#SBATCH --partition=high2                       # Partition to run in
#SBATCH --account=jbemersogrp                   # Account to run under

# This script manages the submission of the preprocessing section of the ViromeDataProcessing pipeline
# It is run as a sbatch script so that you don't have to run it interactively
# The pipeline is deliberately split into chunks as the user should check the outputs of each stage
# before proceeding to the next
# This is designed to prevent someone from running the whole pipline and then finding out there were
# issues with the raw/ intermediate data
 

# Source the bashrc file
source ~/.bashrc

# Move into the directory that you want to run the pipeline from
cd Virome

# Activate the conda environment
micromamba activate ViromeDataProcessing

# Run the pipeline
snakemake --snakefile ../scripts/Parent.smk --profile slurm
