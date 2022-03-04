# Brain snRNA-seq with pooled samples
Ricardo D'Oliveira Albanus - Harari Lab, WashU St. Louis

### Usage
`commands` has all the pipeline invocations for CellRanger and Demuxlet.
`notebooks` has the R notebooks for data analysis. `compiled_notebooks.tar.gz` has the compiled R notebooks. `worflow` and its sub-folders are used by Snakemake (`workflow/Snakefile` contains the demuxlet pipeline).

### Running CellRanger
**3' CellPlex multiplexing**: Edit the cellranger config files in the `workflow/config` directory.

**Regular GEX**: Edit the CellRanger invocation directly in `commands`.

### Running demuxlet
1) Edit `workflow/config.yml` to point to the relevant files
2) `workflow/Snakefile` contains the fully documented demuxlet pipeline. It may be necessary to make minor changes to `checkpoint split_batches` depending on how the list of valid barcodes will be fed into the pipeline - please refer to the annotations inside the `Snakefile` for some pre-made examples.
3) Run Snakemake:
```sh
snakemake -pr --configfile workflow/config/config.yml --use-conda -c12 -j12
```

In the case of this experiment, we have ~2,000 CellPlex CMO assignments that didn't fail. These can be used to evaluate the demuxlet calls directly. In addition, I included genotypes from four samples that were not present in the experiment to determine demuxlet's FPR. This exploration is at `notebooks/demuxlet_pool1.Rmd` and the results from our data can be visualized in the corresponding html file.

### snRNA-seq QC
This pipeline performs **very basic** QC at the barcode level in `notebooks/qc_exploration.Rmd` and an initial exploration of the background RNA ("soup") composition in `notebooks/rna_soup.Rmd`. These are by no means exhaustive and other tools such as DropletUtils, decontX, etc should be used.
I've included the compiled htmls for these notebooks here to illustrate the outputs.
