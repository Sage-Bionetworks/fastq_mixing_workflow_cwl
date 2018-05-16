#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

doc: runs fastq mixing and kallisto quantification for n repetitions

requirements:
- class: SubworkflowFeatureRequirement
- class: ScatterFeatureRequirement

inputs:

  OUTPUT_NAMES: 
    type:
      type: array
      items: string

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

  MIXER_SEEDS:
    type: 
      type: array
      items: int

  KALLISTO_INDEX_FILE: File
  KALLISTO_THREADS: int
  
outputs:
  
  OUPUT_TSVs: 
    type:
      type: array
      items: File
    outputSource: [WORKFLOW/OUPUT_TSV]

steps:

  WORKFLOW:
    run: workflow.cwl
    in: 
      OUTPUT_NAME: OUTPUT_NAMES
      FASTQ_P1_FILES: FASTQ_P1_FILES
      FASTQ_P2_FILES: FASTQ_P2_FILES
      MIXER_FRACTIONS: MIXER_FRACTIONS
      MIXER_SEED: MIXER_SEEDS
      KALLISTO_INDEX_FILE: KALLISTO_INDEX_FILE
      KALLISTO_THREADS: KALLISTO_THREADS
    scatter: [OUTPUT_NAME, MIXER_SEED]
    scatterMethod: dotproduct
    out: [OUPUT_TSV]