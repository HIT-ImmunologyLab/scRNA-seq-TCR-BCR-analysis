suppressMessages(library(Seurat))
suppressMessages(library(ggplot2))
suppressMessages(library(GGally))
suppressMessages(library(ggpubr))
suppressMessages(library(ggvenn))
suppressMessages(library(mrggsave))

boxplot_viz <- function(seurat_object,att_gene,group_by,group_level_list=c(),my_comparisons=c()){
  all_gene_expression <- seurat_object@assays$RNA@data
  if(group_by=="all"){
    data_for_plot <- data.frame(barcodes=rownames(seurat_object@meta.data),
                                gene_expt=all_gene_expression[att_gene,rownames(seurat_object@meta.data)],
                                group_by=rep("all",nrow(seurat_object@meta.data)))
    data_for_plot$gene_expt <- as.numeric(as.character(data_for_plot$gene_expt))
    p <- ggplot(data_for_plot)+
      geom_boxplot(aes(x=group_by,y=gene_expt,color=group_by),outlier.color = NA)+
      geom_jitter(aes(x=group_by,y=gene_expt,color=group_by),size=0.1,width = 0.1,height = 0)+
      theme_bw()+
      theme(axis.text.x.bottom = element_text(angle = 45,hjust = 1,vjust = 1),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank())
  }else{
    data_for_plot <- data.frame(barcodes=rownames(seurat_object@meta.data),
                                gene_expt=all_gene_expression[att_gene,rownames(seurat_object@meta.data)],
                                group_by=seurat_object@meta.data[rownames(seurat_object@meta.data),group_by])
    data_for_plot$group_by <- factor(data_for_plot$group_by,group_level_list)
    data_for_plot$gene_expt <- as.numeric(as.character(data_for_plot$gene_expt))
    group_list <- unique(as.character(data_for_plot$group_by))
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
    
    p <- ggplot(data_for_plot)+
      geom_boxplot(aes(x=group_by,y=gene_expt,color=group_by),outlier.color = NA)+
      geom_jitter(aes(x=group_by,y=gene_expt,color=group_by),size=0.1,width = 0.1,height = 0)+
      theme_bw()+
      theme(axis.text.x.bottom = element_text(angle = 45,hjust = 1,vjust = 1),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank())+
      geom_signif(aes(x=group_by,y=gene_expt),comparisons = my_comparisons,step_increase = 0.1,map_signif_level = F,
                  test = wilcox.test,size=0.5,textsize = 4)
  }
  
  
  return(p)
}

dotplot_viz <- function(seurat_object,gene_first,gene_second,group_by="all"){
  all_gene_expression <- seurat_object@assays$RNA@data
  att_gene_expression <- all_gene_expression[c(gene_first,gene_second),]
  first_gene_expressed_barcodes <- colnames(all_gene_expression)[all_gene_expression[gene_first,]>0]
  second_gene_expressed_barcodes <- colnames(all_gene_expression)[all_gene_expression[gene_second,]>0]
  plot_cell_barcode <- intersect(first_gene_expressed_barcodes,second_gene_expressed_barcodes)
  att_gene_expressed_matrix <- t(as.matrix(att_gene_expression[,plot_cell_barcode]))
  colnames(att_gene_expressed_matrix) <- c("att_first_gene","att_second_gene")
  
  data_for_plot <- as.data.frame(att_gene_expressed_matrix)
  if(group_by=="all"){
    p <- ggplot(data_for_plot,aes(x=att_first_gene,y=att_second_gene))+
      geom_point(size=2)+
      geom_smooth(method=lm,se=FALSE,fullrange=TRUE)+
      # stat_cor(aes(x=att_first_gene,y=att_second_gene),method="spearman",
      #          label.x = mean(as.numeric(as.character(data_for_plot$att_first_gene))),
      #          label.y = mean(as.numeric(as.character(data_for_plot$att_second_gene))))+
      stat_cor(aes(x=att_first_gene,y=att_second_gene),method="spearman")+
      theme_bw()+
      theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
      xlab(gene_first)+
      ylab(gene_second)
  }else{
    data_for_plot[rownames(data_for_plot),"color_name"] <- seurat_object@meta.data[rownames(data_for_plot),group_by]
    p <- ggplot(data_for_plot,aes(x=att_first_gene,y=att_second_gene,color=color_name))+
      geom_point(size=2)+
      geom_smooth(method=lm,se=FALSE,fullrange=TRUE)+
      # stat_cor(aes(x=att_first_gene,y=att_second_gene),method="spearman",
      #          label.x = mean(as.numeric(as.character(data_for_plot$att_first_gene))),
      #          label.y = mean(as.numeric(as.character(data_for_plot$att_second_gene))))+
      stat_cor(aes(x=att_first_gene,y=att_second_gene,color=color_name),method="spearman")+
      theme_bw()+
      theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
      xlab(gene_first)+
      ylab(gene_second)
  }
  
  
  
  return(p)
}

