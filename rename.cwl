#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [mv]

requirements:
- class: InlineJavascriptRequirement

inputs:
  
  input_file:
    type: File
    inputBinding: 
      position: 1
    
  output_string:
    type: string
    inputBinding: 
      position: 2
   
outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_string)