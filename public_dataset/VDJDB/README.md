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