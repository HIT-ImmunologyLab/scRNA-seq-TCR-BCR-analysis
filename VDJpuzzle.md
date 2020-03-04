## Introduction
VDJPuzzle, a computational method that reconstructs full-length BCRs from scRNA-seq.

## Installation
```
# Download repository
git clone https://bitbucket.org/kirbyvisp/vdjpuzzle2.git
# Move into the VDJPuzzle directory
cd vdjpuzzle2/
# Create the conda environment run
conda create --name vdjpuzzle --file environment-explicit.txt
# Add the environment variable
export PATH=/path_to_vdjpuzzle_dir/bin:$PATH
```
## Usage

### Execution and parameters

```
vdjpuzzle rna_seq_directory_name --bowtie-index=path_to_bt2_index/genome_prefix --gtf=path_to_gene_annotations.gtf [option]
```
**Note**  
- --bowtie-index and --gtf parameters are **mandatory**.
- rna_seq_directory_name contains the fastq files organized by single cell (i.e. one sub-directory for each cell that include the fastq files from that cell, check the structure of the Example directory).   
- All fastq files need to be **zipped** e.g. fastq.gz and **paired** data needs to be specified **using _1 and _2** in the file name

An additional script to plot gene expression as an heatmap annotated with mutation rates and other phenotype data is provided in scripts/mutation_gene_expression_analysis.R

### Run VDJPuzzle on a cluster
VDJPuzzle support the execution on a system with PBS scheduler by adding the **--qsub** option. Every system has different parameters, thus make sure to change these parameters at the beginning of the .sh files in the script directory.

### Example

VDJPuzzle requires the Ensembl reference genome (https://ccb.jhu.edu/software/tophat/igenomes.shtml).  

Other reference genome can be utilized (see details next section). This contains the bowtie index and genome annotation required to run VDJPuzzle.

```
nohup vdjpuzzle Example --bowtie-index=path_to_bt2_index/genome --gtf=path_to_gene_annotations.gtf > LOG.txt &
```
This command will take approximaly 30 minutes to complete. You will find the output in the summary_corrected directory.

### Run VDJPuzzle with a different reference genome
VDJPuzzle uses a BED file to locate the position of the VDJ genes in the genome. The BED files provided are built for the Ensembl reference genome. If you would like to use a different reference genome, you can generate a new BED file using this Python script.
```
#!/usr/bin/env python3

__author__ = 'David Koppstein'

# script for extracting receptors from
# currently works on ENSEMBL human release only

# requirements: gtf2bed, bedtools in PATH

import argparse
from subprocess import call
import os
import sys

universal_regex = '"((IG|TR)_[VCJ]_(pseudo)?gene|TRBV25)"'
bcr_regex = '"IG_[VCJ]_(pseudo)?gene"'
tcr_regex = '"(TR_[VCJ]_(pseudo)?gene|TRBV25)"' # apparently TRBV25OR9 is a special case


chains = {'TRA': [tcr_regex, '-v "(T(R|r)(D|d)[cCjJvV])"', '"^(chr)?14"'], # 'T(R|r)(A|a)[cCjJvV]',
          'TRB': [tcr_regex, '-v "(TRG[CJV]|Tcrg)"', '"^(chr)?(6|7|9)"'], # human or mouse 'T(R|r)(B|b)[cCjJvV]|ENST00000634383',
          'TRD': [tcr_regex, '"(T(R|r)(D|d)[cCjJvV])"', '"^(chr)?14"'], # ,
          'TRG': [tcr_regex, '"(TRG[CJV]|Tcrg)"', '"^(chr)?(7|13)"'], # 13 = mouse
          'IGH': [bcr_regex, '"^(chr)?(12|14)"'], # 'I(G|g)(H|h)[vVjJaAdDeEgGmM]',
          'IGK': [bcr_regex, '"^(chr)?(2|6)"'], # 'I(G|g)(K|k)[cCjJvV]',
          'IGL': [bcr_regex, '"^(chr)?(16|22)"']} # 'I(G|g)(L|l)[cCvVjJ]',

command = ('awk \'{{ if ($0 ~ "transcript_id") print $0; else print $0" transcript_id \\"\\";"; }}\' {infile} | '
           'grep -v PATCH | '
           '{egrep} | '
           'gtf2bed - | '
           'sort -k1,1 -k2,2n | '
           'bedtools merge -i - '
           '> {outfile}')

def main(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--infile', type=str,
                        required=True)
    parser.add_argument('-c', '--chain', type=str, required=True)
    parser.add_argument('-o', '--outfile', type=str,
                        required=True)
    opts = parser.parse_args()
    egrep = ' | '.join(['egrep {}'.format(regex) for regex in chains[opts.chain]])
    cmd = command.format(infile=opts.infile,
                         egrep=egrep,
                         outfile=opts.outfile)
    call(cmd, shell=True, executable='/bin/bash')


if __name__ == '__main__':
    main(sys.argv[1:])

```
## Reference
1. B-cell receptor reconstruction from single-cell RNA-seq with VDJPuzzle (https://doi.org/10.1093/bioinformatics/bty203)
2. https://bitbucket.org/kirbyvisp/vdjpuzzle2/src/master/
3. https://ccb.jhu.edu/software/tophat/igenomes.shtml
4. https://bitbucket.org/kirbyvisp/marmo/src/7cfeada825fb9a00d07ebe89a7e8599550b709f1/scripts/extract_receptors.py?at=master&fileviewer=file-view-default