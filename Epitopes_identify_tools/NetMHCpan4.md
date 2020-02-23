## Introduction
Cytotoxic T cells are of central importance in the immune system’s response to disease. They recognize defective cells by binding to peptides presented on the cell surface by MHC class I molecules. Peptide binding to MHC molecules is the single most selective step in the Ag-presentation pathway. Therefore, in the quest for T cell epitopes, the prediction of peptide binding to MHC molecules has attracted widespread attention. In the past, predictors of peptide–MHC interactions have primarily been trained on binding affinity data.

NetMHCpan-4.0, a method trained on binding affinity and eluted ligand data leveraging the information from both data types. Large-scale benchmarking of the method demonstrates an increase in predictive performance compared with state-of-the-art methods when it comes to identification of naturally processed ligands, cancer neoantigens, and T cell epitopes.

NetMHCpan server predicts binding of peptides to any MHC molecule of known sequence using artificial neural networks (ANNs). The method is trained on a combinatino of more than 180,000 quantitative binding data and MS derived MHC eluted ligands. The binding affinity data covers 172 MHC molecules from human (HLA-A, B, C, E), mouse (H-2), cattle (BoLA), primates (Patr, Mamu, Gogo) and swine (SLA). The MS eluted ligand data covers 55 HLA and mouse allelee. Furthermore, the user can obtain redictions to the any custom MHC class I molecule by uploading a full length MHC protein sequence.

![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/NetMHCpan.jpeg)

## Data resources used to develop this server was obtained from

**IEDB database**.
- Quantitative peptide binding data were obtained from the IEDB database.

**IMGT/HLA database**.
- Robinson J, Malik A, Parham P, Bodmer JG, Marsh SGE: IMGT/HLA - a sequence database for the human major histocompatibility complex. Tissue Antigens (2000), 55:280-287.
HLA protein sequences were obtained from the IMGT/HLA database (version 3.1.0).


## Input Data


## Output Data
### DESCRIPTION

The prediction output for each molecule consists of the following columns:


- Pos Residue number (starting from 0)
- HLA Molecule/allele name
- Peptide Amino acid sequence of the potential ligand
- Core The minimal 9 amino acid binding core directly in contact with the MHC
- Of The starting position of the Core within the Peptide (if > 0, the method predicts a N-terminal protrusion)
- Gp Position of the deletion, if any.
- Gl Length of the deletion.
- Ip Position of the insertions, if any.
- Il Length of the insertion.
- Icore Interaction core. This is the sequence of the binding core including eventual insertions of deletions.
- Identity Protein identifier, i.e. the name of the Fasta entry.
- Score The raw prediction score
- Aff(nM) Predicted binding affinity in nanoMolar units (if binding affinity predictions is selected).
- %Rank Rank of the predicted affinity compared to a set of random natural peptides. This measure is not affected by inherent bias of certain molecules towards higher or lower mean predicted affinities. Strong binders are defined as having %rank<0.5, and weak binders with %rank<2. We advise to select candidate binders based on %Rank rather than nM Affinity
- BindLevel (SB: strong binder, WB: weak binder). The peptide will be identified as a strong binder if the % Rank is below the specified threshold for the strong binders, by default 0.5%. The peptide will be identified as a weak binder if the % Rank is above the threshold of the strong binders but below the specified threshold for the weak binders, by default 2%.

### NOTES
Peptide vs. iCore vs. Core
Three amino acid sequences are reported for each row of predictions:
The Peptide is the complete amino acid sequence evaluated by NetMHCpan. Peptides are the full sequences submitted as a peptide list, or the result of digestion of source proteins (Fasta submission)
The iCore is a substring of Peptide, encompassing all residues between P1 and P-omega of the MHC. For all intents and purposes, this is the minimal candidate ligand/epitope that should be considered for further validation.
The Core is always 9 amino acids long, and is a construction used for sequence aligment and identification of binding anchors.

### EXAMPLE OUTPUT
Fasta input:
```
>Gag_180_209
TPQDLNTMLNTVGGHQAAMQMLKETINEEA
```
Peptide length: 8, 9, 10, 11, 12
Allele: HLA-A*0301
Toggle Sort by prediction score

will return the following predictions:

```
# NetMHCpan version 4.0

# Tmpdir made /usr/opt/www/webface/tmp/server/netmhcpan/59DBCCFF00005A84DAFF1311/netMHCpanVszuD8
# Input is in FSA format

# Peptide length 8,9,10,11,12

# Make Eluted ligand likelihood predictions

HLA-A03:01 : Distance to training data  0.000 (using nearest neighbor HLA-A03:01)

# Rank Threshold for Strong binding peptides   0.500
# Rank Threshold for Weak binding peptides   2.000
-----------------------------------------------------------------------------------
  Pos          HLA         Peptide       Core Of Gp Gl Ip Il        Icore        Identity     Score   %Rank  BindLevel
-----------------------------------------------------------------------------------
   15  HLA-A*03:01       HQAAMQMLK  HQAAMQMLK  0  0  0  0  0    HQAAMQMLK     Gag_180_209 0.5697290  0.2857 <= SB
   14  HLA-A*03:01      GHQAAMQMLK  GQAAMQMLK  0  1  1  0  0   GHQAAMQMLK     Gag_180_209 0.2137130  1.1582 <= WB
    7  HLA-A*03:01       TMLNTVGGH  TMLNTVGGH  0  0  0  0  0    TMLNTVGGH     Gag_180_209 0.0487720  3.0466
    8  HLA-A*03:01       MLNTVGGHQ  MLNTVGGHQ  0  0  0  0  0    MLNTVGGHQ     Gag_180_209 0.0319510  3.7842
   13  HLA-A*03:01     GGHQAAMQMLK  GQAAMQMLK  0  1  2  0  0  GGHQAAMQMLK     Gag_180_209 0.0313010  3.8215
   12  HLA-A*03:01    VGGHQAAMQMLK  VQAAMQMLK  0  1  3  0  0 VGGHQAAMQMLK     Gag_180_209 0.0166440  5.2079
   15  HLA-A*03:01      HQAAMQMLKE  HQAAMQMLK  0  0  0  0  0    HQAAMQMLK     Gag_180_209 0.0124970  5.9719
   16  HLA-A*03:01        QAAMQMLK  QAA-MQMLK  0  0  0  3  1     QAAMQMLK     Gag_180_209 0.0086270  7.1279
   21  HLA-A*03:01       MLKETINEE  MLKETINEE  0  0  0  0  0    MLKETINEE     Gag_180_209 0.0079270  7.4157
..
..
-----------------------------------------------------------------------------------

Protein Gag_180_209. Allele HLA-A*03:01. Number of high binders 1. Number of weak binders 1. Number of peptides 105

Link to Allele Frequencies in Worldwide Populations HLA-A03:01
-----------------------------------------------------------------------------------
```


## Reference
1. Netmhcpan-4.0: improved peptide–mhc class i interaction predictions integrating eluted ligand and peptide binding affinity data (https://www.jimmunol.org/content/199/9/3360)
2. Webserver: http://www.cbs.dtu.dk/services/NetMHCpan-4.0/
