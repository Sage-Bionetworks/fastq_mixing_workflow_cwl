library(purrr)
library(stringr)

args <- commandArgs(trailingOnly=TRUE)
cwl_file <- args[1]

do_cwl <- function(cwl, yaml, log){
    stderr <- system2(
        "cwltool", 
        args = c(cwl, yaml), 
        stderr = T)
    writeLines(stderr, log) 
    system("rm -rf /tmp/tmp*")
}

yamls <- list.files() %>% 
    purrr::keep(stringr::str_detect(., ".yaml$"))

logs <- stringr::str_replace(yamls, ".yaml", ".txt")

map2(yamls, logs, function(yaml, log)
    do_cwl(cwl_file, yaml, log))