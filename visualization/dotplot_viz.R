suppressMessages(library(Seurat))
suppressMessages(library(ggplot2))
suppressMessages(library(ggpubr))
suppressMessages(library(RColorBrewer))



plot_dotplot_col_item<- function(plot_data,title_label,x_label,y_label,xlim_min,xlim_max,ylim_min,ylim_max,scale_min,scale_max,legend_label,att_var_cont,num_transfor,group_by,group_item_level,result_dir,result_name_prefix,color_list=c()){
  if(xlim_min==""|xlim_max==""|ylim_min==""|ylim_max==""){
    if(att_var_cont=="Yes"){
      if(num_transfor== "sqrt"){
        plot_data$att_values <- sqrt(as.numeric(as.character(plot_data$att_values)))
        if(group_by == "No"){
          ggplot(plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
            geom_point(size=0.1)+
            # scale_color_continuous(low="#0A85D9",high="#FC011A")+
            scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
            theme_bw()+
            theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
            ggtitle(label = title_label)+
            theme(plot.title = element_text(hjust = 0.5))+
            xlab(x_label)+
            ylab(y_label)+
            # guides(color=guide_legend(title = legend_label))
            labs(color=legend_label)
          save_file <- paste(result_dir,"/",result_name_prefix,"_sqrt_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6,height = 5,limitsize = F)
        }else{
          plist <- apply(as.matrix(group_item_level),1,function(x){
            cur_plot_data <- plot_data[which(plot_data$group_var==x),]
            ggplot(cur_plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
              geom_point(size=0.1)+
              # scale_color_continuous(low="#0A85D9",high="#FC011A")+
              scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
              theme_bw()+
              theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
              ggtitle(label = x)+
              theme(plot.title = element_text(hjust = 0.5))+
              xlab(x_label)+
              ylab(y_label)+
              # guides(color=guide_legend(title = legend_label))
              labs(color=legend_label)
          })
          row_num <- ceiling(sqrt(length(group_item_level)))
          col_num <- ceiling(sqrt(length(group_item_level)))
          do.call(ggarrange,c(plist,nrow=row_num,ncol=col_num))
          save_file <- paste(result_dir,"/",result_name_prefix,"_sqrt_group_by_",group_by,"_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6*col_num,height = 5*row_num,limitsize = F)
        }
        
      }else if(num_transfor== "log2"){
        save_file <- paste(result_dir,"/",result_name_prefix,"_log2_dotplot.pdf",sep = "")
        plot_data$att_values <- log2(as.numeric(as.character(plot_data$att_values)))
        if(group_by == "No"){
          ggplot(plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
            geom_point(size=0.1)+
            # scale_color_continuous(low="#0A85D9",high="#FC011A")+
            scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
            theme_bw()+
            theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
            ggtitle(label = title_label)+
            theme(plot.title = element_text(hjust = 0.5))+
            labs(color=legend_label)+
            xlab(x_label)+
            ylab(y_label)
          ggsave(save_file,width = 6,height = 5,limitsize = F)
        }else{
          plist <- apply(as.matrix(group_item_level),1,function(x){
            cur_plot_data <- plot_data[which(plot_data$group_var==x),]
            ggplot(cur_plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
              geom_point(size=0.1)+
              # scale_color_continuous(low="#0A85D9",high="#FC011A")+
              scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
              theme_bw()+
              theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
              theme(legend.title = legend_label)+
              ggtitle(label = x)+
              theme(plot.title = element_text(hjust = 0.5))+
              labs(color=legend_label)+
              xlab(x_label)+
              ylab(y_label)
          })
          row_num <- ceiling(sqrt(length(group_item_level)))
          col_num <- ceiling(sqrt(length(group_item_level)))
          do.call(ggarrange,c(plist,nrow=row_num,ncol=col_num))
          save_file <- paste(result_dir,"/",result_name_prefix,"_log2_group_by_",group_by,"_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6*col_num,height = 5*row_num,limitsize = F)
        }
      }else if(num_transfor== "log10"){
        
        plot_data$att_values <- log10(as.numeric(as.character(plot_data$att_values)))
        if(group_by == "No"){
          ggplot(plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
            geom_point(size=0.1)+
            # scale_color_continuous(low="#0A85D9",high="#FC011A")+
            scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
            theme_bw()+
            theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
            ggtitle(label = title_label)+
            theme(plot.title = element_text(hjust = 0.5))+
            labs(color=legend_label)+
            xlab(x_label)+
            ylab(y_label)
          save_file <- paste(result_dir,"/",result_name_prefix,"_log10_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6,height = 5,limitsize = F)
        }else{
          plist <- apply(as.matrix(group_item_level),1,function(x){
            cur_plot_data <- plot_data[which(plot_data$group_var==x),]
            ggplot(cur_plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
              geom_point(size=0.1)+
              # scale_color_continuous(low="#0A85D9",high="#FC011A")+
              scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
              theme_bw()+
              theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
              ggtitle(label = x)+
              theme(plot.title = element_text(hjust = 0.5))+
              labs(color=legend_label)+
              xlab(x_label)+
              ylab(y_label)
          })
          row_num <- ceiling(sqrt(length(group_item_level)))
          col_num <- ceiling(sqrt(length(group_item_level)))
          do.call(ggarrange,c(plist,nrow=row_num,ncol=col_num))
          save_file <- paste(result_dir,"/",result_name_prefix,"_log10_group_by_",group_by,"_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6*col_num,height = 5*row_num,limitsize = F)
        }
      }else if(num_transfor== "No"){
        if(group_by == "No"){
          ggplot(plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
            geom_point(size=0.1)+
            # scale_color_continuous(low="#0A85D9",high="#FC011A")+
            scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
            theme_bw()+
            theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
            ggtitle(label = title_label)+
            theme(plot.title = element_text(hjust = 0.5))+
            labs(color=legend_label)+
            xlab(x_label)+
            ylab(y_label)
          save_file <- paste(result_dir,"/",result_name_prefix,"_raw_value_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6,height = 5,limitsize = F)
        }else{
          plist <- apply(as.matrix(group_item_level),1,function(x){
            cur_plot_data <- plot_data[which(plot_data$group_var==x),]
            ggplot(cur_plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
              geom_point(size=0.1)+
              # scale_color_continuous(low="#0A85D9",high="#FC011A")+
              scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
              theme_bw()+
              theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
              ggtitle(label = x)+
              theme(plot.title = element_text(hjust = 0.5))+
              labs(color=legend_label)+
              xlab(x_label)+
              ylab(y_label)
          })
          row_num <- ceiling(sqrt(length(group_item_level)))
          col_num <- ceiling(sqrt(length(group_item_level)))
          do.call(ggarrange,c(plist,nrow=row_num,ncol=col_num))
          save_file <- paste(result_dir,"/",result_name_prefix,"_raw_value_group_by_",group_by,"_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6*col_num,height = 5*row_num,limitsize = F)
        }
      }
    }else if(att_var_cont=="No"){
      if(length(color_list)==0){
        color_num <- length(unique(as.character(plot_data$att_values)))
        getPalette <- colorRampPalette(brewer.pal(9,"Set1"))
        color_list <- getPalette(color_num)
      }
      
      
      if(group_by == "No"){
        ggplot(plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
          geom_point(size=0.1)+
          scale_color_manual(values = color_list)+
          theme_bw()+
          theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
          ggtitle(label = title_label)+
          theme(plot.title = element_text(hjust = 0.5))+
          labs(color=legend_label)+
          xlab(x_label)+
          ylab(y_label)
        save_file <- paste(result_dir,"/",result_name_prefix,"_discrete_dotplot.pdf",sep = "")
        ggsave(save_file,width = 6,height = 5,limitsize = F)
      }else{
        plist <- apply(as.matrix(group_item_level),1,function(x){
          cur_plot_data <- plot_data[which(plot_data$group_var==x),]
          ggplot(cur_plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
            geom_point(size=0.1)+
            scale_color_manual(values = getPalette(color_num))+
            theme_bw()+
            theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
            ggtitle(label = x)+
            theme(plot.title = element_text(hjust = 0.5))+
            labs(color=legend_label)+
            xlab(x_label)+
            ylab(y_label)
        })
        row_num <- ceiling(sqrt(length(group_item_level)))
        col_num <- ceiling(sqrt(length(group_item_level)))
        do.call(ggarrange,c(plist,nrow=row_num,ncol=col_num))
        save_file <- paste(result_dir,"/",result_name_prefix,"_discrete_group_by_",group_by,"_dotplot.pdf",sep = "")
        ggsave(save_file,width = 6*col_num,height = 5*row_num,limitsize = F)
      }
    }
  }else{
    if(att_var_cont=="Yes"){
      if(num_transfor== "sqrt"){
        plot_data$att_values <- sqrt(as.numeric(as.character(plot_data$att_values)))
        if(group_by == "No"){
          ggplot(plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
            geom_point(size=0.1)+
            # scale_color_continuous(low="#0A85D9",high="#FC011A")+
            scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
            theme_bw()+
            theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
            ggtitle(label = title_label)+
            theme(plot.title = element_text(hjust = 0.5))+
            xlab(x_label)+
            ylab(y_label)+
            xlim(as.numeric(xlim_min),as.numeric(xlim_max))+
            ylim(as.numeric(ylim_min),as.numeric(ylim_max))+
            # guides(color=guide_legend(title = legend_label))
            labs(color=legend_label)
          save_file <- paste(result_dir,"/",result_name_prefix,"_sqrt_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6,height = 5,limitsize = F)
        }else{
          plist <- apply(as.matrix(group_item_level),1,function(x){
            cur_plot_data <- plot_data[which(plot_data$group_var==x),]
            ggplot(cur_plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
              geom_point(size=0.1)+
              # scale_color_continuous(low="#0A85D9",high="#FC011A")+
              scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
              theme_bw()+
              theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
              ggtitle(label = x)+
              theme(plot.title = element_text(hjust = 0.5))+
              xlab(x_label)+
              ylab(y_label)+
              xlim(as.numeric(xlim_min),as.numeric(xlim_max))+
              ylim(as.numeric(ylim_min),as.numeric(ylim_max))+
              # guides(color=guide_legend(title = legend_label))
              labs(color=legend_label)
          })
          row_num <- ceiling(sqrt(length(group_item_level)))
          col_num <- ceiling(sqrt(length(group_item_level)))
          do.call(ggarrange,c(plist,nrow=row_num,ncol=col_num))
          save_file <- paste(result_dir,"/",result_name_prefix,"_sqrt_group_by_",group_by,"_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6*col_num,height = 5*row_num,limitsize = F)
        }
        
      }else if(num_transfor== "log2"){
        save_file <- paste(result_dir,"/",result_name_prefix,"_log2_dotplot.pdf",sep = "")
        plot_data$att_values <- log2(as.numeric(as.character(plot_data$att_values)))
        if(group_by == "No"){
          ggplot(plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
            geom_point(size=0.1)+
            # scale_color_continuous(low="#0A85D9",high="#FC011A")+
            scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
            theme_bw()+
            theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
            ggtitle(label = title_label)+
            theme(plot.title = element_text(hjust = 0.5))+
            labs(color=legend_label)+
            xlab(x_label)+
            ylab(y_label)+
            xlim(as.numeric(xlim_min),as.numeric(xlim_max))+
            ylim(as.numeric(ylim_min),as.numeric(ylim_max))
          ggsave(save_file,width = 6,height = 5,limitsize = F)
        }else{
          plist <- apply(as.matrix(group_item_level),1,function(x){
            cur_plot_data <- plot_data[which(plot_data$group_var==x),]
            ggplot(cur_plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
              geom_point(size=0.1)+
              # scale_color_continuous(low="#0A85D9",high="#FC011A")+
              scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
              theme_bw()+
              theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
              theme(legend.title = legend_label)+
              ggtitle(label = x)+
              theme(plot.title = element_text(hjust = 0.5))+
              labs(color=legend_label)+
              xlab(x_label)+
              ylab(y_label)+
              xlim(as.numeric(xlim_min),as.numeric(xlim_max))+
              ylim(as.numeric(ylim_min),as.numeric(ylim_max))
          })
          row_num <- ceiling(sqrt(length(group_item_level)))
          col_num <- ceiling(sqrt(length(group_item_level)))
          do.call(ggarrange,c(plist,nrow=row_num,ncol=col_num))
          save_file <- paste(result_dir,"/",result_name_prefix,"_log2_group_by_",group_by,"_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6*col_num,height = 5*row_num,limitsize = F)
        }
      }else if(num_transfor== "log10"){
        
        plot_data$att_values <- log10(as.numeric(as.character(plot_data$att_values)))
        if(group_by == "No"){
          ggplot(plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
            geom_point(size=0.1)+
            # scale_color_continuous(low="#0A85D9",high="#FC011A")+
            scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
            theme_bw()+
            theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
            ggtitle(label = title_label)+
            theme(plot.title = element_text(hjust = 0.5))+
            labs(color=legend_label)+
            xlab(x_label)+
            ylab(y_label)+
            xlim(as.numeric(xlim_min),as.numeric(xlim_max))+
            ylim(as.numeric(ylim_min),as.numeric(ylim_max))
          save_file <- paste(result_dir,"/",result_name_prefix,"_log10_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6,height = 5,limitsize = F)
        }else{
          plist <- apply(as.matrix(group_item_level),1,function(x){
            cur_plot_data <- plot_data[which(plot_data$group_var==x),]
            ggplot(cur_plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
              geom_point(size=0.1)+
              # scale_color_continuous(low="#0A85D9",high="#FC011A")+
              scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
              theme_bw()+
              theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
              ggtitle(label = x)+
              theme(plot.title = element_text(hjust = 0.5))+
              labs(color=legend_label)+
              xlab(x_label)+
              ylab(y_label)+
              xlim(as.numeric(xlim_min),as.numeric(xlim_max))+
              ylim(as.numeric(ylim_min),as.numeric(ylim_max))
          })
          row_num <- ceiling(sqrt(length(group_item_level)))
          col_num <- ceiling(sqrt(length(group_item_level)))
          do.call(ggarrange,c(plist,nrow=row_num,ncol=col_num))
          save_file <- paste(result_dir,"/",result_name_prefix,"_log10_group_by_",group_by,"_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6*col_num,height = 5*row_num,limitsize = F)
        }
      }else if(num_transfor== "No"){
        if(group_by == "No"){
          ggplot(plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
            geom_point(size=0.1)+
            # scale_color_continuous(low="#0A85D9",high="#FC011A")+
            scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
            theme_bw()+
            theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
            ggtitle(label = title_label)+
            theme(plot.title = element_text(hjust = 0.5))+
            labs(color=legend_label)+
            xlab(x_label)+
            ylab(y_label)+
            xlim(as.numeric(xlim_min),as.numeric(xlim_max))+
            ylim(as.numeric(ylim_min),as.numeric(ylim_max))
          save_file <- paste(result_dir,"/",result_name_prefix,"_raw_value_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6,height = 5,limitsize = F)
        }else{
          plist <- apply(as.matrix(group_item_level),1,function(x){
            cur_plot_data <- plot_data[which(plot_data$group_var==x),]
            ggplot(cur_plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
              geom_point(size=0.1)+
              # scale_color_continuous(low="#0A85D9",high="#FC011A")+
              scale_color_gradientn(colours = colorRampPalette(rev(brewer.pal(11,'Spectral')))(32),limits=c(as.numeric(scale_min),as.numeric(scale_max)))+
              theme_bw()+
              theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
              ggtitle(label = x)+
              theme(plot.title = element_text(hjust = 0.5))+
              labs(color=legend_label)+
              xlab(x_label)+
              ylab(y_label)+
              xlim(as.numeric(xlim_min),as.numeric(xlim_max))+
              ylim(as.numeric(ylim_min),as.numeric(ylim_max))
          })
          row_num <- ceiling(sqrt(length(group_item_level)))
          col_num <- ceiling(sqrt(length(group_item_level)))
          do.call(ggarrange,c(plist,nrow=row_num,ncol=col_num))
          save_file <- paste(result_dir,"/",result_name_prefix,"_raw_value_group_by_",group_by,"_dotplot.pdf",sep = "")
          ggsave(save_file,width = 6*col_num,height = 5*row_num,limitsize = F)
        }
      }
    }else if(att_var_cont=="No"){
      if(length(color_list)==0){
        color_num <- length(unique(as.character(plot_data$att_values)))
        getPalette <- colorRampPalette(brewer.pal(9,"Set1"))
        color_list <- getPalette(color_num)
      }
      
      
      if(group_by == "No"){
        ggplot(plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
          geom_point(size=0.1)+
          scale_color_manual(values = color_list)+
          theme_bw()+
          theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
          ggtitle(label = title_label)+
          theme(plot.title = element_text(hjust = 0.5))+
          labs(color=legend_label)+
          xlab(x_label)+
          ylab(y_label)+
          xlim(as.numeric(xlim_min),as.numeric(xlim_max))+
          ylim(as.numeric(ylim_min),as.numeric(ylim_max))
        save_file <- paste(result_dir,"/",result_name_prefix,"_discrete_dotplot.pdf",sep = "")
        ggsave(save_file,width = 6,height = 5,limitsize = F)
      }else{
        plist <- apply(as.matrix(group_item_level),1,function(x){
          cur_plot_data <- plot_data[which(plot_data$group_var==x),]
          ggplot(cur_plot_data,aes(x=x_coord,y=y_coord,color=att_values))+
            geom_point(size=0.1)+
            scale_color_manual(values = getPalette(color_num))+
            theme_bw()+
            theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())+
            ggtitle(label = x)+
            theme(plot.title = element_text(hjust = 0.5))+
            labs(color=legend_label)+
            xlab(x_label)+
            ylab(y_label)+
            xlim(as.numeric(xlim_min),as.numeric(xlim_max))+
            ylim(as.numeric(ylim_min),as.numeric(ylim_max))
        })
        row_num <- ceiling(sqrt(length(group_item_level)))
        col_num <- ceiling(sqrt(length(group_item_level)))
        do.call(ggarrange,c(plist,nrow=row_num,ncol=col_num))
        save_file <- paste(result_dir,"/",result_name_prefix,"_discrete_group_by_",group_by,"_dotplot.pdf",sep = "")
        ggsave(save_file,width = 6*col_num,height = 5*row_num,limitsize = F)
      }
    }
  }
}

dotplot_viz <- function(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,xlim_min="",xlim_max="",ylim_min="",ylim_max="",scale_min="",scale_max="",att_gene_list=c(),active_gene_list=c(),inhibit_gene_list=c(),att_var_name="",att_var_cont="No",title_label="",legend_label="",num_transfor="No",group_by="group_name",group_item_level){
  if(analysis_type == "exist column"){
    if(att_var_name != ""){
      if(reduction_method == "UMAP"){
        if(group_by=="No"){
          plot_data <- data.frame(cell_barcode=rownames(seurat_object@meta.data),
                                  UMAP_1=seurat_object@meta.data$UMAP_1,
                                  UMAP_2=seurat_object@meta.data$UMAP_2,
                                  att_values=seurat_object@meta.data[rownames(seurat_object@meta.data),att_var_name])
          colnames(plot_data) <- c('cell_barcode','x_coord','y_coord','att_values')
        }else{
          plot_data <- data.frame(cell_barcode=rownames(seurat_object@meta.data),
                                  UMAP_1=seurat_object@meta.data$UMAP_1,
                                  UMAP_2=seurat_object@meta.data$UMAP_2,
                                  att_values=seurat_object@meta.data[rownames(seurat_object@meta.data),att_var_name],
                                  group_var=seurat_object@meta.data[rownames(seurat_object@meta.data),group_by])
          colnames(plot_data) <- c('cell_barcode','x_coord','y_coord','att_values','group_var')
        }
        
        x_label <- "UMAP_1"
        y_label <- "UMAP_2"
      }else if(reduction_method == "TSNE"){
        if(group_by=="No"){
          plot_data <- data.frame(cell_barcode=rownames(seurat_object@meta.data),
                                  TSNE_1=seurat_object@meta.data$TSNE_1,
                                  TSNE_2=seurat_object@meta.data$TSNE_2,
                                  att_values=seurat_object@meta.data[rownames(seurat_object@meta.data),att_var_name])
          colnames(plot_data) <- c('cell_barcode','x_coord','y_coord','att_values')
        }else{
          plot_data <- data.frame(cell_barcode=rownames(seurat_object@meta.data),
                                  TSNE_1=seurat_object@meta.data$TSNE_1,
                                  TSNE_2=seurat_object@meta.data$TSNE_2,
                                  att_values=seurat_object@meta.data[rownames(seurat_object@meta.data),att_var_name],
                                  group_var=seurat_object@meta.data[rownames(seurat_object@meta.data),group_by])
          colnames(plot_data) <- c('cell_barcode','x_coord','y_coord','att_values','group_var')
        }
        
        x_label <- "TSNE_1"
        y_label <- "TSNE_2"
      }
      if(title_label==""){
        title_label <- att_var_name 
      }
      if(legend_label==""){
        legend_label <- att_var_name
      }
      cur_result_name_prefix <- paste(result_name_prefix,"_exist_column_",att_var_name,sep = "")
      plot_dotplot_col_item(plot_data,title_label,x_label,y_label,xlim_min,xlim_max,ylim_min,ylim_max,scale_min,scale_max,legend_label,att_var_cont,num_transfor,group_by,group_item_level,result_dir,cur_result_name_prefix)
    }
  }
 
  if(analysis_type == "gene score"){
    if(length(att_gene_list)>0){
      gene_cell_data_matrix <- seurat_object@assays$RNA@data
      interset_gene_list <- intersect(rownames(gene_cell_data_matrix),att_gene_list)
      diff_gene_list <- setdiff(att_gene_list,rownames(gene_cell_data_matrix))
      print(diff_gene_list)
      if(length(interset_gene_list)==1){
        att_gene_cell_data_data <- data.frame(gene=gene_cell_data_matrix[interset_gene_list[1],])
        att_gene_cell_data_matrix <- as.matrix(att_gene_cell_data_data)
        att_gene_cell_data_matrix <- t(att_gene_cell_data_matrix)
        rownames(att_gene_cell_data_matrix) <- interset_gene_list
        colnames(att_gene_cell_data_matrix) <- colnames(gene_cell_data_matrix)
      }else{
        att_gene_cell_data_matrix <- gene_cell_data_matrix[interset_gene_list,]
      }
      seurat_object@meta.data[rownames(seurat_object@meta.data),"att_gene_score"] <- as.character(apply(as.matrix(att_gene_cell_data_matrix[,rownames(seurat_object@meta.data)]),2,function(x){
        # cur_score <- 1/2*as.numeric(quantile(x, 0.5))+1/4*(as.numeric(quantile(x, 0.25))+as.numeric(quantile(x, 0.75)))
        cur_score <- mean(x)
      }))
      
      if(reduction_method == "UMAP"){
        if(group_by=="No"){
          plot_data <- data.frame(cell_barcode=rownames(seurat_object@meta.data),
                                  UMAP_1=seurat_object@meta.data$UMAP_1,
                                  UMAP_2=seurat_object@meta.data$UMAP_2,
                                  att_values=seurat_object@meta.data[rownames(seurat_object@meta.data),"att_gene_score"])
          colnames(plot_data) <- c('cell_barcode','x_coord','y_coord','att_values')
        }else{
          plot_data <- data.frame(cell_barcode=rownames(seurat_object@meta.data),
                                  UMAP_1=seurat_object@meta.data$UMAP_1,
                                  UMAP_2=seurat_object@meta.data$UMAP_2,
                                  att_values=seurat_object@meta.data[rownames(seurat_object@meta.data),"att_gene_score"],
                                  group_var=seurat_object@meta.data[rownames(seurat_object@meta.data),group_by])
          colnames(plot_data) <- c('cell_barcode','x_coord','y_coord','att_values','group_var')
        }
        
        x_label <- "UMAP_1"
        y_label <- "UMAP_2"
      }else if(reduction_method == "TSNE"){
        if(group_by=="No"){
          plot_data <- data.frame(cell_barcode=rownames(seurat_object@meta.data),
                                  TSNE_1=seurat_object@meta.data$TSNE_1,
                                  TSNE_2=seurat_object@meta.data$TSNE_2,
                                  att_values=seurat_object@meta.data[rownames(seurat_object@meta.data),"att_gene_score"])
          colnames(plot_data) <- c('cell_barcode','x_coord','y_coord','att_values')
        }else{
          plot_data <- data.frame(cell_barcode=rownames(seurat_object@meta.data),
                                  TSNE_1=seurat_object@meta.data$TSNE_1,
                                  TSNE_2=seurat_object@meta.data$TSNE_2,
                                  att_values=seurat_object@meta.data[rownames(seurat_object@meta.data),"att_gene_score"],
                                  group_var=seurat_object@meta.data[rownames(seurat_object@meta.data),group_by])
          colnames(plot_data) <- c('cell_barcode','x_coord','y_coord','att_values','group_var')
        }
        
        x_label <- "TSNE_1"
        y_label <- "TSNE_2"
      }
      
      if(title_label==""){
        title_label <- att_var_name 
      }
      if(legend_label==""){
        legend_label <- att_var_name
      }
      plot_data$att_values <- as.numeric(as.character(plot_data$att_values))
      cur_result_name_prefix <- paste(result_name_prefix,"_att_gene_score",sep = "")
      att_var_cont <- "Yes"
      plot_dotplot_col_item(plot_data,title_label,x_label,y_label,xlim_min,xlim_max,ylim_min,ylim_max,scale_min,scale_max,legend_label,att_var_cont,num_transfor,group_by,group_item_level,result_dir,cur_result_name_prefix)
    }
  }
  
  if(analysis_type == "gene combination"){
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
      seurat_object@meta.data[rownames(seurat_object@meta.data),"att_genes_group"] <- "Att gene negative"
      seurat_object@meta.data[att_cell_barcode,"att_genes_group"] <- "Att gene positive"
      
      if(reduction_method == "UMAP"){
        if(group_by=="No"){
          plot_data <- data.frame(cell_barcode=rownames(seurat_object@meta.data),
                                  UMAP_1=seurat_object@meta.data$UMAP_1,
                                  UMAP_2=seurat_object@meta.data$UMAP_2,
                                  att_values=seurat_object@meta.data[rownames(seurat_object@meta.data),"att_genes_group"])
          colnames(plot_data) <- c('cell_barcode','x_coord','y_coord','att_values')
        }else{
          plot_data <- data.frame(cell_barcode=rownames(seurat_object@meta.data),
                                  UMAP_1=seurat_object@meta.data$UMAP_1,
                                  UMAP_2=seurat_object@meta.data$UMAP_2,
                                  att_values=seurat_object@meta.data[rownames(seurat_object@meta.data),"att_genes_group"],
                                  group_var=seurat_object@meta.data[rownames(seurat_object@meta.data),group_by])
          colnames(plot_data) <- c('cell_barcode','x_coord','y_coord','att_values','group_var')
        }
        
        x_label <- "UMAP_1"
        y_label <- "UMAP_2"
      }else if(reduction_method == "TSNE"){
        if(group_by=="No"){
          plot_data <- data.frame(cell_barcode=rownames(seurat_object@meta.data),
                                  TSNE_1=seurat_object@meta.data$TSNE_1,
                                  TSNE_2=seurat_object@meta.data$TSNE_2,
                                  att_values=seurat_object@meta.data[rownames(seurat_object@meta.data),"att_genes_group"])
          colnames(plot_data) <- c('cell_barcode','x_coord','y_coord','att_values')
        }else{
          plot_data <- data.frame(cell_barcode=rownames(seurat_object@meta.data),
                                  TSNE_1=seurat_object@meta.data$TSNE_1,
                                  TSNE_2=seurat_object@meta.data$TSNE_2,
                                  att_values=seurat_object@meta.data[rownames(seurat_object@meta.data),"att_genes_group"],
                                  group_var=seurat_object@meta.data[rownames(seurat_object@meta.data),group_by])
          colnames(plot_data) <- c('cell_barcode','x_coord','y_coord','att_values','group_var')
        }
        
        x_label <- "TSNE_1"
        y_label <- "TSNE_2"
      }
      
      if(title_label==""){
        title_label <- att_var_name 
      }
      if(legend_label==""){
        legend_label <- att_var_name
      }
      plot_data$att_values <- factor(plot_data$att_values,levels = c("Att gene positive","Att gene negative"))
      cur_result_name_prefix <- paste(result_name_prefix,"_att_gene_combination",sep = "")
      att_var_cont <- "No"
      num_transfor <- "No"
      color_list <- c("#E41A1C","0xff808080")
      plot_dotplot_col_item(plot_data,title_label,x_label,y_label,xlim_min,xlim_max,ylim_min,ylim_max,scale_min,scale_max,legend_label,att_var_cont,num_transfor,group_by,group_item_level,result_dir,cur_result_name_prefix,color_list)
    }
  }
  
}


############################################# main function #####################################################
seurat_rds_file <- "/home/ganr/Fan/HBV_liver_new/NKT_add_nan_cells_recluster_res_1.5_dim_50/filter_confused_cells_UMAP/donor_seurat_UMAP.rds"
seurat_object <- readRDS(seurat_rds_file)

reduction_method <- "UMAP"
result_dir <- "/home/zhoufx/test_pipeline/test_dotplot"
result_name_prefix <- "test"
att_var_name <- "clonotype_freq"
att_var_cont <- "Yes"
title_label <- "clonotype_freq"
legend_label <- "clonotype_freq"
group_by <- "group_name"
group_item_level <- c("IA","IT","IC","HC")
analysis_type <- "exist column"
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,title_label=title_label,att_var_name=att_var_name,
            att_var_cont=att_var_cont,legend_label=legend_label,group_by=group_by,group_item_level=group_item_level)
xlim_min <- -6
xlim_max <- 6
ylim_min <- -7
ylim_max <- 13
scale_min <- -1
scale_max <- 1000
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,xlim_min=xlim_min,xlim_max=xlim_max,
            ylim_min=ylim_min,ylim_max=ylim_max,scale_min=scale_min,scale_max=scale_max,title_label=title_label,att_var_name=att_var_name,
            att_var_cont=att_var_cont,legend_label=legend_label,group_by=group_by,group_item_level=group_item_level)


reduction_method <- "UMAP"
result_dir <- "/home/zhoufx/test_pipeline/test_dotplot"
result_name_prefix <- "test"
att_var_name <- "seurat_clusters"
att_var_cont <- "No"
title_label <- "seurat_clusters"
legend_label <- "seurat_clusters"
group_by <- "No"
analysis_type <- "exist column"
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,title_label=title_label,att_var_name=att_var_name,
            att_var_cont=att_var_cont,legend_label=legend_label,group_by=group_by)

reduction_method <- "UMAP"
result_dir <- "/home/zhoufx/test_pipeline/test_dotplot"
result_name_prefix <- "test"
att_var_name <- "nCount_RNA"
att_var_cont <- "Yes"
title_label <- "nCount_RNA"
legend_label <- "nCount_RNA"
num_transfor <- "sqrt"
group_by <- "group_name"
group_item_level <- c("IA","IT","IC","HC")
analysis_type <- "exist column"
xlim_min <- -6
xlim_max <- 6
ylim_min <- -7
ylim_max <- 13
scale_min <- -1
scale_max <- 10000
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,
            xlim_min=xlim_min,xlim_max=xlim_max,ylim_min=ylim_min,ylim_max=ylim_max,scale_min=scale_min,scale_max=scale_max,
            title_label=title_label,att_var_name=att_var_name,
            att_var_cont=att_var_cont,legend_label=legend_label,num_transfor=num_transfor,group_by=group_by,group_item_level=group_item_level)

reduction_method <- "UMAP"
result_dir <- "/home/zhoufx/test_pipeline/test_dotplot"
result_name_prefix <- "test"
att_gene_list <- c("PDCD1","LAG3","CTLA4")
title_label <- "exhaustion_gene"
legend_label <- "exhaustion gene score"
group_by <- "No"
analysis_type <- "gene score"
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,att_gene_list=att_gene_list,
            title_label=title_label,legend_label=legend_label,group_by=group_by)

reduction_method <- "UMAP"
result_dir <- "/home/zhoufx/test_pipeline/test_dotplot"
result_name_prefix <- "test"
att_gene_list <- c("PDCD1","LAG3","CTLA4")
title_label <- "exhaustion_gene"
legend_label <- "exhaustion gene score"
group_by <- "group_name"
group_item_level <- c("IA","IT","IC","HC")
analysis_type <- "gene score"
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,att_gene_list=att_gene_list,
            title_label=title_label,legend_label=legend_label,group_by=group_by,group_item_level=group_item_level)


reduction_method <- "UMAP"
result_dir <- "/home/zhoufx/test_pipeline/test_dotplot"
result_name_prefix <- "test"
active_gene_list <- c("PDCD1")
title_label <- "PDCD1"
legend_label <- "PDCD1 status"
group_by <- "group_name"
group_item_level <- c("IA","IT","IC","HC")
analysis_type <- "gene combination"
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,active_gene_list=active_gene_list,
            title_label=title_label,legend_label=legend_label,group_by=group_by,group_item_level=group_item_level)

reduction_method <- "UMAP"
result_dir <- "/home/zhoufx/test_pipeline/test_dotplot"
result_name_prefix <- "test"
active_gene_list <- c("PDCD1")
title_label <- "PDCD1"
legend_label <- "PDCD1 status"
group_by <- "No"
analysis_type <- "gene combination"
dotplot_viz(seurat_object,reduction_method,result_dir,result_name_prefix,analysis_type,active_gene_list=active_gene_list,
            title_label=title_label,legend_label=legend_label,group_by=group_by)
