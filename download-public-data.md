# Transcriptome #
## 1. Single-cell Map of Diverse Immune Phenotypes in the Breast Tumor Microenvironment 3' RNA Sequencing ##
**reference:** [https://www.sciencedirect.com/science/article/pii/S0092867418307232](https://www.sciencedirect.com/science/article/pii/S0092867418307232 "Single-Cell Map of Diverse Immune Phenotypes in the Breast Tumor Microenvironment")<br>
**NCBI GEO link**: [https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE114725](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE114725 "GSE114725")<br>
**ENA link**: [https://www.ebi.ac.uk/ena/data/view/PRJNA472383](https://www.ebi.ac.uk/ena/data/view/PRJNA472383 "PRJNA472383")<br>
**download method**: download the txt file in **ENA link** and get the ftp sites of data fastq.gz according to the txt file,then use axel to download the sequence in fastq.gz<br>
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/images/download_data_from_ENA.png)
**description**: single-cell RNA-seq data from 45,000 immune cells from eight breast carcinomas, as well as matched normal breast tissue, blood, and lymph node.Single-cell RNA sequencing was performed on eight donors using the InDrop v2 protocol. For each donor populations of CD45+ immune cells were assayed for trancriptome-wide RNA-sequence. At least one replicate was taken for each donor.<br>
**sample size**: 173 transcriptomic paired-end samples

----------

# TCR #
## 1.Single-cell Map of Diverse Immune Phenotypes in the Breast Tumor Microenvironment - 5' RNA sequencing and TCR sequencing ##
**reference:** [https://www.sciencedirect.com/science/article/pii/S0092867418307232](https://www.sciencedirect.com/science/article/pii/S0092867418307232 "Single-Cell Map of Diverse Immune Phenotypes in the Breast Tumor Microenvironment")<br>
**NCBI GEO link**: [https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE114724](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE114724 "GSE114724")<br>
**ENA link**: [https://www.ebi.ac.uk/ena/data/view/PRJNA472381](https://www.ebi.ac.uk/ena/data/view/PRJNA472381 "PRJNA472381")<br>
**download method**: download the txt file in **ENA link** and get the ftp sites of data fastq.gz according to the txt file,then use axel to download the sequence in fastq.gz<br>
**description**: single-cell RNA-seq data from 45,000 immune cells from eight breast carcinomas, as well as matched normal breast tissue, blood, and lymph node.Single-cell RNA sequencing was performed on eight donors using the InDrop v2 protocol. For each donor populations of CD45+ immune cells were assayed for trancriptome-wide RNA-sequence. At least one replicate was taken for each donor.<br>
**sample size**: 30 TCR paired-end samples
## 2. Clonal replacement of tumor-specific T cells following PD-1 blockade
**reference**: Clonal replacement of tumor-specific T cells following PD-1 blockade(https://www.nature.com/articles/s41591-019-0522-3)  
**ensemble and scRNA-seq data**:  have been deposited in the GEO and are available under accession number **GSE123814**, **single cell** sequencing data accession number **GSE123813**, **bulk RNA** sequencing data accession number **GSE123812**.   
**Exome-sequencing data** : have been deposited in the Sequence Read Archive (SRA) and are available under accession number **PRJNA533341**.   
**Bulk TCR-seq data** : can be accessed through the ImmuneACCESS database of Adaptive Biotechnologies (https://doi.org/10.21417/KY2019NM; https://clients.adaptivebiotech.com/pub/yost-2019-natmed).  
**other relevant data** : are available from the corresponding authors upon reasonable request.  
**description**: Here we performed paired single-cell RNA and T cell receptor sequencing on 79,046 cells from site-matched tumors from patients with basal or squamous cell carcinoma before and after anti-PD-1 therapy. In **single cell** sequencing condition, dissociated tumor samples were sorted as either CD45+ CD3+ tumor-infiltrating T cells, other CD45+ CD3- tumor-infiltrating lymphocytes and CD45- CD3- tumor/stromal cells. Sorted cells were subjected to paired single cell RNA- and TCR-sequencing on the droplet based 10X Genomics platform. In **bulk RNA** sequencing condition, CD4+ T helper cells were sorted as naive T cells (CD4+CD25-CD45RA+), Treg (CD4+CD25+IL7Rlo), Th1 (CD4+CD25-IL7RhiCD45RA-CXCR3+CCR6-), Th2 (CD4+CD25-IL7RhiCD45RA-CXCR3-CCR6-), Th17 (CD4+CD25-IL7RhiCD45RA-CXCR3-CCR6+), Th1-17 (CD4+CD25-IL7RhiCD45RA-CXCR3+CCR6+), and Tfh subsets (CXCR5+ counterparts of each). RNA-seq cDNA library construction was performed using the SMART-Seq v4 Ultra Low Input RNA Kit (Clontech) with 2 ng of input RNA. Sequencing libraries were prepared using the Nextera XT DNA Library Prep Kit (Illumina).    
**sample size**: 86 single cell paired-end samples, 38 bulk RNA paired-end samples.

## 4.Dynamics of Individual T Cell Repertoires: From Cord Blood to Centenarians
**reference:** [Dynamics of Individual T Cell Repertoires: From Cord Blood to Centenarians](https://www.jimmunol.org/content/196/12/5005).<br>
**SRA ID**: SRP072419 <br>
**ENA link**: https://www.ebi.ac.uk/ena/data/view/PRJNA316572<br>
**description**： The dataset contains T-cell Receptor Beta Chain sequences from blood of systemically healthy individuals of various ages (from cord blood to 103 years old, some donors are present in replicates). Individual cDNA molecules were labeled with an unique molecular identifier (UMI) tag prior to library preparation. Custom adapters with sample barcodes were used to multiplex samples, barcode sequences and instructions for de-multiplexing are available at https://github.com/mikessh/aging-study. Libraries were prepared according to our standardized protocol. <br>
**sample size**: 8 UCB and 65 peripheral blood pair-end samples of 65 healthy individuals aged 6–103 years old including the 39 individuals previously published in Britanova et al.
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/images/TCR_data4.png)