venn_viz <- function(seurat_object,gene_first,gene_second){
  all_gene_expression <- seurat_object@assays$RNA@data
  att_gene_expression <- all_gene_expression[c(gene_first,gene_second),]
  first_gene_expressed_barcodes <- colnames(all_gene_expression)[all_gene_expression[gene_first,]>0]
  second_gene_expressed_barcodes <- colnames(all_gene_expression)[all_gene_expression[gene_second,]>0]
  # p <- venn.diagram(x = list(first_gene_expressed_barcodes,second_gene_expressed_barcodes),
  #                   category.names = c(paste(gene_first," expressed cells",sep = ""), paste(gene_second," expressed cells",sep = "")), 
  #                   fill=c("#EABC5A","#DEAAF2"),
  #                   alpha=c(0.5,0.5), cex=1, cat.fontface=3,filename = NULL)
  barcode_list <- list(first_gene_expressed_barcodes,second_gene_expressed_barcodes)
  names(barcode_list) <- c(paste(gene_first,sep = ""), paste(gene_second,sep = ""))
  p <- ggvenn(barcode_list, 
         c(paste(gene_first,sep = ""), paste(gene_second,sep = "")),
         fill_color = c("#EABC5A","#DEAAF2"),
         set_name_color =c("#EABC5A","#DEAAF2")) 
  return(p)
}

