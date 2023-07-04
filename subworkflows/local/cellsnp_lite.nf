/*
 * Get pileups using cellsnp-lite
 */

include {CELLSNP_LITE} from "../../modules/local/cellsnp_lite/main.nf"

// Define workflow to generate SNP pileups with cellsnp-lite
workflow CELLSNP_LITE_CALL {
    take:
        ch_cellranger_atac_output
        ch_het_snp_vcf

    main:
        ch_versions = Channel.empty()

        // Run cellsnp-lite
        CELLSNP_LITE( ch_cellranger_atac_output, ch_het_snp_vcf )

        ch_versions = ch_versions.mix(CELLSNP_LITE.out.versions)

    emit:
        versions = ch_versions
        cellsnp_lite_out  = CELLSNP_LITE.out.outs
}
