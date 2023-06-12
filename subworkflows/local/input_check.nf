//
// Check input samplesheet and get read channels
//

include { SAMPLESHEET_CHECK } from '../../modules/local/samplesheet_check'

workflow INPUT_CHECK {
    take:
    samplesheet // file: /path/to/samplesheet.csv

    main:
    samplesheet.splitCsv ( header:true, sep:',' )
    .map { create_fastq_channel(it) }
    .groupTuple(by: [0]) // group replicate files together, modifies channel to [ val(meta), [ [reads_rep1], [reads_repN] ] ]
    .map { meta, reads -> [ meta, reads.flatten() ] } // needs to flatten due to last "groupTuple", so we now have reads as a single array as expected by nf-core modules: [ val(meta), [ reads ] ]
    .set { reads }

    emit:
    reads                                     // channel: [ val(meta), [ reads ] ]
}

// Function to get list of [ meta, [ fastq_dir ] ]
def create_fastq_channel(LinkedHashMap row) {
    // create meta map
    def meta = [:]
    meta.id         = row.sample

    // add path(s) of the fastq file(s) to the meta map
    def fastq_meta = []
    if (!file(row.fastq_dir).exists()) {
        exit 1, "ERROR: Please check input samplesheet -> FASTQ dir does not exist!\n${row.fastq_dir}"
    }
    fastq_meta = [ meta, [ file(row.fastq_dir) ] ]
    return fastq_meta
}
