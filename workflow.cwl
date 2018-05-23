#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

doc: runs fastq mixing and kallisto quantification for one repetition

requirements:
- class: SubworkflowFeatureRequirement

inputs:

  output_name: string

  fastq_p1_files: 
    type:
      type: array
      items: File
      
  fastq_p2_files: 
    type:
      type: array
      items: File
      
  mixer_fractions:
    type:
      type: array
      items: float

  mixer_seed: ["null", int]
  mixer_total_reads: ["null", int]
  kallisto_index_file: File
  kallisto_threads: ["null", int]
  
outputs:
  
  output_tsv: 
    type: File
    outputSource: [rename/output_file]

steps:

  mix:
    run: ../fastq_mixer/fastq_mixer.cwl
    in: 
      fastq_files_p1: fastq_p1_files
      fastq_files_p2: fastq_p2_files
      sample_fractions: mixer_fractions
      seed: mixer_seed
      total_reads: mixer_total_reads
    out: [output_file1, output_file2]
      
  kallisto:
    run: ../kallisto_cwl/fastq_abundances_workflow.cwl
    in: 
      index_file: kallisto_index_file
      threads: kallisto_threads
      fastq_file1: mix/output_file1
      fastq_file2: mix/output_file2
    out: [abundance_tsv]
    
  rename:
    run: ../misc_cwl/rename.cwl
    in: 
      input_file: kallisto/abundance_tsv
      output_string: output_name
    out: [output_file]