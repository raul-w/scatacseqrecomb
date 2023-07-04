process CELLRANGER_ATAC_MKREF {
    tag "$reference_config"
    label 'process_high'

    input:
    path reference_config
    val reference_name
    path fasta
    path gtf

    output:
    path "${reference_name}", emit: reference
    path "versions.yml"     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    cellranger-atac \\
        mkref \\
        --config=$reference_config \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cellranger-atac: \$(echo \$( cellranger-atac --version 2>&1) | sed 's/^.*[^0-9]\\([0-9]*\\.[0-9]*\\.[0-9]*\\).*\$/\\1/' )
    END_VERSIONS
    """
}