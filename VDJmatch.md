# VDJmatch: a software for database-guided prediction of T-cell receptor antigen specificity

VDJmatch is a command-line tool designed for matching T-cell receptor (TCR) repertoires against a database of TCR sequences with known antigen specificity. VDJmatch implements an API for interacting and querying the VDJdb database, and serves as a backend for VDJdb web browser. VDJmatch will automatically download and use the latest version of the VDJdb database, however, it is also possible to use a custom database provided by user if it matches VDJdb format specification.

VDJmatch accepts TCR clonotype table(s) as an input and relies on VDJtools framework to parse the output of commonly used immune repertoire sequencing (RepSeq) processing tools. See [format](http://vdjtools-doc.readthedocs.org/en/latest/input.html) section of VDJtools docs for the list of supported formats. Note that VDJmatch can be used with [metadata](http://vdjtools-doc.readthedocs.org/en/latest/input.html#metadata) semantics introduced by VDJtools to facilitate running annotation for multi-sample datasets.

## Installing and running
VDJdb is distributed as an executable JAR that can be downloaded from the [releases section](https://github.com/antigenomics/vdjdb/releases), the software is cross-platform and requires Java v1.8 or higher to run.
### VDJmatch run
To run the executable JAR use the java command as described below.  
```
-jar path/to/vdjmatch-version.jar match [options]
```
Running without any [options] or with -h option will display the help message.

### VDJmatch update
The latest version of VDJdb will be downloaded the first time you run VDJmatch. Note that in order to update to the most recent version next time, you will need to run following command.
```
java -jar path/to/vdjmatch-version.jar Update
```
### VDJmatch command line options
The following syntax should be used to run VDJmatch for RepSeq sample(s)

```
java -Xmx4G -jar path/to/vdjmatch-version.jar match \
      [options] [sample1 sample2 sample3 ... if -m is not specified] output_prefix
```

First part of the command runs the JAR file and sets the memory limit to 4GB (should be increased in case JVM drops with heap size exception) and points to VDJmatch executable JAR (version should be replaced with the software version). The second part includes options, input samples and the prefix of output files.

General

Option name |	Argument example |	Description 
---|---|---
‑h	| 	|Display help message
‑m, ‑‑metadata |	/path/to/metadata.txt	| A metadata file, holding paths to samples and user-provided information.
‑‑software	| MITCR,MIGEC,etc	| Input RepSeq data format, see formats supported for conversion. By default expects input in VDJtools format.
‑c, ‑‑compress | 		| Compress sample-level summary output with GZIP.

Database pre-filtering

Option name |	Argument example |	Description 
---|---|---
‑S, ‑‑species	| human,mouse,etc |	(Required) Species name. All samples should belong to the same species, only one species is allowed.
‑R, ‑‑gene	| TRA,TRB,etc	| (Required) Name of the receptor gene. All samples should contain to the same receptor gene, only one gene is allowed.
‑‑filter | 	"__antigen.species__=~'EBV'" | 	(Advanced) Logical filter expresstion that will be evaluated for database columns.
‑‑vdjdb‑conf |	1	 | VDJdb confidence level threshold, from 0 (lowest) to 3 (highest), default is 0.
‑‑min‑epi‑size | 10	| Minimal number of unique CDR3 sequences per epitope in VDJdb, filters underrepresented epitopes. Default is 10

Using external database (advanced)

Option name |	Argument example |	Description 
---|---|---
‑‑database | /path/to/my_db | Path and prefix of an external database. Should point to files with '.txt', and '.meta.txt' suffices (the database itself and database metadata).
‑‑use‑fat‑db | 		| In case running with a built-in database, will use full database version instead of slim one.

Full database contains extended info on method used to identify a given specific TCR and sample source, but has a higher degree of redundancy (several identical TCR:pMHC pairs from different publications, etc) that can complicate post-analysis.

Scoring parameters

Option name |	Argument example |	Description 
---|---|---
‑A, ‑‑scoring‑vdjmatch |		|Use full VDJMATCH algorithm that computes full alignment score as a function of CDR3 mutations (weighted with VDJAM scoring matrix) and pre-computed V/J segment match scores.
‑‑scoring‑mode |	0 or 1 |	Either 0: scores mismatches only (faster) or 1: compute scoring for whole sequences (slower). Default is 1.

## VDJmatch output
The following output files will be generated:

1. $output_prefix.annot.summary.txt annotation summary containing the number of unique clonotypes (unique), their cumulative share of reads (frequency) and total read count (reads).
- Sample metadata will be appended to this table if provided via the -m option.
- Each row corresponds to a combination of database field values from the columns specified by the --summary-columns option (e.g. epitope and parent species, antigen.epitope + antigen.species). If a single clonotype is matched to several VDJdb records, its reads count and frequency and will be appended to all of them and the unique counter for each of the records will be incremented by 1.
- The weight/informativeness sum of database hits for each row is stored in the weight column and can be used to scale the results, together with the db.unique column, storing the total number of unique database TCR entries for a given combination of summary columns.
- Each of database records is tagged as entry in counter.type column of summary table, statistics (total number of clonotypes, read share and count) of annotated and unannotated clonotypes is stored in rows tagged as found and not.found respectively.
2. $output_prefix.$sample_id.txt annotation for each of the clonotypes found in database, a separate file is generated for each input sample.
- This is an all-to-all merge table between the sample and database that includes all matches.
- Clonotype information from the sample (count, frequency, cdr3 sequence, v/d/j segments and v/d/j markup) is preserved.
- As a clonotype can be represented by multiple rows in the output (i.e. match to several records in the database), id.in.sample column can be used to make the correspondence between annotation record and 0-based index of clonotype in the original sample. For the information on database columns that are appended see database schema in VDJdb-db repository readme.
- The score column contains CDR3 alignment score that is computed as described Scoring parameters section (not to be confused with VDJdb record confidence score.
- The weight column contains the weight (or informativeness) of corresponding database records, see Hit filtering and weighting section for details.

## Example
Running command
```
java -Xmx4G -jar /100T/software/vdjmatch/vdjmatch-1.3.1/vdjmatch-1.3.1.jar match -S human -R TRB --search-scope 3,1,3 -v-match -j-match /100T/software/vdjmatch/vdjmatch-1.3.1_source_code/src/test/resources/sergey_anatolyevich.gz test
```
Result
annot.summary.txt (partial)
```
sample_id	metadata_blank	db.column.name	db.column.value	unique	frequency	reads	db.unique	weight
sergey_anatolyevich	.	antigen.epitope	RLRPGGKKK	18	0.0014019036375710174	19	33	18.0
sergey_anatolyevich	.	antigen.epitope	CLGGLLTMV	29	0.002508669667232348	34	20	29.0
sergey_anatolyevich	.	antigen.epitope	GILGFVFTL	2194	0.19966059175089743	2706	3422	2194.0
sergey_anatolyevich	.	antigen.epitope	AYAQKIFKI	62	0.005312476942374389	72	39	62.0
sergey_anatolyevich	.	antigen.epitope	TPQDLNTML	24	0.0018446100494355492	25	109	24.0
sergey_anatolyevich	.	antigen.epitope	RLRPGGKKR	5	3.6892200988710984E-4	5	22	5.0
sergey_anatolyevich	.	antigen.epitope	EPLPQGQLTAY	41	0.003172729285029148	43	36	41.0
sergey_anatolyevich	.	antigen.epitope	ELAGIGLTV	9	6.640596177967977E-4	9	13	9.0
sergey_anatolyevich	.	antigen.epitope	IILVAVPHV	11	8.854128237290636E-4	12	12	11.0
sergey_anatolyevich	.	antigen.epitope	RPRGEVRFL	22	0.0016970412454807053	23	32	22.0
sergey_anatolyevich	.	antigen.epitope	GTSGSPIVNR	101	0.007747362207629322	105	170	101.0
sergey_anatolyevich	.	antigen.epitope	GLIYNRMGAVTTEV	241	0.023611008632774926	320	121	241.0
sergey_anatolyevich	.	antigen.epitope	MLDLQPETT	11	8.116284217516416E-4	11	14	11.0

```
sergey_anatolyevich.txt (partial)

```
count	freq	cdr3nt	cdr3aa	v	d	j	VEnd	DStart	DEnd	JStart	id.in.sample	match.score	match.weight	gene	cdr3	species	antigen.epitope	antigen.gene	antigen.species	complex.id	v.segm	j.segm	v.end	j.start	mhc.a	mhc.b	mhc.class	reference.id	vdjdb.score
291	0.021471260975429795	TGTGCCAGCAGCGTAGCCTTAGGGCTAAACTACGAGCAGTACTTC	CASSVALGLNYEQYF	TRBV9	.	TRBJ2-7	-1	-1	-1	-1	0	0.0	1.0	TRB	CASSVALGLNYEQYF	HomoSapiens	NLSALGIFST	IGF2BP2	HomoSapiens	0	TRBV9*01	TRBJ2-7*01	5	10	HLA-A*02	B2M	MHCI	PMID:29483360	0
291	0.021471260975429795	TGTGCCAGCAGCGTAGCCTTAGGGCTAAACTACGAGCAGTACTTC	CASSVALGLNYEQYF	TRBV9	.	TRBJ2-7	-1	-1	-1	-1	0	-3.0	1.0	TRB	CASSVADLSYEQYF	HomoSapiens	KRWIILGLNK	Gag	HIV-1	0	TRBV9*01	TRBJ2-7*01	5	8	HLA-B*27:05	B2M	MHCI	PMID:23521884	0
291	0.021471260975429795	TGTGCCAGCAGCGTAGCCTTAGGGCTAAACTACGAGCAGTACTTC	CASSVALGLNYEQYF	TRBV9	.	TRBJ2-7	-1	-1	-1	-1	0	-3.0	1.0	TRB	CASSVAPGEYEQYF	HomoSapiens	KLGGALQAK	IE1	CMV	6047	TRBV9*01	TRBJ2-7*01	5	9	HLA-A*03:01	B2M	MHCI	https://www.10xgenomics.com/resources/application-notes/a-new-way-of-exploring-immunity-linking-highly-multiplexed-antigen-recognition-to-immune-repertoire-and-phenotype/#	0
291	0.021471260975429795	TGTGCCAGCAGCGTAGCCTTAGGGCTAAACTACGAGCAGTACTTC	CASSVALGLNYEQYF	TRBV9	.	TRBJ2-7	-1	-1	-1	-1	0	-3.0	1.0	TRB	CASSVGLGRGYEQYF	HomoSapiens	GILGFVFTL	M	InfluenzaA	0	TRBV9*01	TRBJ2-7*01	5	10	HLA-A*02	B2M	MHCI	PMID:28423320	0
291	0.021471260975429795	TGTGCCAGCAGCGTAGCCTTAGGGCTAAACTACGAGCAGTACTTC	CASSVALGLNYEQYF	TRBV9	.	TRBJ2-7	-1	-1	-1	-1	0	-3.0	1.0	TRB	CASSVAPGEYEQYF	HomoSapiens	AVFDRKSDAK	EBNA4	EBV	3722	TRBV9*01	TRBJ2-7*01	5	9	HLA-A*11:01	B2M	MHCI	https://www.10xgenomics.com/resources/application-notes/a-new-way-of-exploring-immunity-linking-highly-multiplexed-antigen-recognition-to-immune-repertoire-and-phenotype/#	0
291	0.021471260975429795	TGTGCCAGCAGCGTAGCCTTAGGGCTAAACTACGAGCAGTACTTC	CASSVALGLNYEQYF	TRBV9	.	TRBJ2-7	-1	-1	-1	-1	0	-3.0	1.0	TRB	CASSVGTGNYEQYF	HomoSapiens	KLGGALQAK	IE1	CMV	10093	TRBV9*01	TRBJ2-7*01	5	9	HLA-A*03:01	B2M	MHCI	https://www.10xgenomics.com/resources/application-notes/a-new-way-of-exploring-immunity-linking-highly-multiplexed-antigen-recognition-to-immune-repertoire-and-phenotype/#	0
291	0.021471260975429795	TGTGCCAGCAGCGTAGCCTTAGGGCTAAACTACGAGCAGTACTTC	CASSVALGLNYEQYF	TRBV9	.	TRBJ2-7	-1	-1	-1	-1	0	-3.0	1.0	TRB	CASSVAGGAYEQYF	HomoSapiens	LLWNGPMAV	NS4B	YFV	20764	TRBV9*01	TRBJ2-7*01	5	9	HLA-A*02:01	B2M	MHCI	PMID:28103239	0
291	0.021471260975429795	TGTGCCAGCAGCGTAGCCTTAGGGCTAAACTACGAGCAGTACTTC	CASSVALGLNYEQYF	TRBV9	.	TRBJ2-7	-1	-1	-1	-1	0	-3.0	1.0	TRB	CASSVASGQGYEQYF	HomoSapiens	NLVPMVATV	pp65	CMV	0	TRBV9*01	TRBJ2-7*01	5	10	HLA-A*02	B2M	MHCI	PMID:28423320	0
291	0.021471260975429795	TGTGCCAGCAGCGTAGCCTTAGGGCTAAACTACGAGCAGTACTTC	CASSVALGLNYEQYF	TRBV9	.	TRBJ2-7	-1	-1	-1	-1	0	-3.0	1.0	TRB	CASSVATGTYEQYF	HomoSapiens	NEGVKAAW	IE2	CMV	0	TRBV9*01	TRBJ2-7*01	5	9	HLA-B*44:03:08	B2M	MHCI	PMID:30487790	0
164	0.012100641924297204	TGTGCCAGCAGTTTATCGGGTGGTGCCGGGGAGCTGTTTTTT	CASSLSGGAGELFF	TRBV12-4	.	TRBJ2-2	-1	-1	-1	-1	1	-3.0	1.0	TRB	CASSFSGNTGELFF	HomoSapiens	RAKFKQLL	BZLF1	EBV	7200,4333,6994,6623,6865,5138,4688,5777,6746,6624,5033,5550,4101,7336,5666,7967,5306,4736,3769,6098,6252,6253,6256,7466,6376,7465,5685,6257,6095,3936,4104,4986,3931,6021,5451,7873,6665,5972,6260,782,4916,4631,4511,5688,7502,4634,5327,6415,7504,826,4999,6417,6032,6397,6550,4255,6830,4091,310,4808,5610,5611,7997,5216,7637,5614,5615,6428,3835,6285,6287,5352,6165,6289,7774,4661,6684,6169,442,5906,5622,5864,3841,5503,5988,7022,7021,7263,6452,4550,6333,5084,1437,5519,4269,6446,5756,6569,4428,8002,4320,5376,7039,5653,7030,100,503,4830,7546,6614,4955	TRBV12-4*01,TRBV12-3*01	TRBJ2-2*01	4	7	HLA-B*08:01	B2M	MHCI	https://www.10xgenomics.com/resources/application-notes/a-new-way-of-exploring-immunity-linking-highly-multiplexed-antigen-recognition-to-immune-repertoire-and-phenotype/#	1
164	0.012100641924297204	TGTGCCAGCAGTTTATCGGGTGGTGCCGGGGAGCTGTTTTTT	CASSLSGGAGELFF	TRBV12-4	.	TRBJ2-2	-1	-1	-1	-1	1	-1.0	1.0	TRB	CASSRSGGAGELFF	HomoSapiens	RAKFKQLL	BZLF1	EBV	5409	TRBV12-4*01	TRBJ2-2*01	4	9	HLA-B*08:01	B2M	MHCI	https://www.10xgenomics.com/resources/application-notes/a-new-way-of-exploring-immunity-linking-highly-multiplexed-antigen-recognition-to-immune-repertoire-and-phenotype/#	0
164	0.012100641924297204	TGTGCCAGCAGTTTATCGGGTGGTGCCGGGGAGCTGTTTTTT	CASSLSGGAGELFF	TRBV12-4	.	TRBJ2-2	-1	-1	-1	-1	1	-2.0	1.0	TRB	CASSSEGAGELFF	HomoSapiens	KLGGALQAK	IE1	CMV	16934	TRBV12-4*01	TRBJ2-2*01	4	8	HLA-A*03:01	B2M	MHCI	https://www.10xgenomics.com/resources/application-notes/a-new-way-of-exploring-immunity-linking-highly-multiplexed-antigen-recognition-to-immune-repertoire-and-phenotype/#	0
164	0.012100641924297204	TGTGCCAGCAGTTTATCGGGTGGTGCCGGGGAGCTGTTTTTT	CASSLSGGAGELFF	TRBV12-4	.	TRBJ2-2	-1	-1	-1	-1	1	-3.0	1.0	TRB	CASSLDSGNTGELFF	HomoSapiens	KLGGALQAK	IE1	CMV	14122	TRBV12-4*01	TRBJ2-2*01	5	8	HLA-A*03:01	B2M	MHCI	https://www.10xgenomics.com/resources/application-notes/a-new-way-of-exploring-immunity-linking-highly-multiplexed-antigen-recognition-to-immune-repertoire-and-phenotype/#	0
164	0.012100641924297204	TGTGCCAGCAGTTTATCGGGTGGTGCCGGGGAGCTGTTTTTT	CASSLSGGAGELFF	TRBV12-4	.	TRBJ2-2	-1	-1	-1	-1	1	-3.0	1.0	TRB	CASSLQGSGTGELFF	HomoSapiens	KLGGALQAK	IE1	CMV	1695	TRBV12-4*01	TRBJ2-2*01	5	9	HLA-A*03:01	B2M	MHCI	https://www.10xgenomics.com/resources/application-notes/a-new-way-of-exploring-immunity-linking-highly-multiplexed-antigen-recognition-to-immune-repertoire-and-phenotype/#	0
164	0.012100641924297204	TGTGCCAGCAGTTTATCGGGTGGTGCCGGGGAGCTGTTTTTT	CASSLSGGAGELFF	TRBV12-4	.	TRBJ2-2	-1	-1	-1	-1	1	-3.0	1.0	TRB	CASSLSPNTGELFF	HomoSapiens	KLGGALQAK	IE1	CMV	15440	TRBV12-4*01	TRBJ2-2*01	5	7	HLA-A*03:01	B2M	MHCI	https://www.10xgenomics.com/resources/application-notes/a-new-way-of-exploring-immunity-linking-highly-multiplexed-antigen-recognition-to-immune-repertoire-and-phenotype/#	0
164	0.012100641924297204	TGTGCCAGCAGTTTATCGGGTGGTGCCGGGGAGCTGTTTTTT	CASSLSGGAGELFF	TRBV12-4	.	TRBJ2-2	-1	-1	-1	-1	1	-2.0	1.0	TRB	CASSLSGTGELFF	HomoSapiens	KLGGALQAK	IE1	CMV	13690	TRBV12-4*01	TRBJ2-2*01	5	7	HLA-A*03:01	B2M	MHCI	https://www.10xgenomics.com/resources/application-notes/a-new-way-of-exploring-immunity-linking-highly-multiplexed-antigen-recognition-to-immune-repertoire-and-phenotype/#	0
112	0.00826385302147126	TGCAGTGCTAGAGGGGATACCGGGACAGGCTACGAGCAGTACTTC	CSARGDTGTGYEQYF	TRBV20-1	.	TRBJ2-7	-1	-1	-1	-1	2	-3.0	1.0	TRB	CSARGTSGMGYEQYF	HomoSapiens	NLVPMVATV	pp65	CMV	0	TRBV20-1*01	TRBJ2-7*01	4	10	HLA-A*02	B2M	MHCI	PMID:28423320	0
112	0.00826385302147126	TGCAGTGCTAGAGGGGATACCGGGACAGGCTACGAGCAGTACTTC	CSARGDTGTGYEQYF	TRBV20-1	.	TRBJ2-7	-1	-1	-1	-1	2	-2.0	1.0	TRB	CSARGTGTGSEQYF	HomoSapiens	NLVPMVATV	pp65	CMV	0	TRBV20-1*01	TRBJ2-7*01	4	10	HLA-A*02	B2M	MHCI	PMID:28423320	0
112	0.00826385302147126	TGCAGTGCTAGAGGGGATACCGGGACAGGCTACGAGCAGTACTTC	CSARGDTGTGYEQYF	TRBV20-1	.	TRBJ2-7	-1	-1	-1	-1	2	-2.0	1.0	TRB	CSARGTGTSYEQYF	HomoSapiens	NLVPMVATV	pp65	CMV	0	TRBV20-1*01	TRBJ2-7*01	4	8	HLA-A*02	B2M	MHCI	PMID:28423320	0

```


## Clustering TCR sequences
Can be performed using the cluster routine as follows:
```
java -Xmx4G -jar path/to/vdjmatch-version.jar cluster [options] input_sample output_prefix
```
Output file is a tab-delimited table that contains pairs of clonotypes (as in sample), their IDs and distances between them. Scoring and filtering options can be used in the same way as with match routine.

## Some useful notes / trick
When running with VDJtools output, all annotations generated by VDJtools e.g. NDN size, clonotype incidence for pooled samples, frequency vector in a joint sample, ... will be preserved and VDJdb-standalone annotation columns will be added after them. Vice-versa, VDJdb-annotated samples can be used in VDJtools analysis when keeping in mind the following 1) no conversion to VDJtools format is needed, 2) as a single clonotype can be reported several times many descriptive statistics are not applicable. An example usage of both VDJdb-standalone and VDJtools:

```
$VDJTOOLS PoolSample -m metadata.txt .
$VDJDB -S human -R TRB --filter="__antigen.species__=~'CMV'" pool.aa.table.txt .
$VDJTOOLS ApplySampleAsFilter -m metadata.txt pool.aa.table.annot.txt filtered/
```

## Reference
https://github.com/antigenomics/vdjmatch
