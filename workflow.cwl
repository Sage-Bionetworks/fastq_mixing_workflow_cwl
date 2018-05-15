#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

doc: runs fastq mixing and kallisto quantification for one repetition

requirements:
- class: SubworkflowFeatureRequirement

inputs:

  OUTPUT_NAME: string

  FASTQ_P1_FILES: 
    type:
      type: array
      items: File
      
  FASTQ_P2_FILES: 
    type:
      type: array
      items: File
      
  MIXER_FRACTIONS:
    type:
      type: array
      items: float

  MIXER_SEED:
    type: ["null", int]
    inputBinding:
      prefix: --seed

  KALLISTO_INDEX_FILE: File
  KALLISTO_THREADS: int
  
outputs:
  
  OUPUT_TSV: 
    type: File
    outputSource: [RENAME/output_file]

steps:
  MIX:
    run: ../fastq_mixer/fastq_mixer.cwl
    in: 
      fastq_files_p1: FASTQ_P1_FILES
      fastq_files_p2: FASTQ_P2_FILES
      sample_fractions: MIXER_FRACTIONS
      seed: MIXER_SEED
    out: [output_file1, output_file2]
      
  KALLISTO:
    run: ../kallisto_cwl/fastq_abundances_workflow.cwl
    in: 
      INDEX_FILE: KALLISTO_INDEX_FILE
      THREADS: KALLISTO_THREADS
      FASTQ_FILE1: MIX/output_file1
      FASTQ_FILE2: MIX/output_file2
    out: [ABUNDANCE_TSV]
    
  RENAME:
    run: rename.cwl
    in: 
      input_file: KALLISTO/ABUNDANCE_TSV
      output_string: OUTPUT_NAME
    out: [output_file]