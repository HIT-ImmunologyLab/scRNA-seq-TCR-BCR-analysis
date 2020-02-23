## Overview
MARIA (MHC Analyzer with Recurrent Integrated Architecture) is an integrated tool to predict how likely a peptide to be presented by HLA-II complexes on cell surface. MARIA deep neural network learned from over 60,000 naturally presented HLA-II peptide ligands considering their gene expression levels, binding affinities, cleavage signatures, and peptide sequences. Our work showed MARIA better identify presented HLA-II antigens and CD4 T-cell epitopes than conventional tools trained on in vitro binding affinities. MARIA for HLA-I is under active development.

## Implementation Details
MARIA was developed in python to be run via our website or command line. Users supply HLA-II alleles, gene names, and peptide sequences for each query (see Input File below for details). For each peptide, MARIA outputs a raw score (0-1) and normalized percentiles against an independent human peptides sequences (0-100%). High numbers indicate higher probabilities of presentation. Using 95% as cut-off to call positive presenters roughly ensures a specificity of 95%. Our website allows users to run 5,000 lines of peptides per query. Users should download the python script and run any jobs with >5000 lines of peptides. See the README file in the python script package for instructions. Commercial users need to obtain a license from Stanford University before using MARIA. See Non-Commercial Terms of Use.

## Input File
Users should modify the input file template from the Download section. The input file is a plain tap-delimited text file with a header and 5 required columns. Column 1 and 2 are HLA-DR or DQ alleles of the cells (see Supported Alleles for details). Column 3 is the gene symbol (e.g. CTSK) of genes encoding the peptide of interest. Column 4 is peptide sequences in single letter format (all capitalized, no space). Column 5 is optional gene expression values if users want to provide specific gene expression values for this antigen gene (in TPM). Otherwise gene expression values will be estimated from external RNA-Seq references (e.g. TCGA) and genes with unknown gene expression will be assigned with a TPM of 5.

## Note
- You must log in or register in order to run MARIA.
- Custom software code described in this work is available for academic research upon request from the authors 

## Reference
1. Predicting HLA class II antigen presentation through integrated deep learning (https://www.nature.com/articles/s41587-019-0280-2)
2. https://maria.stanford.edu/