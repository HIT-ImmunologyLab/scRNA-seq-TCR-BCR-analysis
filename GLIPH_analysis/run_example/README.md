## Introduction
TCR sequence information could be obtained by Cell Ranger VDJ analysis pipeline, and was saved in the file consensus_annotations.csv, we then perform cluster analysis using GLIPH.

## Usage
step1: Get input data for GLIPH from Cell Ranger VDJ analysis

```
def get_tcr_dict(tcr_info_file,tcr_gene_dict):
    with open(tcr_info_file, 'r')as fin:
        lines = fin.readlines()
        header_list = lines[0].strip('\n').split(',')
        for line in lines[1:]:
            content = line.strip('\n').split(',')
            cur_clone_type_id = content[0]
            cur_seq_chain = content[header_list.index('chain')]
            cur_cdr3_seq = content[header_list.index('cdr3')]
            cur_vgene = content[header_list.index('v_gene')]
            cur_jgene = content[header_list.index('j_gene')]
            if cur_clone_type_id not in tcr_gene_dict:
                tcr_gene_dict[cur_clone_type_id] = {}
                tcr_gene_dict[cur_clone_type_id][cur_seq_chain] = [[cur_cdr3_seq, cur_vgene, cur_jgene]]
            else:
                if cur_seq_chain not in tcr_gene_dict[cur_clone_type_id]:
                    tcr_gene_dict[cur_clone_type_id][cur_seq_chain] = [[cur_cdr3_seq, cur_vgene, cur_jgene]]
                else:
                    tcr_gene_dict[cur_clone_type_id][cur_seq_chain].append([cur_cdr3_seq, cur_vgene, cur_jgene])


if __name__=='__main__':
    input_file = 'consensus_annotations.csv'
    output_file = 'tcr_table_example_for_GLIPH.txt'
    err_file = 'chain_less_than_2.txt'

    tcr_gene_dict = {}

    fout = open(output_file,'w')
    ferr = open(err_file,'w')
    write_head_list = ['CDR3b','TRBV','TRBJ','CDR3a','TRAV','TRAJ','clonetype_id']
    fout.write('\t'.join(write_head_list)+'\n')
    for key in tcr_gene_dict:
        if len(tcr_gene_dict[key]) == 2:
            for trb_item in tcr_gene_dict[key]['TRB']:
                for tra_item in tcr_gene_dict[key]['TRA']:
                    strwrite_list = trb_item+tra_item+[key]
                    fout.write('\t'.join(strwrite_list)+'\n')
        else:
            str_err_write = '%s chain number:%d\n'%(key,len(tcr_gene_dict[key]))
            ferr.write(str_err_write)
    fout.close()
    ferr.close()
```

step2: Run GLIPH

```
gliph-group-discovery.pl --tcr tcr_table_example_for_GLIPH.txt > run.log 2>&1
```
## Result
Result file
```
clone network：tcr_table_example_for_GLIPH-clone-network.txt
convergence groups： tcr_table_example_for_GLIPH-convergence-groups.txt
kmer resample log： tcr_table_example_for_GLIPH-kmer_resample_1000_log.txt
motif pvalue file：tcr_table_example_for_GLIPH-kmer_resample_1000_minp0.001_ove10.txt
running log： run.log
```
clone network (partial)

```
CSASRDTNQPQHF	CASSRDGNQPQHF	global
CSASRDTNQPQHF	CASSRDRNQPQHF	global
CASSPEDTQYF	CASSPRDTQYF	global
CASSRQGGNEKLFF	CASSRTGGNEKLFF	global
CATSEPGTANQPQHF	CASSYPGTANQPQHF	global
CASSPDRAADTQYF	CASSPDRGADTQYF	global
CASRAGPSTDTQYF	CASRAGPGTDTQYF	global
CSARALAGGNTGELFF	CSARGLAGGNTGELFF	global
CASSPSTNYGYTF	CASSPTTNYGYTF	global
CASSAGADNEQFF	CATSDGADNEQFF	global
CSALLISGNTIYF	CAWTLISGNTIYF	global
CASSLAGSNTEAFF	CASSLAGGNTEAFF	global
CSASKETQYF	CASSQETQYF	global
CASSYGGYEQFF	CASSPGGYEQYF	global
CASSPIQGSRTEAFF	CASSPIQGSDSPLHF	local
CASSPIQGSRTEAFF	CASSPIQGSDSPLHF	local
CASSPIQGSRTEAFF	CASSPIQGINADTQYF	local
CASSPIQGSRTEAFF	CASSPIQGINADTQYF	local
CASSPIQGSRTEAFF	CASSPIQGGLILVEQFF	local
CASSPIQGSRTEAFF	CASSPIQGGLILVEQFF	local

```

convergence groups (partial)

```
1	CRG-CASSRTGLTAKNIQYF	CASSRTGLTAKNIQYF
1	CRG-CASTPGGRNSPLHF	CASTPGGRNSPLHF
1	CRG-CASSELFVGQPQHF	CASSELFVGQPQHF
5	CRG-CASSFKGQDADTQYF	CASSFKGQDADTQYF CASSFKGWAYSNQPQHF CASSFKGHSNRETEAFF CASSFKGSQETQYF CASSFKGGNIQYF
1	CRG-CATSGREDEQYF	CATSGREDEQYF
1	CRG-CASSSFSGGYNEQFF	CASSSFSGGYNEQFF
1	CRG-CASSSIARNEQFF	CASSSIARNEQFF
1	CRG-CAWTASSGLRGKLFF	CAWTASSGLRGKLFF
1	CRG-CASSIDIGYTF	CASSIDIGYTF
1	CRG-CASSLVPNTEAFF	CASSLVPNTEAFF
1	CRG-CASSQQGTVKNIQYF	CASSQQGTVKNIQYF
1	CRG-CASSQIQGEGQPQHF	CASSQIQGEGQPQHF
1	CRG-CASGLYFGTVWF	CASGLYFGTVWF

```
motif pvalue file

```
Motif	Counts	avgRef	topRef	OvE	p-value
SFKG	5	0.47	3	10.46	0.001
LSWQ	4	0.05	2	75.471	0.001
LQQG	5	0.3	3	16.556	0.001
SERP	4	0.36	3	10.84	0.001
EEAN	3	0.02	1	124.999	0.001
PIQG	4	0.27	3	14.705	0.001
SPIQ	4	0.26	3	14.869	0.001
KGRT	5	0.27	3	18.115	0.001
LQQ	5	0.47	4	10.593	0.001
SLQQ	4	0.29	3	13.513	0.001

```


