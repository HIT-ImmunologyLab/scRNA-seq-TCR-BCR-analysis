Skip to content
 
Search or jump to…

Pull requests
Issues
Marketplace
Explore
 
@fengxiaZhou 
Learn Git and GitHub without any code!
Using the Hello World guide, you’ll start a branch, write comments, and open a pull request.

 
HIT-ImmunologyLab
/
NCP-scRNA-seq
2
0 0
 Code  Issues 0  Pull requests 0  Actions  Projects 0  Wiki  Security  Insights
NCP-scRNA-seq
/
GLIPH.md
 

1
## Introduction
2
GLIPH clusters TCRs that are predicted to bind the same MHC-restricted peptide antigen. When multiple donors have contributed to the clusters, and HLA genotypes for those donors are available, GLIPH additionally can provide predictions of which HLA-allele is presenting the antigen.
3
​
4
Typically the user will pass in a sequence set of hundreds to thousands of TCR sequences. This dataset will be analyzed for very similar TCRs, or TCRs that share CDR3 motifs that appear enriched in this set relative to their expected frequencies in an unselected naive reference TCR set.
5
​
6
GLIPH returns significant motif lists, significant TCR convergence groups, and for each group, a collection of scores for that group indicating enrichment for motif, V-gene, CDR3 length, shared HLA among contributors, and proliferation count. When HLA data is available, it predicts the likely HLA that the set of TCRs recognizes.
7
​
8
​
9
**<font color=#FF0000>To avoid false positive conclusions drawn from PCR or read error, we separated biological replicates containing TCRs against the same specificity from different individuals and searched for enrichment of common motifs. Using this method, we could detect enriched motifs in CDR3s that were found within TCRs specific to a given pMHC from multiple individuals, but not in TCRs recognizing unrelated antigens </font>**
10
​
11
​
12
## Installation
13
1. Git clone GitHub project：
14
​
15
```
16
git clone https://github.com/immunoengineer/gliph.git
17
```
18
2. Uncompress source code
19
​
20
```
21
tar -xzvf gliph-1.0.tgz
22
```
23
3. Add the path to system $PATH.
24
​
25
```
26
vim /etc/profile
27
export PATH="Path-to-gliph/gliph/bin:$PATH"
28
source /etc/profile
29
```
@fengxiaZhou
Commit changes
Commit summary 
Update GLIPH.md
Optional extended description
Add an optional extended description…
  Commit directly to the master branch.
  Create a new branch for this commit and start a pull request. Learn more about pull requests.
 
© 2020 GitHub, Inc.
Terms
Privacy
Security
Status
Help
Contact GitHub
Pricing
API
Training
Blog
About

