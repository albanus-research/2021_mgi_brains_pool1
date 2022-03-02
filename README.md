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
