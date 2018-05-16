require(yaml)
require(purrr)

create_repeat_workflow_yaml <- function(
    yaml_file,
    output_names,
    fastq_p1_files,
    fastq_p2_files,
    mixer_fractions,
    mixer_seeds,
    kallisto_index_file,
    kallisto_threads){
    
    arg_list = list(
        "OUTPUT_NAMES" = output_names,
        "FASTQ_P1_FILES" = map(fastq_p1_files, file_to_yaml_file),
        "FASTQ_P2_FILES" = map(fastq_p2_files, file_to_yaml_file),
        "MIXER_FRACTIONS" = mixer_fractions,
        "MIXER_SEEDS" = mixer_seeds,
        "KALLISTO_INDEX_FILE" = file_to_yaml_file(kallisto_index_file),
        "KALLISTO_THREADS" = kallisto_threads)
    yaml::write_yaml(arg_list, yaml_file)
}

file_to_yaml_file <- function(file){
    list("path" = file, "class" = "File")
}