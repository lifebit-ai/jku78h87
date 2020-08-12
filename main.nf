// Aggregation correction workflow

Channel
    .fromPath(params.aggregate_files)
    .set{ aggregate_files_channel }
    
Channel
    fromPath(params.final_sample_list)
    .set{ sample_list_channel }

process remove_and_anootate {
    cpus 32
    memory "10 GB"
    
    publishDir "./results", mode: "copy"

    input: 
        file(aggregate_file) from aggregate_files_channel
        file(sample_list) from sample_list_channel
    output:
        file("${outfile}")
    
    script:
    outfile=aggregate_file.toString().replaceAll(/bcf/, "vcf.gz")
    """
    
    bcftools view -S ${params.final_sample_list} \
     -Oz \
     --threads ${params.threads}
     -o ${outfile}
     ${aggregate_file}
    """
}
