# sage-iatlas-data

Data for the iAtlas app.

Shiny-iAtlas is an interactive web portal that provides multiple analysis modules to visualize and explore immune response characterizations across cancer types. The app is hosted on shinyapps.io at [https://isb-cgc.shinyapps.io/shiny-iatlas/](https://isb-cgc.shinyapps.io/shiny-iatlas/) and can also be accessed via the main CRI iAtlas page at [http://www.cri-iatlas.org/](http://www.cri-iatlas.org/).

## Install

### Requirements

**IMPORTANT**: For the smoothest installation, install git-lfs BEFORE cloning this repository.

> If you've already cloned, you may be able to do a `git pull` after installing git-lfs to fetch the large files (unverified).

- git-lfs: [https://git-lfs.github.com](https://git-lfs.github.com)

  - Some feather files are _very_ large. `git-lfs` is used to store these files.

  - For installation on the various platforms, please see this [git-lfs wiki](https://github.com/git-lfs/git-lfs/wiki/Installation)

- R: [https://www.r-project.org/](https://www.r-project.org/) - v3.6.2

- RStudio: [https://rstudio.com/products/rstudio/download](https://rstudio.com/products/rstudio/download)

- Docker: [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)

  Ensure that the location of the repository is shared via docker:

  - Mac: [https://docs.docker.com/docker-for-mac/#file-sharing](https://docs.docker.com/docker-for-mac/#file-sharing)

  - Windows: [https://docs.microsoft.com/en-us/archive/blogs/stevelasker/configuring-docker-for-windows-volumes](https://docs.microsoft.com/en-us/archive/blogs/stevelasker/configuring-docker-for-windows-volumes)

- libpq (postgres): [https://www.postgresql.org/download/](https://www.postgresql.org/download/)

- lib cairo: [https://www.cairographics.org/](https://www.cairographics.org/) (only required for iAtlas client)

- gfortran (libgfortran): usually installed with gcc

- Download the (very large) RNA Seq Expression file.

  - Download [EBPlusPlusAdjustPANCAN_IlluminaHiSeq_RNASeqV2.geneExp.feather](https://www.dropbox.com/s/a3ok4o63glq4p3j/EBPlusPlusAdjustPANCAN_IlluminaHiSeq_RNASeqV2.geneExp.feather?dl=0) and put it in the `/feather_files` folder
  - TODO: Move this file into Synapse. This file currently lives in Shane Brinkman-Davis's Dropbox (shane@genui.com).\
    The original tsv is found at: [https://gdc.cancer.gov/node/905/](https://gdc.cancer.gov/node/905/)

- STOP your local postgres server, if you have one running. The scripts in this repository will spin up a postgres server in a docker container. Your local postgres server will shadow it, and the app will consequently connect to the wrong server.

#### Requirements: MacOS Install instructions

Install package manager: [HomeBrew](https://brew.sh/) (or [MacPorts](https://www.macports.org/) or your package manager of choice)

Then run these in your shell:

- xcode-select --install
- brew install R
- brew install cairo
- brew install git-lfs
- brew install postgres
- download and install RStudio: [https://rstudio.com/products/rstudio/download](https://rstudio.com/products/rstudio/download)
- download and install Docker: [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)

### Initialize R Packages and builds the Database

To build the database locally:

1. Open `iatlas-data.Rproj` in Rstudio.

1. Follow the instructions.

When built, the database will be available on `localhost:5432`. The database is called `iatlas_dev`.

## Testing

After completing installation, open the Rproj and run:

```R
# run tests:
testthat::auto_test_package()

# code coverage report:
covr::report()
```

## Data

### Data Model

Information on the data model can be found in the `data_model` folder which contains this [README.md](./data_model/README.md#iatlas-data-model) file.

### Data Structure

Information on the data structure can be found in the `feather_files` folder which contains this [README.md](./feather_files/README.md#iatlas-data-structures) markdown file.

### Data Sources

Input data for the Shiny-iAtlas portal was accessed from multiple remote sources, including **Synapse**, the **ISB Cancer Genomics Cloud**, and **Google Drive**. The feather files derived from this data and used to populate the database are stored in the `feather_files` folder:

- `edges >`
  - `edges_TCGAImmune.feather`
  - `edges_TCGAStudy_Immune.feather`
  - `edges_TCGAStudy.feather`
  - `edges_TCGASubtype.feather`
- `features >`
- `gene_ids.feather`
- `genes >`
  - `driver_mutation_genes.feather`
  - `driver_mutation_genes.feather`
  - `immunomodulator_genes.feather`
  - `io_target_genes.feather`
- `nodes >`
  - `nodes_TCGAImmune.feather`
  - `nodes_TCGAStudy_Immune.feather`
  - `nodes_TCGAStudy.feather`
  - `nodes_TCGASubtype.feather`
- `patients >`
- `relationships >`
  - `features_to_samples >`
  - `genes_to_samples >`
  - `nodes_to_tags >`
  - `samples_to_tags >`
  - `tags_to_tags >`
- `results >`
- `samples >`
  - `immune_subtype_samples.feather`
  - `tcga_study_samples.feather`
  - `tcga_subtype_samples.feather`
- `SQLite_data >`
  - `driver_mutations1.feather`
  - `driver_mutations2.feather`
  - `driver_mutations3.feather`
  - `driver_mutations4.feather`
  - `driver_mutations5.feather`
  - `driver_results1.feather`
  - `driver_results2.feather`
  - `feature_values_long.feather`
  - `features.feather`
  - `groups.feather`
  - `immunomodulator_expr.feather`
  - `immunomodulators.feather`
  - `io_target_expr1.feather`
  - `io_target_expr2.feather`
  - `io_target_expr3.feather`
  - `io_target_expr4.feather`
  - `io_targets.feather`
  - `til_image_links.feather`
- `tags >`
