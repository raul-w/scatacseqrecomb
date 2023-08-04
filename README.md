<!-- [![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.XXXXXXX-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.XXXXXXX) -->

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A522.10.1-23aa62.svg)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)

## Introduction

**schneebergerlab/scatacseqrecomb** is a bioinformatics workflow for processing 10X Genomics single-cell ATAC-seq data to detect recombination events. It uses the nf-core template, but is not part of nf-core itself.

<!-- TODO nf-core: Include a figure that guides the user through the major workflow steps. Many nf-core
     workflows use the "tube map" design for that. See https://nf-co.re/docs/contributing/design_guidelines#examples for examples.   -->
<!-- TODO nf-core: Fill in short bullet-pointed list of the default steps in the pipeline -->

1. Read alignment ([`Cell Ranger ATAC`](https://support.10xgenomics.com/single-cell-atac/software/pipelines/latest/what-is-cell-ranger-atac))
2. Calling reference and alternate allele counts at a set of given heterozygous SNPs ([`cellsnp-lite`](https://cellsnp-lite.readthedocs.io/en/latest/index.html))

## Usage

> **Notes**
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how
> to set-up Nextflow. Make sure to [test your setup](https://nf-co.re/docs/usage/introduction#how-to-run-a-pipeline)
> with `-profile test, mamba` before running the workflow on actual data.
> 
> This workflow assumes that the cellranger-atac binary is present in your PATH. It can be obtained [here](https://support.10xgenomics.com/single-cell-atac/software/overview/welcome).

First, prepare a samplesheet with your input data that looks as follows:

`samplesheet.csv`:

```csv
sample,fastq_dir
atac_seq_sample_1,/path/to/reads/atac_seq_sample_1
```

Each row contains a sample ID and a path containing all reads (I1, R1, R2, R3) of a particular sample, following the 10X Genomics naming scheme specified [here](https://support.10xgenomics.com/single-cell-atac/software/pipelines/latest/using/fastq-input).

Now, you can run the pipeline using:

```bash
nextflow run schneebergerlab/scatacseqrecomb \
   -profile <conda/mamba/biohpc_gen> \
   --input samplesheet.csv \
   --reference_config reference_config.config \
   --reference_name reference_name \
   --fasta genome.fa \
   --gtf gene_annotation.gtf \
   --het_snps het_snps.vcf.gz \
   --outdir <OUTDIR>
```

For more details regarding usage and output, please see the [documentation](docs)

> **Warning:**
> Please provide pipeline parameters via the CLI or Nextflow `-params-file` option. Custom config files including those
> provided by the `-c` Nextflow option can be used to provide any configuration _**except for parameters**_;
> see [docs](https://nf-co.re/usage/configuration#custom-configuration-files).

## Credits

schneebergerlab/scatacseqrecomb was originally written by Raúl Wijfjes.

<!-- We thank the following people for their extensive assistance in the development of this pipeline: -->

<!-- TODO nf-core: If applicable, make list of people who have also contributed -->

## Citations

<!-- TODO nf-core: Add citation for pipeline after first release. Uncomment lines below and update Zenodo doi and badge at the top of this file. -->
<!-- If you use  schneebergerlab/scatacseqrecomb for your analysis, please cite it using the following doi: [10.5281/zenodo.XXXXXX](https://doi.org/10.5281/zenodo.XXXXXX) -->

<!-- TODO nf-core: Add bibliography of tools and data used in your pipeline -->

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.

This pipeline uses code and infrastructure developed and maintained by the [nf-core](https://nf-co.re) community, reused here under the [MIT license](https://github.com/nf-core/tools/blob/master/LICENSE).

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).
