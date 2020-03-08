
## NCBI IgBLAST Documentation  
IgBLAST was developed at the NCBI to facilitate the analysis of immunoglobulin and T cell receptor variable domain sequences.

IgBLAST allows users to view the matches to the germline V, D and J genes, details at rearrangement junctions, the delineation of IG V domain framework regions and complementarity determining regions. IgBLAST has the capability to analyse nucleotide and protein sequences and can process sequences in batches. Furthermore, IgBLAST allows searches against the germline gene databases and other sequence databases simultaneously to minimize the chance of missing possibly the best matching germline V gene.

IgBLAST is described at https://www.ncbi.nlm.nih.gov/pubmed/23671333

## How to set up  
#### 1. Download IgBlast program

IgBlast program can be downloaded from (https://ftp.ncbi.nih.gov/blast/executables/igblast/release/LATEST ). We provide pre-compiled programs for Linux, Windows, MacOs as well as source code for you to build on your own platform.

For versions prior to 1.13.0, you also need to download the entire directory of internal_data and optional_file from https://ftp.ncbi.nih.gov/blast/executables/igblast/release/. We strongly encourage you to get the latest version.
#### 2. Get blast database for germline V, D, and J gene sequences.

IgBlast allows you to search any germline databases of your choice (using -germline_db_V, -germline_db_J and -germline_db_D options).

The NCBI mouse germline gene databases (i.e., mouse_gl_V, etc.) are supplied on our ftp site (https://ftp.ncbi.nih.gov/blast/executables/igblast/release/database/. Also see https://www.ncbi.nlm.nih.gov/igblast/ about database details).

To search IMGT germline sequences, you need to download them from IMGT web site (http://www.imgt.org/vquest/refseqh.html#VQUEST ). You need to download all V, D and J sequences for whatever organisms you are interested in. Combine all V, all D and all J sequences, respectively, into separate files (i.e., one file for all V sequences, one for all D sequences and one file all for J sequences). After you have downloaded the sequences, invoke our utility tool edit_imgt_file.pl (in the bin directory in the IgBlast release package) to process these sequences (i.e., to change the long IMGT definition lines to germline gene names only). For example:

bin/edit_imgt_file.pl imgt_file > my_seq_file

Then you can use NCBI’s makeblastdb tool (also in the bin directory ) to make the blast database from the above output file. For example:

bin/makeblastdb -parse_seqids -dbtype nucl -in my_seq_file

Now you can use my_seq_file as blast database file for IgBlast.
Other notes on setting up IgBlast

The internal_data directory contains data internal to igblast program only and users should NEVER add, delete, move, copy or edit any files in this directory. Igblastn program expects the internal_data directory under current directory (i.e., where you run igblast program) or a path pointed to by IGDATA environmental variable (avoid using space in your path name for Windows system). Note that this directory does NOT contain any germline gene databases you should search (see above for how you can obtain a germline gene database).

The optional_file directory contains files that indicate germline J gene coding frame start position (position is 0-based), the J gene type, and the CDR3 end position for each sequence in the germline J sequence database (Fields are tab-delimited). The suppliled annotation information is only for NCBI or IMGT germline gene sequence database (including gene names as well as the sequences). If you search your own database and if it contains different sequences or sequence identifiers, then you need to edit the corresponding file accordingly (Enter -1 if the frame information is unknownor) or you won’t get proper frame status or CDR3 information (other results will still be shown correctly). You need to use -auxiliary_data option to specify your file. You can directly supply a path to this file or put it under a path pointed to by IGDATA environmental variable.

## IgBLAST examples  
There are two IgBlast command line programs, igblastn and igblastp. The former is for nucleotide sequences and the latter is for protein sequences.
### igblastn examples
#### Searching germline gene database

These examples assume that your current working directory has the following file structure:

bin
myseq
database
internal_data
optional_file 

Assuming you have put your germline gene blast database files under the directory “database”, to query a mouse sequence against NCBI mouse germline gene database with standard text alignment result format, you can issue the following command:

bin/igblastn -germline_db_V database/mouse_gl_V -germline_db_J database/mouse_gl_J -germline_db_D database/mouse_gl_D -organism mouse -query myseq -auxiliary_data optional_file/mouse_gl.aux -show_translation -outfmt 3

To query a human sequence against IMGT human germline database:

bin/igblastn -germline_db_V database/imgt.Homo_sapiens.V.f.orf -germline_db_J database/imgt.Homo_sapiens.J.f.orf -germline_db_D database/imgt.Homo_sapiens.D.f.orf -organism human -query myseq -auxiliary_data optional_file/human_gl.aux -show_translation

To query a human sequence against custom database (using IGH repertoire from Andew Collins et al as an example)

bin/igblastn -germline_db_V database/UNSWIgVRepertoire_fasta.txt -germline_db_J database/UNSWIgJRepertoire_fasta.txt -germline_db_D database/UNSWIgDRepertoire_fasta.txt -organism human -query myseq  -auxiliary_data optional_file/human_gl.aux -show_translation

To query a mouse sequence against IMGT mouse TCR germline gene database:

bin/igblastn -germline_db_V database/imgt_tcr_db_v -germline_db_J database/imgt_tcr_db_j -germline_db_D database/imgt_tcr_db -organism mouse -query myseq -ig_seqtype TCR -auxiliary_data optional_file/mouse_gl.aux -show_translation -outfmt 3

You can type the following command to see details on all input parameters and the default setting, particularly those under Ig-BLAST options.

bin/igblastn -help

#### Searching other databases in addition to germline database.

Igblast allows you to search an additional database (such as NCBI nr database) as well as the germline database at the same time. You’ll get hits from the germline database followed by hits from the additional database. Note that the additional database may not contain any sequences identifiers that also exist in germline databases.

To query a mouse sequences against NCBI nr database, in addition to the mouse germline database:

bin/igblastn -germline_db_V database/mouse_gl_V -germline_db_J database/mouse_gl_J -germline_db_D database/mouse_gl_D -organism mouse -query myseq -auxiliary_data optional_file/mouse_gl.aux -show_translation -outfmt 3 -db nr -remote 

Note the -remote option used with this search…it directs igblast to send nr database searching to NCBI server which typically is much faster.
### igblastp examples:

The parameters are similar to those of igblastn except it does not search germline D database or germline J database. The optional file is not needed.
Some examples:
#### Searching a mouse sequence against mouse germline gene database

bin/igblastp -germline_db_V database/mouse_gl_V -query myseq.prot -outfmt 3 -organism mouse

#### Searching other databases in addition to germline database.

bin/igblastp -germline_db_V database/mouse_gl_V -query myseq.prot -outfmt 3 -organism mouse -db nr -remote

Reference:https://ncbi.github.io/igblast/
