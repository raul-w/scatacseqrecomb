process CELLSNP_LITE {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::cellsnp-lite=1.2.3"

    input:
    tuple val(meta), path(inputs)
    path het_snps

    output:
    tuple val(meta), path("${meta.id}", type: "dir"), emit: outs
    path "versions.yml"                  , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    cellsnp-lite \\
        -s outs/possorted_bam.bam \\
        -b outs/raw_peak_bc_matrix/barcodes.tsv \\
        -O '${meta.id}' \\
        -R ${het_snps} \\
        -p $task.cpus \\
        --minMAF 0.1 \\
        --minCOUNT 20 \\
        --UMItag None \\
        --gzip \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cellsnp-lite: \$(echo \$( cellsnp-lite --version 2>&1) | sed 's/^.*[^0-9]\\([0-9]*\\.[0-9]*\\.[0-9]*\\).*\$/\\1/' )
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mkdir -p "${prefix}"
    touch ${prefix}/fake_file.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cellsnp-lite: \$(echo \$( cellsnp-lite --version 2>&1) | sed 's/^.*[^0-9]\\([0-9]*\\.[0-9]*\\.[0-9]*\\).*\$/\\1/' )
    END_VERSIONS
    """
}