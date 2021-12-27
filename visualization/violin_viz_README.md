## Violion_viz

**单细胞转录组数据，按照指定的分组(cluster,group,指定的一组基因)，可视化感兴趣基因在不同组中的分布，并检验指定组之间是否存在显着差异**

violin_viz(

seurat_object,

att_gene_list,

group_by,

result_dir,

result_name_perfix,

group_by_level_list=c(),

active_gene_list=c(),

inhibit_gene_list=c(),

my_comparisons=list()

)

**Arguments**

**seurat_object**: Seurat object

**att_gene_list**: 感兴趣的基因列表

**group_by**：分组的标签，可设置为seurat_clusters,group_name,manual_celltype等，若按照特定一组基因进行分组，标签设置为gene_list，当设置为gene_list时，要设置active_gene_list和（或）inhibit_gene_list

**result_dir**：结果目录

**result_name_perfix**：结果文件名前缀

**group_by_level_list**：分组绘图时的顺序，比如group，可指定顺序为（IA，IT，IC，HC），也可以不指定，不指定的话按字典序排序

**active_gene_list**: 有表达的基因列表，当分组标签不是gene_list时，不需要指定，若分组标签是gene_list，可以指定，可以不指定，但active_gene_list和inhibit_gene_list必须有一个指定

**inhibit_gene_list**：不表达的基因列表，当分组标签不是gene_list时，不需要指定，若分组标签是gene_list，可以指定，可以不指定，但active_gene_list和inhibit_gene_list必须有一个指定

**my_comparisons**：做检验的分组，比如list(c("IA","HC"),c("IT","HC"))，如果不知道，枚举法没有分组的两两组合情况，如果做组合数大于10，只画前10个

## Example

```
## 按cluster分组
seurat_rds_file <- "donor_seurat_UMAP.rds"
seurat_object <- readRDS(seurat_rds_file)
att_gene_list <- c("GZMB","GZMK","NCAM1","CTLA4","LAG3")
group_by <- "seurat_clusters"
result_dir <- "cluster_result"
result_name_perfix <- "cluster"
violin_viz(seurat_object,att_gene_list,group_by,result_dir,result_name_perfix)

## 按group分组，指定做检验的分组，指定绘图顺序
seurat_rds_file <- "donor_seurat_UMAP.rds"
seurat_object <- readRDS(seurat_rds_file)
att_gene_list <- c("GZMB","GZMK","NCAM1","CTLA4","LAG3")
group_by <- "group_name"
result_dir <- "group_result"
result_name_perfix <- "group"
my_comparisons <- list(c("IA","HC"),c("IT","HC"),c("IC","HC"))
group_by_level_list <- c("IA","IT","IC","HC")
violin_viz(seurat_object,att_gene_list,group_by,result_dir,result_name_perfix,group_by_level_list,my_comparisons)

## 按照指定的基因分组
seurat_rds_file <- "donor_seurat_UMAP.rds"
seurat_object <- readRDS(seurat_rds_file)
att_gene_list <- c("GZMB","GZMK","NCAM1","CTLA4","LAG3")
group_by <- "gene_list"
active_gene_list <- c("CD8A","CD8B")
inhibit_gene_list <- c("CD4")
result_dir <- "gene_list_result"
result_name_perfix <- "gene_list"
violin_viz(seurat_object,att_gene_list,group_by,result_dir,result_name_perfix,active_gene_list,inhibit_gene_list)
```



