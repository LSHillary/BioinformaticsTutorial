import os
import yaml
import glob
from collections import defaultdict

#### SET UP ####

# This is the master snakefile that will call all the other snakefiles

# Load the configuration file which will be supplied as argument when running Snakemake
configfile: "TutorialConfig.yml"

# Load samples from the file specified in the configuration
# Note that this script assumes that samples are named according to the following convention:
# 0-raw/<sample>_R1.fq.gz and 0-raw/<sample>_R2.fq.gz
# If this is different, please rename the files accordingly before running the pipeline
# It is also good practice to run pipelines on a copy of the data, rather than the original data

# Get samples
# Extract all samples from the groups defined in the configuration
all_samples = set()  # Use a set to avoid duplicates
for group_samples in config['groups'].values():
    all_samples.update(group_samples)
all_samples = list(all_samples)  # Convert set back to list if needed for Snakemake

#### Check Rule ####

rule all:
    input:
        CheckRawFastQC = expand("Checks/1.1-RawFastQC_{sample}.done", sample = all_samples)

#### PIPELINE ####

include: "1-Preprocessing.smk"
#include: "2-QC.smk"
#include: "2.2-EC_Dedup.smk" # This is optional, but recommended
#include: "3-IndividualAssembly.smk" # Assembles Error Corrected and Deduplicated reads on a sample by sample basis
#include: "4-VirusIdentification.smk" # Runs Genomad on the assemblies
#include: "5-Dereplication.smk" # Runs dRep on the assemblies
#include: "6-Mapping_vOTUs.smk"
#include: "7-HostPrediction.smk"
#include: "8-Annotation.smk"
#include: "10-Taxonomy.smk"