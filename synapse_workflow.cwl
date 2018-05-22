#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

doc: runs fastq mixing and kallisto quantification for one repetition

requirements:
- class: SubworkflowFeatureRequirement
- class: ScatterFeatureRequirement

inputs:
  
  synapse_config_file: File
  yaml_config_file: File
  output_name: string
  kallisto_index_synapse_id: string
  upload_id: string
  
  fastq_p1_synapse_ids: 
    type:
      type: array
      items: string
      
  fastq_p2_synapse_ids: 
    type:
      type: array
      items: string
      
  mixer_fractions:
    type:
      type: array
      items: float

  mixer_seed: ["null", int]
  mixer_total_reads: ["null", int]
 
  kallisto_threads: ["null", int]
  
outputs:

  manifest: 
    type: File
    outputSource: sync_to_synapse/output

steps:
  
  get_index_file: 
    run: ../synapse_python_client_cwl/syn_get.cwl
    in: 
      config_file: synapse_config_file
      synapse_id: kallisto_index_synapse_id
    out: [output]
    
  gunzip_index_file:
    run: ../misc_cwl/gunzip.cwl
    in: 
      input: get_index_file/output
    out: [output]
  
  get_p1_files:
    run: ../synapse_python_client_cwl/syn_get.cwl
    in: 
      config_file: synapse_config_file
      synapse_id: fastq_p1_synapse_ids
    scatter: synapse_id
    scatterMethod: dotproduct
    out: [output]
    
  get_p2_files:
    run: ../synapse_python_client_cwl/syn_get.cwl
    in: 
      config_file: synapse_config_file
      synapse_id: fastq_p2_synapse_ids
    scatter: synapse_id
    scatterMethod: dotproduct
    out: [output]

  mix:
    run: ../fastq_mixer/fastq_mixer.cwl
    in: 
      fastq_files_p1: get_p1_files/output
      fastq_files_p2: get_p2_files/output
      sample_fractions: mixer_fractions
      seed: mixer_seed
      total_reads: mixer_total_reads
    out: [output_file1, output_file2]

  kallisto:
    run: ../kallisto_cwl/fastq_abundances_workflow.cwl
    in: 
      index_file: gunzip_index_file/output
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

  sync_to_synapse:
    run: sync_to_synapse.cwl
    in: 
      synapse_config_file: synapse_config_file
      tsv_file: rename/output_file
      upload_id: upload_id
      fastq_p1_synapse_ids: fastq_p1_synapse_ids
      fastq_p2_synapse_ids: fastq_p2_synapse_ids
      kallisto_index_synapse_id: kallisto_index_synapse_id
      yaml_config_file: yaml_config_file
    out: [output]
