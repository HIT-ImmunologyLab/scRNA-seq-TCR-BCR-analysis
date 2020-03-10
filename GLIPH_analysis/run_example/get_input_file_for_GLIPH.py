#!/usr/bin
#-*-coding:utf-8-*-

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


