library(purrr)
library(readr)
library(magrittr)

args <- commandArgs(trailingOnly=TRUE)
manifest <- args[1]
manifest_df <- readr::read_tsv(manifest)

do_cwl <- function(row){
    stderr <- system2(
        "cwltool", 
        args = c("fastq_mixing_workflow_cwl/repeat_workflow.cwl", row$yaml), 
        stderr = T)
    writeLines(stderr, row$log)
}

manifest_df %>% 
    split(1:nrow(.)) %>% 
    purrr::walk(do_cwl)