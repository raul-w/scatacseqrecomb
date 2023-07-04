/*
 * Alignment with Cellranger-ATAC
 */

include {CELLRANGER_ATAC_MKREF} from "../../modules/local/cellrangeratac/mkref/main.nf"
include {CELLRANGER_ATAC_COUNT} from "../../modules/local/cellrangeratac/count/main.nf"

// Define workflow to align reads to genome with cellranger-atac
workflow CELLRANGER_ATAC_ALIGN {
    take:
        ch_reference_config
        ch_fastq
        reference_name
        ch_fasta
        ch_gtf

    main:
        ch_versions = Channel.empty()

        // CREATE CELLRANGER-ATAC REFERENCE
        CELLRANGER_ATAC_MKREF( ch_reference_config, reference_name, ch_fasta, ch_gtf )
        ch_versions = ch_versions.mix(CELLRANGER_ATAC_MKREF.out.versions)
        cellranger_atac_index = CELLRANGER_ATAC_MKREF.out.reference

        // Align reads
        CELLRANGER_ATAC_COUNT (
            ch_fastq.map{ meta, reads -> [meta, reads] },
            cellranger_atac_index
        )
        ch_versions = ch_versions.mix(CELLRANGER_ATAC_COUNT.out.versions)

    emit:
        versions = ch_versions
        cellranger_out  = CELLRANGER_ATAC_COUNT.out.outs
        cellranger_atac_index
}
