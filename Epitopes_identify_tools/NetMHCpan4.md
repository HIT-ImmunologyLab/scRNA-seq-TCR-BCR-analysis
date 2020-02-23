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

## Reference
1. Netmhcpan-4.0: improved peptide–mhc class i interaction predictions integrating eluted ligand and peptide binding affinity data (https://www.jimmunol.org/content/199/9/3360)
2. Webserver: http://www.cbs.dtu.dk/services/NetMHCpan-4.0/
