## Introduction
DiscoTope server predicts discontinuous B cell epitopes from protein three dimensional structures. The method utilizes calculation of surface accessibility (estimated in terms of contact numbers) and a novel epitope propensity amino acid score. The final scores are calculated by combining the propensity scores of residues in spatial proximity and the contact numbers.

New in the DiscoTope version 2.0: Novel definition of the spatial neighborhood used to sum propensity scores and half-sphere exposure as a surface measure.

## Input Data
Please choose one of the following three submission methods:
1. Chain(s) in an existing PDB entry. Use comma for separation of chain ids. If this box is unspecified, the prediction will be done using all chains in the pdb file.
2. A file from your local disk containing a list of existing PDB entries with specified chain ID, one per line
3. A file from your local disk containing your own structure in PDB format (not necessarily present in PDB):

## Output Data
### Description
The output consists of 7 columns:
- Chain Id
- Residue number
- Amino acid
- Contact number
- Propensity score
- DiscoTope score
- <=B. Identified B cell epitope

### EXAMPLE OUTPUT
 
DiscoTope predictions for '1a2y'.
	Looking only at Chain(s):  A
	propensity score radius = 22.000 Angstroms, Upper Halfsphere radiues = 14.000, windowsize = 1, alpha = 0.115 
	Threshold = -3.700


1. Download Prediction File

2. Download PDB file

3. Download pymol display script
     Note that the file '1a2y.pdb' (from above) must reside
     in the same directory as '1a2y_pymol.pml'
4. View results in Jmol (please be patient...requires Jmol applet download) Residues colored by binary code - Yellow = predicted epitope residues


5. View results in Jmol (please be patient...requires Jmol applet download) Residues colored by DiscoTope score - Red = high score, Blue = low score

```
A	1	ASP	12	-3.653	-4.613
A	2	ILE	24	-6.595	-8.597
A	3	VAL	3	-6.961	-6.505
A	4	LEU	36	-10.827	-13.722
A	5	THR	7	-10.343	-9.959
A	6	GLN	25	-11.905	-13.411
A	7	SER	5	-10.829	-10.158
A	8	PRO	9	-10.021	-9.904
A	9	ALA	0	-9.261	-8.196
A	10	SER	4	-8.622	-8.090
A	11	LEU	26	-8.722	-10.709
A	12	SER	1	-5.088	-4.618
A	13	ALA	26	-6.063	-8.356
A	14	SER	1	-3.958	-3.617	<=B
A	15	VAL	3	-4.265	-4.119
A	16	GLY	2	-4.568	-4.273
A	17	GLU	13	-6.781	-7.496
```

Identified 8 B-Cell epitope residues out of 107 total residues


## Reference 
1. Reliable B Cell Epitope Predictions: Impacts of Method Development and Improved Benchmarking (https://dx.doi.org/10.1371%2Fjournal.pcbi.1002829)
2. Webserver: http://www.cbs.dtu.dk/services/DiscoTope/