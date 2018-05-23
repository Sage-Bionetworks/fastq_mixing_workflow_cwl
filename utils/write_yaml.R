require(yaml)
require(purrr)

create_synapse_workflow_yaml <- function(
    yaml_file,
    synapse_config_file,
    output_name,
    fastq_p1_synapse_ids,
    fastq_p2_synapse_ids,
    mixer_fractions,
    upload_id,
    kallisto_index_synapse_id,
    mixer_seed = "compute",
    mixer_total_reads = NULL,
    kallisto_threads = NULL,
    annotations = NULL){
    
    if(mixer_seed == "compute") mixer_seed == sample(1:10000, 1)
    file_list <- list(
        "synapse_config_file" = file_to_yaml_file(synapse_config_file),
        "yaml_config_file" = file_to_yaml_file(yaml_file))
    other_list <- list(
        "output_name" = output_name,
        "fastq_p1_synapse_ids" = fastq_p1_synapse_ids,
        "fastq_p2_synapse_ids" = fastq_p2_synapse_ids,
        "mixer_fractions" = mixer_fractions,
        "upload_id" = upload_id,
        "kallisto_index_synapse_id" = kallisto_index_synapse_id,
        "mixer_seed" = mixer_seed,
        "mixer_total_reads" = mixer_total_reads,
        "kallisto_threads" = kallisto_threads)
    other_list <- purrr::discard(other_list, is.null)
    lst <- (c(file_list, other_list))
    yaml::write_yaml(lst, yaml_file)
}

create_workflow_yaml <- function(
    yaml_file,
    output_name,
    fastq_p1_files,
    fastq_p2_files,
    mixer_fractions,
    kallisto_index_file,
    mixer_seed = "compute",
    mixer_total_reads = NULL,
    kallisto_threads = NULL){
    
    if(mixer_seed == "compute") mixer_seed == sample(1:10000, 1)
    file_list <- list(
        "fastq_p1_files" = map(fastq_p1_files, file_to_yaml_file),
        "fastq_p2_files" = map(fastq_p2_files, file_to_yaml_file),
        "kallisto_index_file" = file_to_yaml_file(kallisto_index_file))
    other_list <- list(
        "output_name" = output_name,
        "mixer_fractions" = mixer_fractions,
        "mixer_seed" = mixer_seed,
        "mixer_total_reads" = mixer_total_reads,
        "kallisto_threads" = kallisto_threads)
    other_list <- purrr::discard(other_list, is.null)
    lst <- (c(file_list, other_list))
    yaml::write_yaml(lst, yaml_file)
}
