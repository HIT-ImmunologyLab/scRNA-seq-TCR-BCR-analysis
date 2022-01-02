## gene_correlation_viz

**根据指定的项（metadata中已有的列项，根据一组基因，或不筛选）筛选特定细胞，，计算关注的细胞群中，关注的基因之间的相关性，关注的基因在细胞群中不同分组之间表达的差异性**

gene_corr_analysis(

seurat_object,

result_dir,

result_filename_prefix,

att_gene_list=c(),

analysis_type="all",

att_var_name="",

att_var_value_list=c(),

group_by="group_name",

group_item_level=c(),

active_gene_list=c(),

inhibit_gene_list=c(),

my_comparisons=c(),

script_path=“”){

**Arguments**

**seurat_object**: Seurat object

**result_dir**：结果目录

**result_filename_prefix**：结果文件名前缀

**att_gene_list**: 感兴趣的基因列表

**analysis_type**：筛选细胞的条件，可以不筛选，或根据已有的列项筛选，或根据一组基因筛选特定细胞，可设置为：“all”，“exist column”，“gene combination”

**att_var_name**：已有的列名

**att_var_value_list**：根据指定列，筛选哪些字段

**group_by**：是否分组画图的标签，若分组，可指定分组的名称seurat_clusters,group_name,manual_celltype等，不分组则设置为No，默认分组为group_name

**group_item_level**：分组绘图时的顺序，比如group，可指定顺序为（IA，IT，IC，HC），也可以不指定，不指定的话按字典序排序

**active_gene_list**: 有表达的基因列表，当analysis_type不是gene combination时，不需要指定，若analysis_type是gene combination，可以指定，可以不指定，但active_gene_list和inhibit_gene_list必须有一个指定

**inhibit_gene_list**：不表达的基因列表，当analysis_type不是gene combination时，不需要指定，若analysis_type是gene combination，可以指定，可以不指定，但active_gene_list和inhibit_gene_list必须有一个指定

**my_comparisons**：组间做差异检验时，要检验的分组，比如my_comparisons <- list(c("IA","HC"),c("IT","HC"),c("IC","HC"))

**script_path**:生成改图片的script的位置，默认不设置，如果有需要可以设置

## Example

```
seurat_rds_file <- "donor_seurat_UMAP.rds"
seurat_object <- readRDS(seurat_rds_file)

result_dir <- "/test_correlation_analysis"
result_filename_prefix <- "test_group"
att_gene_list <- c("CD8A","CD8B","PDCD1","CTLA4","TOX","CD4")
analysis_type <- "all"
group_item_level <- c("IA","IT","IC","HC")
group_by <- "group_name"
my_comparisons <- list(c("IA","HC"),c("IT","HC"),c("IC","HC"))
gene_corr_analysis(seurat_object,result_dir,result_filename_prefix,att_gene_list,analysis_type=analysis_type,group_by=group_by,group_item_level=group_item_level,my_comparisons=my_comparisons)


result_dir <- "test_correlation_analysis"
result_filename_prefix <- "test_all"
att_gene_list <- c("CD8A","CD8B","PDCD1","CTLA4","TOX","CD4")
analysis_type <- "all"
group_by <- "all"
gene_corr_analysis(seurat_object,result_dir,result_filename_prefix,att_gene_list,analysis_type=analysis_type,group_by=group_by)

result_dir <- "test_correlation_analysis"
result_filename_prefix <- "test_C01_C02_group"
att_gene_list <- c("CD8A","CD8B","PDCD1","CTLA4","TOX","CD4")
analysis_type <- "exist column"
att_var_name <- "seurat_clusters"
att_var_value_list <- c("0","1")
group_item_level <- c("IA","IT","IC","HC")
group_by <- "group_name"
my_comparisons <- list(c("IA","HC"),c("IT","HC"),c("IC","HC"))
script_path <- "example.R"
gene_corr_analysis(seurat_object,result_dir,result_filename_prefix,
                   att_var_name=att_var_name,att_var_value_list=att_var_value_list,att_gene_list=att_gene_list,
                   analysis_type=analysis_type,group_by=group_by,my_comparisons=my_comparisons,
                   group_item_level=group_item_level,script_path=script_path)
				   
result_dir <- "test_correlation_analysis"
result_filename_prefix <- "test_exhausted_gene_group"
att_gene_list <- c("CD8A","CD8B","PDCD1","CTLA4","TOX","CD4")
analysis_type <- "gene combination"
active_gene_list<-c("PDCD1","CTLA4")
group_item_level <- c("IA","IT","IC","HC")
group_by <- "group_name"
my_comparisons <- list(c("IA","HC"),c("IT","HC"),c("IC","HC"))
script_path <- "example.R"
gene_corr_analysis(seurat_object,result_dir,result_filename_prefix,
                   att_var_name=att_var_name,att_var_value_list=att_var_value_list,att_gene_list=att_gene_list,
                   analysis_type=analysis_type,group_by=group_by,my_comparisons=my_comparisons,
                   group_item_level=group_item_level,script_path=script_path,active_gene_list=active_gene_list)

```



