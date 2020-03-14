#!/usr/bin
#-*-coding:utf-8-*-

from xml.etree.ElementTree import iterparse
from collections import Counter

def parse_and_remove_1(filename,result_file):
    doc = iterparse(filename)
    fout = open(result_file,'w')
    cur_id_flag = 0
    cur_seq_flag = 0
    cur_id= ''
    cur_seq = ''
    for event,elem in doc:
        if cur_id_flag == 1 and cur_seq_flag == 1:
            strwrite = '>%s\n%s\n'%(cur_id,cur_seq)
            fout.write(strwrite)
            fout.flush()
            cur_id_flag = 0
            cur_seq_flag = 0
            cur_id = ''
            cur_seq = ''
        if event == 'end':
            if elem.tag == "name":
                cur_id = elem.text
                cur_id_flag = 1
            if elem.tag == 'antigenSequence':
                cur_seq = elem.text
                cur_seq_flag = 1

        elem.clear()
    fout.close()

def parse_and_remove_2(filename,result_file):
    print('***')
    doc = iterparse(filename, ('start', 'end'))
    tag_stack = []
    elem_stack = []
    for event, elem in doc:
        if event == 'start':
            print(elem.tag)
            tag_stack.append(elem.tag)
            elem_stack.append(elem)
        # elif event == 'end':
        #     if tag_stack == path_parts:
    #             print(elem)
    #             yield elem
    #             elem_stack[-2].remove(elem)


def parse_and_remove(filename,result_file):
    doc = iterparse(filename)
    fout = open(result_file,'w')
    for event,elem in doc:
        if event == 'end':
            if elem.tag == "name":
                cur_id = elem.text
                fout.write('>'+cur_id+'\n')
            if elem.tag == 'antibody':
                cur_antibody_id = elem.get('id')
                fout.write('%s#\n'%cur_antibody_id)
            if elem.tag == 'antigenSequence':
                cur_seq = elem.text
                if cur_seq is None:
                    fout.write('NoneType' + '\n')
                else:
                    fout.write(cur_seq + '\n')
        elem.clear()
    fout.close()

def rewrite_seq(input_file,output_file,err_file):
    fout = open(output_file,'w')
    ferr = open(err_file,'w')
    err_header_list = ['gene_id','antibody_id','antigen_seq']
    ferr.write('\t'.join(err_header_list)+'\n')
    with open(input_file,'r')as fin:
        content = fin.read()
        elems = content.split('>')
        if '' in elems:
            elems.remove('')
        for elem in elems:
            elem_content = elem.split('\n')
            if '' in elem_content:
                elem_content.remove('')
            cur_gene_id = elem_content[0]
            if len(elem_content) == 1:
                strwrite = '%s\tNA\tNA\n' % (cur_gene_id)
                ferr.write(strwrite)
            else:
                elem_remove_header = '\n'.join(elem_content[1:])
                elem_antibody_content = elem_remove_header.split('#\n')
                if '' in elem_antibody_content:
                    elem_antibody_content.remove('')

                for elem_antibody_item in elem_antibody_content:

                    cur_antibody_id = elem_antibody_item.split('\n')[1].replace('#','')
                    cur_angient_seq = elem_antibody_item.split('\n')[0]

                    if cur_angient_seq == 'NoneType':
                        strwrite = '%s\t%s\tNoneType\n' % (cur_gene_id, cur_antibody_id)
                        ferr.write(strwrite)
                    else:
                        strwrite = '>%s|%s\n%s\n' % (cur_gene_id, cur_antibody_id, cur_angient_seq)
                        fout.write(strwrite)
    ferr.close()
    fout.close()



if __name__=='__main__':
    input_file = '/100T/chencg/project/proteinatlas.xml'
    # input_file = 'test.txt'
    result_file = 'proteinatlas_antigensequence_1.faa'
    # parse_and_remove(input_file,result_file)
    re_result_file = 'proteinatlas_antigensequence_1_rewrite.faa'
    err_file = 'proteinatlas_antigensequence_err_id.txt'
    rewrite_seq(result_file, re_result_file, err_file)
