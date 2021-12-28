## Dotplot_viz

**根据指定的项（metadata中已有的列项，一组基因的得分，根据一组基因筛选特定细胞），绘制UAMP或TSNE图，连续的变量显示不同梯度的渐变颜色，离散的变量，设置不同的颜色值**

dotplot_viz(

seurat_object,

reduction_method,

result_dir,

result_name_prefix,

analysis_type,

att_gene_list=c(),

active_gene_list=c(),

inhibit_gene_list=c(),

att_var_name="",

att_var_cont="No",

title_label="",

legend_label="",

num_transfor="No",

group_by="group_name",

group_item_level)

**Arguments**

**seurat_object**: Seurat object

**reduction_method**：降维的方法，可设置为 “TSNE”，“UMAP”

**result_dir**：结果目录

**result_name_perfix**：结果文件名前缀

**analysis_type**：分析的类型，已有的列项，一组基因的得分，根据一组基因筛选特定细胞，可设置为：“exist column”，“gene score”，“gene combination”

**att_gene_list**: 感兴趣的基因列表

**active_gene_list**: 有表达的基因列表，当分组标签不是gene_list时，不需要指定，若分组标签是gene_list，可以指定，可以不指定，但active_gene_list和inhibit_gene_list必须有一个指定

**inhibit_gene_list**：不表达的基因列表，当分组标签不是gene_list时，不需要指定，若分组标签是gene_list，可以指定，可以不指定，但active_gene_list和inhibit_gene_list必须有一个指定

**att_var_name**：已有的列名

**att_var_cont**：绘图的变量是离散变量还是连续变量，连续变量设置为Yes, 离散变量设置为No

**title_label**：图的title名，如果不设置，当分析以后列项时，为该项名称，否则为空

**legend_label**：图的legend名，如果不设置为att_values

**num_transfor**：对于连续性数值变量，是否要进行某种变化，可选择sqrt（开平方），log2,log10,默认为No，不进行变化

**group_by**：是否分组画图的标签，若分组，可指定分组的名称seurat_clusters,group_name,manual_celltype等，不分组则设置为No，默认分组为group_name

**group_item_level**：分组绘图时的顺序，比如group，可指定顺序为（IA，IT，IC，HC），也可以不指定，不指定的话按字典序排序

## Example

```
seurat_rds_file <- "donor_seurat_UMAP.rds"
seurat_object <- readRDS(seurat_rds_file)

## 分组绘制连续性变量clonetype_freq
reduction_method <- "UMAP"
result_dir <- "test_result"
result_name_prefix <- "test"
att_var_name <- "clonotype_freq"
att_var_cont <- "Yes"
title_label <- "clonotype_freq"
legend_label <- "clonotype_freq"
group_by <- "group_name"
group_item_level <- c("IA","IT","IC","HC")
analysis_type <- "exist column"
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,title_label=title_label,att_var_name=att_var_name,att_var_cont=att_var_cont,legend_label=legend_label,group_by=group_by,group_item_level=group_item_level)

## 不分组绘制离散型seurat_clusters
reduction_method <- "UMAP"
result_dir <- "test_result"
result_name_prefix <- "test"
att_var_name <- "seurat_clusters"
att_var_cont <- "No"
title_label <- "seurat_clusters"
legend_label <- "seurat_clusters"
group_by <- "No"
analysis_type <- "exist column"
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,title_label=title_label,att_var_name=att_var_name,att_var_cont=att_var_cont,legend_label=legend_label,group_by=group_by)

## 不分组绘制一组耗竭基因的得分，得分数值不进行变换
reduction_method <- "UMAP"
result_dir <- "test_result"
result_name_prefix <- "test"
att_gene_list <- c("PDCD1","LAG3","CTLA4")
title_label <- "exhaustion_gene"
legend_label <- "exhaustion gene score"
group_by <- "No"
analysis_type <- "gene score"
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,att_gene_list=att_gene_list,
            title_label=title_label,legend_label=legend_label,group_by=group_by)

## 分组绘制一组耗竭基因的得分，得分数值不进行变换
reduction_method <- "UMAP"
result_dir <- "test_result"
result_name_prefix <- "test"
att_gene_list <- c("PDCD1","LAG3","CTLA4")
title_label <- "exhaustion_gene"
legend_label <- "exhaustion gene score"
group_by <- "group_name"
group_item_level <- c("IA","IT","IC","HC")
analysis_type <- "gene score"
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,att_gene_list=att_gene_list,
            title_label=title_label,legend_label=legend_label,group_by=group_by,group_item_level=group_item_level)

## 根据一组active gene将细胞区分为2类，分组绘制两类细胞
reduction_method <- "UMAP"
result_dir <- "test_result"
result_name_prefix <- "test"
active_gene_list <- c("PDCD1")
title_label <- "PDCD1"
legend_label <- "PDCD1 status"
group_by <- "group_name"
group_item_level <- c("IA","IT","IC","HC")
analysis_type <- "gene combination"
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,active_gene_list=active_gene_list,
            title_label=title_label,legend_label=legend_label,group_by=group_by,group_item_level=group_item_level)

## 根据一组active gene将细胞区分为2类，不分组绘制两类细胞
reduction_method <- "UMAP"
result_dir <- "test_result"
result_name_prefix <- "test"
active_gene_list <- c("PDCD1")
title_label <- "PDCD1"
legend_label <- "PDCD1 status"
group_by <- "No"
analysis_type <- "gene combination"
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,active_gene_list=active_gene_list,
            title_label=title_label,legend_label=legend_label,group_by=group_by)

```



