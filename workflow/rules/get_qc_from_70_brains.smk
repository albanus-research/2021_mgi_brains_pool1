import os
from os.path import join

IONICE = config["IONICE"]

RESULTS = config["results"]
CELLRANGER_DIR = join(
    "/40/Cruchaga_Data/singleNuclei/201812_unsorted_ADvariants",
    "02.-ProcessedData/03.-CellRanger/3prime/parietal"
)
MATS_DIR = join(CELLRANGER_DIR, "{sample}", "outs/raw_feature_bc_matrix")
QC_DIR = join(RESULTS, "qc_70_brains", "{sample}")

# Wildcards
samples = os.listdir(CELLRANGER_DIR)
samples = [i for i in samples if i.endswith("-3prime")]

# wildcard_constraints:
#     sample = ".*-3prime"

rule all:
    input:
        expand(join(QC_DIR, "{sample}.barcode_metrics.tsv.gz"), sample=samples),

rule get_qc:
    output:
        join(QC_DIR, "{sample}.barcode_metrics.tsv.gz"),
    params:
        script = "Rscript workflow/scripts/get_raw_qc_metrics.R",
        sample = "{sample}",
        indir = CELLRANGER_DIR,
        out = QC_DIR
    log:
        join(QC_DIR, "{sample}.log"),
    shell:
        """
        {IONICE} {params.script} {params.sample} {params.indir} {params.out} \
            2>&1 | tee {log}
        """
        