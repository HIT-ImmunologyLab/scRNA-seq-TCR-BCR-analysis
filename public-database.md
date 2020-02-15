# Ligand-receptor database
## Ligand-receptor paris database
A draft network of ligand–receptor-mediated multicellular signalling in human
- Present the first large-scale map of cell-to-cell communication between 144 human primary cell types. 
- Reveal that most cells express tens to hundreds of ligands and receptors to create a highly connected signalling network through multiple ligand–receptor paths
- Provide an online tool to interactively query and visualize our networks (https://fantom.gsc.riken.jp/5/suppl/Ramilowski_et_al_2015/)
![ligand_receptor_database](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/ligand_receptor_database.png)
- Demonstrate how this tool can reveal novel cell-to-cell interactions with the prediction that mast cells signal to monoblastic lineages via the CSF1–CSF1R interacting pair.
![ligand-receptor-network](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/ligand_receptor_network.png)


## CellPhoneDB
CellPhoneDB is a publicly available repository of curated receptors, ligands and its interactions. Subunit architecture is included for both ligands and receptors, representing heteromeric complexes accurately. This is crucial, as cell-cell communication relies on multi-subunit protein complexes that go beyond the binary representation used in most databases and studies.

CellPhoneDB integrates existing datasets that pertain to cellular communication and new manually reviewed information. Prestigious databases CellPhoneDB gets information are: UniProt, Ensembl, PDB, the IMEx consortium, IUPHAR.

CellPhoneDB can be used to search for a particular ligand/receptor or interrogate your own single-cell transcriptomics data.

**CellPhoneDB v2.0** is publicly available at https://github.com/Teichlab/cellphonedb  
**A user-friendly web interface** at http://www.cellphonedb.org/
![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/cellPhoneDB.png)

## Reference
1. Systematic expression analysis of ligand-receptor pairs reveals important cell-to-cell interactions inside glioma (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6532229/#CR20)
2. A draft network of ligand–receptor-mediated multicellular signalling in human (https://www.nature.com/articles/ncomms8866)
3. https://fantom.gsc.riken.jp/5/suppl/Ramilowski_et_al_2015/
4. CellPhoneDB v2.0: Inferring cell-cell communication from combined expression of multi-subunit receptor-ligand complexes (https://www.biorxiv.org/content/10.1101/680926v1.full)

# T-cell receptor sequences database
## VDJdb
VDJdb is a curated database of T-cell receptor (TCR) sequences with known antigen specificities.
- The primary goal of VDJdb is to facilitate access to existing information on T-cell receptor antigen specificities, i.e. the ability to recognize certain epitopes in a certain MHC contexts.
- **VDJdb can be accessed** at https://vdjdb.cdr3.net and https://github.com/antigenomics/vdjdb-db.
- **VDJdb in plain text format latest**:The latest version of the VDJdb database in tab-delimited format is available https://github.com/antigenomics/vdjdb-db/releases/latest
- **VDJdb in plain text format 2020-01-20**: The 2020-01-20 version of the VDJdb database in tab-delimited format is available https://github.com/HIT-ImmunologyLab/NCP-scRNA-seq/blob/master/public_dataset/vdjdb-2020-01-20.zip
- **Standalone application**:
A command line interface software (VDJdb-standalone) should be preferred in cases when huge amounts of immune repertoire sequencing data are being analyzed or when users are interested in obtaining unprocessed output for carrying out statistical analysis of the results on their own. The corresponding software package is available https://github.com/antigenomics/vdjmatch. VDJdb-standalone is distributed as an executable JAR and requires Java v1.7+ to run, for additional details see the README file in the repository linked above.
- **Web server (Advanced)**: VDJdb web browser application is an open-source software implemented using Play Framework, Angular and Semantic UI. A standalone browser version of the software can be installed locally, the following link(https://github.com/antigenomics/vdjdb-web) contains the software package and installation instructions.
- **Other**:
  - lightweight immune repertoire browser **VDJviz** 
  - immune repertoire sequencing data analysis software **VDJtools**.
## Reference
1. VDJdb: a curated database of T-cell receptor sequences with known antigen specificity (https://academic.oup.com/nar/article/46/D1/D419/4101254)