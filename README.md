# Brain snRNA-seq with pooled samples
Ricardo D'Oliveira Albanus - Harari Lab, WashU St. Louis

### Usage
`commands` has all the pipeline invocations for CellRanger and Demuxlet.
`notebooks` has the R notebooks for data analysis.
Other folders are used by Snakemake.

### Running demuxlet
Edit `workflow/config.yml` to point to the relevant files. Then run Snakemake:
```sh
snakemake -pr --configfile workflow/config/config.yml --use-conda -c12 -j12
```

### snRNA-seq QC
This pipeline performs basic QC at the barcode level in `notebooks/qc_exploration.Rmd` and an initial exploration of the background RNA ("soup") composition in `notebooks/rna_soup.Rmd`. These are by no means exhaustive, and other tools such as DropletUtils, decontX, etc should be used.
I've included the compiled htmls for these notebooks here to illustrate the outputs.