gene_corr_analysis <- function(seurat_object,result_dir,result_filename_prefix,att_gene_list=c(),analysis_type="all",att_var_name="",att_var_value_list=c(),group_by="group_name",group_item_level=c(),active_gene_list=c(),inhibit_gene_list=c(),my_comparisons=c(),script_path=""){
  ## 1. 提取出关注的特定细胞
  if(analysis_type == "exist column"){
    att_cell_barcode <- rownames(seurat_object@meta.data[which(as.character(seurat_object@meta.data[,att_var_name]) %in% att_var_value_list),])
  }else if(analysis_type == "gene combination"){
    if(length(active_gene_list)>0 | length(inhibit_gene_list)>0){
      union_gene_list <- union(active_gene_list,inhibit_gene_list)
      all_gene_expression <- seurat_object@assays$RNA@data
      status_gene_exist_list <- intersect(union_gene_list,rownames(all_gene_expression))
      if(length(status_gene_exist_list)==1){
        status_gene_expression <- data.frame(gene=all_gene_expression[status_gene_exist_list[1],])
        status_gene_expression <- t(as.matrix(status_gene_expression))
        rownames(status_gene_expression) <- status_gene_exist_list
        colnames(status_gene_expression) <- colnames(all_gene_expression)
        
      }else{
        status_gene_expression <- all_gene_expression[status_gene_exist_list,]
      }
      if(length(active_gene_list)>0){
        active_barcode <- colnames(status_gene_expression)
        for(i in 1:length(active_gene_list)){
          cur_att_barcode <- colnames(status_gene_expression)[status_gene_expression[active_gene_list[i],]>0]
          active_barcode <- intersect(cur_att_barcode,active_barcode)
        }
      }else{
        active_barcode <- c()
      }
      
      if(length(inhibit_gene_list) > 0){
        inhibit_barcode <- colnames(status_gene_expression)
        for(i in 1:length(inhibit_gene_list)){
          cur_att_barcode <- colnames(status_gene_expression)[status_gene_expression[inhibit_gene_list[i],]==0]
          inhibit_barcode <- intersect(cur_att_barcode,inhibit_barcode)
        }
      }else{
        inhibit_barcode <- c()
      }
      
      if(length(active_barcode)==0){
        att_cell_barcode <- inhibit_barcode
      }else if(length(inhibit_barcode)==0){
        att_cell_barcode <- active_barcode
      }else{
        att_cell_barcode <- intersect(active_barcode,inhibit_barcode)
      }
    }
  }else if(analysis_type == "all"){
    att_cell_barcode <- rownames(seurat_object@meta.data)
  }
  att_seurat_object <- subset(seurat_object,cells=att_cell_barcode)
  
  ## 2. 关注的基因在特定的关注的细胞中的相关性分析
  all_gene_expression <- att_seurat_object@assays$RNA@data
  att_exist_gene_list <- intersect(att_gene_list,rownames(all_gene_expression))
  plot_list <- list()
  index <- 1
  for(i in 1:length(att_exist_gene_list)){
    for(j in 1:length(att_exist_gene_list)){
      ## 分3种情况：
      ## 在下三角，绘制这两个基因散点图，添加拟合曲线和相关性数值，p值
      ## 在对角线，按照分组绘制当前基因在不同分组的boxplot，添加显著性检验
      ## 在上三角，绘制这两个基因，表达的细胞的分布的韦恩图
      if(i<j){
        ## 上三角:韦恩图
        p <- venn_viz(att_seurat_object,att_exist_gene_list[i],att_exist_gene_list[j])
        plot_list[[index]] <- p
      }else if(i==j){
        p <- boxplot_viz(att_seurat_object,att_exist_gene_list[i],group_by,group_item_level,my_comparisons)
        plot_list[[index]] <- p
        ## 对角线
      }else if(i>j){
        ## 下三角：散点图
        p <- dotplot_viz(att_seurat_object,att_exist_gene_list[i],att_exist_gene_list[j],group_by)
        plot_list[[index]] <- p
      }
      index <- index + 1
    }
  }
  print(length(plot_list))
  row_num <- length(att_exist_gene_list)
  col_num <- row_num
  pm <- ggmatrix(plot_list, row_num, col_num,xAxisLabels = att_exist_gene_list, yAxisLabels=att_exist_gene_list)

  mrggsave(pm,script=script_path,width = 5*row_num,height = 5*col_num,dir=result_dir,stem=result_filename_prefix,dev="png")
}


###################################### main ###########################################
seurat_rds_file <- "/home/ganr/Fan/HBV_liver_new/NKT_add_nan_cells_recluster_res_1.5_dim_50/filter_confused_cells_UMAP/donor_seurat_UMAP.rds"
seurat_object <- readRDS(seurat_rds_file)

result_dir <- "/home/zhoufx/test_pipeline/test_correlation_analysis"
result_filename_prefix <- "test"
att_gene_list <- c("CD8A","CD8B","PDCD1","CTLA4","TOX","CD4")
analysis_type <- "all"
group_item_level <- c("IA","IT","IC","HC")
group_by <- "group_name"
my_comparisons <- list(c("IA","HC"),c("IT","HC"),c("IC","HC"))
gene_corr_analysis(seurat_object,result_dir,result_filename_prefix,att_gene_list,analysis_type=analysis_type,group_by=group_by,group_item_level=group_item_level,my_comparisons=my_comparisons)


result_dir <- "/home/zhoufx/test_pipeline/test_correlation_analysis"
result_filename_prefix <- "test_all"
att_gene_list <- c("CD8A","CD8B","PDCD1","CTLA4","TOX","CD4")
analysis_type <- "all"
group_by <- "all"
gene_corr_analysis(seurat_object,result_dir,result_filename_prefix,att_gene_list,analysis_type=analysis_type,group_by=group_by)

result_dir <- "/home/zhoufx/test_pipeline/test_correlation_analysis"
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
				   
result_dir <- "/home/zhoufx/test_pipeline/test_correlation_analysis"
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
