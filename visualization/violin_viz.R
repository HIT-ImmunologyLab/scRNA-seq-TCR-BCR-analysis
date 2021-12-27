suppressMessages(library(Seurat))
suppressMessages(library(ggplot2))
suppressMessages(library(reshape2))
suppressMessages(library(ggpubr))

plot_att_gene_vlnplot <- function(att_gene_expression,result_dir,save_file_prefix,gene_num,color_name,my_comparisons){
  group_list <- unique(as.character(att_gene_expression$color_group))
  if(length(my_comparisons)==0){
    my_comparisons <- list()
    index <- 1
    for(i in 1:(length(group_list)-1)){
      for(j in (i+1):length(group_list)){
        my_comparisons[[index]] <- c(group_list[i],group_list[j])
        index <- index + 1
      }
    }
    if(length(my_comparisons)>10){
      my_comparisons <- my_comparisons[1:10]
    }
  }
  
  ggplot(att_gene_expression)+
    # geom_violin(aes(x=cell_seurat_clusters,y=gene_expression,fill=color_group))+
    geom_violin(aes(x=color_group,y=gene_expression,fill=color_group),width=1,position=position_dodge(1))+
    # geom_boxplot(aes(x=color_group,y=gene_expression),width=0.1,position=position_dodge(0.9),outlier.colour = NA,fill="white")+
    facet_wrap(att_gene_expression$gene_name~.,scales = "free_x",ncol = 1)+
    # scale_x_discrete("")+
    # scale_y_discrete("")+
    xlab("")+
    ylab("")+
    theme_bw()+
    theme(axis.text.x.bottom = element_text(angle = 45,hjust = 1,vjust = 1),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())+
    geom_signif(aes(x=color_group,y=gene_expression),comparisons = my_comparisons,step_increase = 0.1,map_signif_level = F,
                test = wilcox.test,size=0.5,textsize = 4)
  
  save_file <- paste(result_dir,"/",save_file_prefix,"_violin_color_by_",color_name,".pdf",sep = "")
  ggsave(save_file,width = max(3,length(group_list)*2),height = gene_num*3,limitsize = FALSE)
  
  save_file <- paste(result_dir,"/",save_file_prefix,"_expression_melt_color_by_",color_name,".csv",sep = "")
  write.csv(att_gene_expression,save_file,quote = F)
}

violin_viz <- function(seurat_object,att_gene_list,group_by,result_dir,result_name_perfix,group_by_level_list=c(),active_gene_list=c(),inhibit_gene_list=c(),my_comparisons=list()){
  ## get the whole gene expression matrix
  all_gene_expression <- seurat_object@assays$RNA@data
  ## get att gene expression dataframe
  att_exist_gene_list <- intersect(att_gene_list,rownames(all_gene_expression))
  print(setdiff(att_gene_list,rownames(all_gene_expression)))
  att_gene_expression <- all_gene_expression[att_exist_gene_list,]
  att_gene_expression <- data.frame(att_gene_expression)
  att_gene_expression$gene_name <- rownames(att_gene_expression)
  att_gene_expression_data <- melt(att_gene_expression)
  colnames(att_gene_expression_data) <- c("gene_name","cell_barcode","gene_expression")
  
  if(group_by=="gene_list"){
    union_gene_list <- union(active_gene_list,inhibit_gene_list)
    status_gene_exist_list <- intersect(union_gene_list,rownames(all_gene_expression))
    status_gene_expression <- all_gene_expression[status_gene_exist_list,]
    
    active_barcode <- colnames(status_gene_expression)
    for(i in 1:length(active_gene_list)){
      cur_att_barcode <- colnames(status_gene_expression)[status_gene_expression[active_gene_list[i],]>0]
      active_barcode <- intersect(cur_att_barcode,active_barcode)
    }
    inhibit_barcode <- colnames(status_gene_expression)
    for(i in 1:length(inhibit_gene_list)){
      cur_att_barcode <- colnames(status_gene_expression)[status_gene_expression[inhibit_gene_list[i],]==0]
      inhibit_barcode <- intersect(cur_att_barcode,inhibit_barcode)
    }
    att_cell_barcode <- intersect(active_barcode,inhibit_barcode)
    seurat_object@meta.data[rownames(seurat_object@meta.data),"att_genes_group"] <- "Att gene negative"
    seurat_object@meta.data[att_cell_barcode,"att_genes_group"] <- "Att gene positive"
    group_by <- "att_genes_group"
    group_by_level_list <- c("Att gene positive","Att gene negative")
    
  }
  if(length(group_by_level_list)==0){
    print("Alphabetical order")
    integer_var_list <- c("seurat_clusters")
    group_by_level_list <- unique(as.character(seurat_object@meta.data[,group_by]))
    if(group_by%in%integer_var_list){
      group_by_level_list <- group_by_level_list[order(as.numeric(group_by_level_list))]
    }else{
      group_by_level_list <- group_by_level_list[order(group_by_level_list)]
    }
  }
  celltype_data <- seurat_object@meta.data[,c("orig.ident",group_by)]
  barcode_list <- att_gene_expression_data[rownames(att_gene_expression_data),"cell_barcode"]
  att_gene_expression_data[rownames(att_gene_expression_data),"color_group"] <- celltype_data[barcode_list,group_by]
  att_gene_expression_data$color_group <- factor(att_gene_expression_data$color_group,levels = group_by_level_list)
  gene_num <- length(att_exist_gene_list)
  plot_att_gene_vlnplot(att_gene_expression_data,result_dir,result_name_perfix,gene_num,group_by,my_comparisons)
}

############################################# main function ############################################
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
