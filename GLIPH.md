## Introduction
GLIPH clusters TCRs that are predicted to bind the same MHC-restricted peptide antigen. When multiple donors have contributed to the clusters, and HLA genotypes for those donors are available, GLIPH additionally can provide predictions of which HLA-allele is presenting the antigen.

Typically the user will pass in a sequence set of hundreds to thousands of TCR sequences. This dataset will be analyzed for very similar TCRs, or TCRs that share CDR3 motifs that appear enriched in this set relative to their expected frequencies in an unselected naive reference TCR set.

GLIPH returns significant motif lists, significant TCR convergence groups, and for each group, a collection of scores for that group indicating enrichment for motif, V-gene, CDR3 length, shared HLA among contributors, and proliferation count. When HLA data is available, it predicts the likely HLA that the set of TCRs recognizes.

<font color=#FF0000>To avoid false positive conclusions drawn from PCR or read error, we separated biological replicates containing TCRs against the same specificity from different individuals and searched for enrichment of common motifs. Using this method, we could detect enriched motifs in CDR3s that were found within TCRs specific to a given pMHC from multiple individuals, but not in TCRs recognizing unrelated antigens </font>


## Installation
1. Git clone GitHub project：

```
git clone https://github.com/immunoengineer/gliph.git
```
2. Uncompress source code

```
tar -xzvf gliph-1.0.tgz
```
3. Add the path to system $PATH.

```
vim /etc/profile
export PATH="Path-to-gliph/gliph/bin:$PATH"
source /etc/profile
```
## Usage
### Required Data Inputs
#### A table of TCR sequences

```
--tcr TCR_TABLE
```
The format of the table is tab delimited, expecting the following columns in this 
order. Only TCRb is required for the primary component of the algorithm to function, 
but patient identity is required for HLA prediction. 

Example:

```
CDR3b		TRBV	TRBJ	CDR3a		TRAV		TRAJ	PatientCounts
CAADTSSGANVLTF	TRBV30	TRBJ2-6	CALSDEDTGRRALTF	TRAV19		TRAJ5	09/02171
CAATGGDRAYEQYF	TRBV2	TRBJ2-7	CAASSGANSKLTF	TRAV13-1	TRAJ56	03/04922
CAATQQGETQYF	TRBV2	TRBJ2-5	CAASYGGSARQLTF	TRAV13-1	TRAJ22	02/02591
CACVSNTEAFF	TRBV28	TRBJ1-1	CAGDLNGAGSYQLTF	TRAV25		TRAJ28	PBMC8631
CAGGKGNSPLHF	TRBV2	TRBJ1-6	CVVLRGGSQGNLIF	TRAV12-1	TRAJ42	02/02071
CAGQILAGSDTQYF	TRBV6-4	TRBJ2-3	CATASGNTPLVF	TRAV17		TRAJ29	09/00181
CAGRTGVSTDTQYF	TRBV5-1	TRBJ2-3	CAVTPGGGADGLTF	TRAV41		TRAJ45	02/02591
CAGYTGRANYGYTF	TRBV2	TRBJ1-2	CVVNGGFGNVLHC	TRAV12-1	TRAJ35	01/08733
```
### Optional Data Inputs
#### HLA genotyping for each subject

```
--hla HLA_TABLE
```
The format of the table is tab delimited, with each row beginning with the identity of a subject, and then two or more following column providing HLA identification. The number of total columns (HLA defined genotypes) is flexible.
Example:

```
09/0217	DPA101:03	DPA102:02	DPB104:01	DPB114:01	DQA101:02 09/0125	DPA102:02	DPA102:02	DPB105:01	DPB105:01 DQA106:01 03/0345	DPA102:01	DPA102:01	DPB117:01	DPB101:01	DQA101:03 03/0492	DPA101:03	DPA102:01	DPB103:01 DPB111:01	DQA101:02 02/0259	DPA101:03	DPA101:03	DPB1104:01	DPB102:01	DQA1*02:01
```
### Optional Arguments
**Convergence group** - a set of multiple TCRs from one or more individuals that bind the same antigen in a similar manner through similar TCR contacts. GLIPH predicts convergence groups by asking "what is the probability that this cluster of similar TCRs could have appeared without the selection of common antigen?"

**Global convergence** - A pair of TCRs that share the same length CDR3 and differ by less than a certain number of amino acids in those CDR3s. Example: in a set of 300 random TCRs, finding two TCRs that only differ by one amino acid in their CDR3 would be highly unlikely.

**Local convergence** - A pair of TCRs that share in their CDR3 regions an amino acid motif that appears enriched in their sample set. Optionally this common motif could be positionally constrained. Example: in the malaria set, an enriched QRW motif was found in 23 unique TCRs from 12 individuals in a conserved position in their CDR3.

**Reference set**	- A large database of TCR sequences that are not expected to be enriched for the specificities found in the sample set. Example: by default, GLIPH uses as a reference database over 200,000 nonredundant naive CD4 and CD8 TCRb sequences from 12 healthy controls.

**Sample set** - The input collection of TCRs under evaluation that are potentially enriched for a specificity not present in the reference set.

## Examples

```
# To run GLIPH on a TCR_TABLE file mytcrtable.txt, run:
gliph-group-discovery.pl --tcr mytcrtable.txt

# Tun run GLIPH on a list of CDR3s mycdr3list.txt, run:
gliph-group-discovery.pl --tcr mycdr3list.txt

# To run GLIPH with an alternative mouse reference DB mouseDB.fa, run:
gliph-group-discovery.pl --tcr mytcrtable --refdb=mouseDB.fa
                                       
# To run GLIPH slower with a more thorough simdepth, run
gliph-group-discovery.pl --tcr mytcrtable.txt --simdepth=10000

# To run GLIPH slower with a more thorough simdepth and an altered lcminp, run
gliph-group-discovery.pl --tcr mytcrtable.txt --simdepth=10000 --lcminp=0.001

# To score GLIPH clusters, run 
  gliph-group-scoring.pl --convergence_file TCR_TABLE-convergence-groups.txt \
                         --clone_annotations TCR_TABLE \
                         --hla_file HLA_TABLE \
                         --motif_pval_file TCR_TABLE.minp.ove10.txt
```
## Reference

1. Identifying specificity groups in the T cell receptor repertoire (https://www.nature.com/articles/nature22976)
2. https://github.com/immunoengineer/gliph