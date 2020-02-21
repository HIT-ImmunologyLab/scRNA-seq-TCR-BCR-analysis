## 单细胞测序分析流程
### 基础流程
**Workflow** 如图所示：

![example-workflow](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/example-workflow.png)

CellRanger安装使用，结果解读，详见Cell Ranger文档（https://github.com/hitzhangfan/NCP-scRNA-seq/blob/master/Cell%20Ranger.md）。
#### cellranger 数据拆分
 mkfastq可用于将单细胞测序获得的 BCL 文件拆分为可以识别的 fastq 测序数据

```
cellranger makefastq   --run=[ ]   --samplesheet=[sample.csv] --jobmode=local --localcores=20 --localmem=80
```

```
-–run ：是下机数据 BCL 所在的路径；
-–samplesheet ：样品信息列表--共三列（lane id ,sample name ,index name)
```
#### cellranger 数据统计
cellranger count是 cellranger 最主要也是最重要的功能：完成细胞和基因的定量，也就是产生了我们用来做各种分析的基因表达矩阵。

```
cellranger count \
-–id=sample345 \
-–transcriptome=/opt/refdata-cellranger-GRCh38-1.2.0/GRCh38 \
-–fastqs=/home/jdoe/runs/HAWT7ADXX/outs/fastq_path \
-–indices=SI-3A-A1 \
–-cells=1000
```

```
id ：产生的结果都在这个文件中，可以取几号样品（如 sample345）；

fastqs ：由 cellranger mkfastq 产生的 fastqs 文件夹所在的路径；

indices：sample index：SI-3A-A1；

transcriptome：参考转录组文件路径；

cells：预期回复的细胞数；
```
### 下游分析
cellranger count 计算的结果只能作为初步观测的结果，如果需要进一步分析聚类细胞，还需要进行下游分析，这里使用官方推荐 R 包（Seurat）

# Seurat  #
Seurat is an R package designed for quality control(QC), analysis, and exploration of single-cell RNA-seq data.<br>
(1) the selection and filtration of cells based on QC metrics<br>
(2) data normalization and scaling<br>
(3) the detection of highly variable features.<br>
We can use **Seurat** to get cell subtypes and marker genes，more details can be seen in https://satijalab.org/seurat/vignettes.html

## Install ##
Enter commands in R (or Rstudio, if installed)<br>

    install.packages('Seurat')
    library(Seurat)

## Standard Analysis Process ##
- step1: Import single cell dataset and create Seurat objects
- step2: Seurat filtering, setting thresholds to remove technical errors, and selecting appropriate single-cell expression data
- step3: Data standardization (standardization method: LogNormalize)
- step4: Feature selection, according to the algorithm, select the genes that best reflect the overall data results and information.
- step5: Normalization (一方面使得细胞间的平均表达量为0，另一方面使得细胞间的差异为1)
- step6: Data dimensionality reduction, based on normalized data, runs a non-linear dimensionality reduction algorithm PCA
- step7: Cell clustering, dividing cell populations based on expression similarity. The realization method is based on the PC selected by the previous principal component analysis and clustering based on the graph theory method.
- step8: Visualization of dimensionality reduction results, including PCA, t-SNE, UMAP
- step9: Finding cluster-specific genes
- step10: Annotated cell cluster

## Usage ##
- step1:Setup the Seurat Object,the input is the output of the cellranger pipeline from 10X, returning a unique molecular identified (UMI) count matrix

        pbmc.data <- Read10X(data.dir = "../seurat/pbmc3k")
        #Initialize the Seurat object with the raw (non-normalized data)
		pbmc <- CreateSeuratObject(counts = pbmc.data, project = "pbmc3k", min.cells = 10,min.features = 30)

- step2:Standard the pre-processing workflow, 数据筛选，每个细胞表达基因的阈值

        #PercentageFeatureSet calculates the percentage of counts originating from a set of features
    	#We use the set of all genes starting with MT- as a set of mitochondrial genes
		pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")
    	#We filter cells that have unique feature counts over 2,500 or less than 200
    	#We filter cells that have >5% mitochondrial counts
    	pbmc <- subset(pbmc, subset = nFeature_RNA > 200 & nFeature_RNA < 2500 & percent.mt < 5)

- step3:Normalizing the data ,标准化

    `pbmc <- NormalizeData(pbmc, normalization.method = "LogNormalize", scale.factor = 10000)`

- step4:Identification of highly variable features (feature selection),特征选择

        ##a subset of features that exhibit high cell-to-cell variation in the dataset (i.e, they are highly expressed in some cells, and lowly expressed in others).we return 2,000 features per dataset.
        pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)
		## Identify the 10 most highly variable genes
		top10 <- head(VariableFeatures(pbmc), 10)
		## plot variable features with and without labels
		plot1 <- VariableFeaturePlot(pbmc)
		plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
		CombinePlots(plots = list(plot1, plot2))
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/images/seurat_selection_variable_feature.png)

- step5:Scaling the data, 归一化

        all.genes <- rownames(pbmc)
        pbmc <- ScaleData(pbmc, features = all.genes)

- step6:Perform linear dimensional reduction, PCA降维

        #perform PCA on the scaled data. By default, only the previously determined variable features are used as input, but can be defined using features argument if you wish to choose a different subset.
        pbmc <- RunPCA(pbmc, features = VariableFeatures(object = pbmc))
        # Examine and visualize PCA results a few different ways
        print(pbmc[["pca"]], dims = 1:5, nfeatures = 5)
        VizDimLoadings(pbmc, dims = 1:2, reduction = "pca")
        DimPlot(pbmc, reduction = "pca")
        #DimHeatmap allows for easy exploration of the primary sources of heterogeneity in a dataset, and can be useful when trying to decide which PCs to include for further downstream analyses.
        DimHeatmap(pbmc, dims = 1, cells = 500, balanced = TRUE)
        DimHeatmap(pbmc, dims = 1:15, cells = 500, balanced = TRUE)


- step7:Determine the ‘dimensionality’ of the dataset,dentify ‘significant’ PCs as those who have a strong enrichment of low p-value features, PCA 降维可视化

        pbmc <- JackStraw(pbmc, num.replicate = 100)
        pbmc <- ScoreJackStraw(pbmc, dims = 1:20)
        #JackStrawPlot function provides a visualization tool for comparing the distribution of p-values for each PC with a uniform distribution (dashed line). ‘Significant’ PCs will show a strong enrichment of features with low p-values
        JackStrawPlot(pbmc, dims = 1:15)
        # ‘Elbow plot’: a ranking of principle components based on the percentage of variance explained by each one
        ElbowPlot(pbmc)


- step8:Cluster the cells, 细胞聚类

        pbmc <- FindNeighbors(pbmc, dims = 1:10)
        pbmc <- FindClusters(pbmc, resolution = 0.5)
        ## Look at cluster IDs of the first 5 cells
        head(Idents(pbmc), 5)
        #Run non-linear dimensional reduction (UMAP/tSNE)
        pbmc <- RunUMAP(pbmc, dims = 1:10)
        # plot to see individual clusters
        DimPlot(pbmc, reduction = "umap")
        #save pbmc variable
        saveRDS(pbmc, file = "../output/pbmc_tutorial.rds")
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/images/seurat_cell_cluster.png)    

- step9:Finding differentially expressed features (cluster biomarkers), 选择marker gene 
    

	    # find all markers of cluster 1
        cluster1.markers <- FindMarkers(pbmc, ident.1 = 1, min.pct = 0.25)
        head(cluster1.markers, n = 5)
        # find all markers distinguishing cluster 5 from clusters 0 and 3
        cluster5.markers <- FindMarkers(pbmc, ident.1 = 5, ident.2 = c(0, 3), min.pct = 0.25)
        head(cluster5.markers, n = 5)
        # find markers for every cluster compared to all remaining cells, report only the positive ones
        pbmc.markers <- FindAllMarkers(pbmc, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
        pbmc.markers %>% group_by(cluster) %>% top_n(n = 2, wt = avg_logFC)
        VlnPlot(pbmc, features = c("MS4A1", "CD79A"))
        # you can plot raw counts as well
        VlnPlot(pbmc, features = c("NKG7", "PF4"), slot = "counts", log = TRUE)
        FeaturePlot(pbmc, features = c("MS4A1", "GNLY", "CD3E", "CD14", "FCER1A", "FCGR3A", "LYZ", "PPBP","CD8A"))
        #DoHeatmap generates an expression heatmap for given cells and features.
        top10 <- pbmc.markers %>% group_by(cluster) %>% top_n(n = 10, wt = avg_logFC)
        DoHeatmap(pbmc, features = top10$gene) + NoLegend()
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/images/seurat_expression_heatmap.png)



- step10:Assigning cell type identity to clusters, 细胞亚型分类注释


        new.cluster.ids <- c("Naive CD4 T", "Memory CD4 T", "CD14+ Mono", "B", "CD8 T", "FCGR3A+ Mono", "NK", "DC", "Platelet")
        names(new.cluster.ids) <- levels(pbmc)
        pbmc <- RenameIdents(pbmc, new.cluster.ids)
        DimPlot(pbmc, reduction = "umap", label = TRUE, pt.size = 0.5) + NoLegend()
        saveRDS(pbmc, file = "../output/pbmc3k_final.rds")
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/images/seurat_cell_type_classification.png) 


## 伪时间分析
伪时间分析建议采用 monocle3.0 软件
### 软件安装
```{r}
##安装依赖
BiocManager::install(c('BiocGenerics','DelayedArray', 'DelayedMatrixStats','limma', 'S4Vectors', 'SingleCellExperiment','SummarizedExperiment', 'batchelor'))
##安装monocle3
devtools::install_github('cole-trapnell-lab/leidenbase')
devtools::install_github('cole-trapnell-lab/monocle3')
library(monocle3)
```
### 标准分析流
```{r}
library(Seurat)
library(monocle3)
endo<-readRDS("../output/pbmc_tutorial.rds")
data <- endo@assays$RNA@counts
pd <-  endo@meta.data
```
不要直接把meta.data放入pd中去，太多没用的信息了，先清理下
```{r}
new_pd<-select(pd,nCount_RNA,nFeature_RNA,percent.mt)
new_pd$Cell.type<-Idents(endo)
head(new_pd)
                      nCount_RNA nFeature_RNA percent.mt
AAACCTGGTATCAGTC-1_1      4835         1383   3.536711
AACCGCGCATTCCTGC-1_1      4029         1230   2.655746
AACGTTGAGCCCAATT-1_1      2576          918   3.377329
AAGACCTGTGGTTTCA-1_1      2841         1044   5.455825
AAGTCTGCATGAAGTA-1_1      3731         1213   3.886358
ACAGCCGCATCGGACC-1_1      5915         1918   3.043111
                                     Cell.type
AAACCTGGTATCAGTC-1_1                       DC2
AACCGCGCATTCCTGC-1_1                      MDSC
AACGTTGAGCCCAATT-1_1                      MDSC
AAGACCTGTGGTTTCA-1_1 Dendritic.cells.activated
AAGTCTGCATGAAGTA-1_1                      MDSC
ACAGCCGCATCGGACC-1_1 Dendritic.cells.activated

fData <- data.frame(gene_short_name = row.names(data), row.names = row.names(data))
```
生成monocle的cds对象
```{r}
cds <- new_cell_data_set(data,cell_metadata  = new_pd,gene_metadata  = fData)
```
运行下游标准流程，无论如何都得跑，是必须的默认流程
```{r}
cds <- preprocess_cds(cds, num_dim = 30)
#umap
cds <- reduce_dimension(cds,umap.n_neighbors = 20L)
#color by seurat cluster
plot_cells(cds,label_groups_by_cluster=FALSE,color_cells_by = "Cell.type")
```
![markdown](https://github.com/ccgBiotechLover/single-cell-course/raw/master/monocle%20figures/fig10.png "markdown")

```{r}
#cluster
cds <- cluster_cells(cds,resolution = 0.5)
#color by monocle cluster
plot_cells(cds, color_cells_by = "partition",label_groups_by_cluster=FALSE)
```
![markdown](https://github.com/ccgBiotechLover/single-cell-course/raw/master/monocle%20figures/fig11.webp "markdown")

```{r}
cds <- learn_graph(cds)
plot_cells(cds,color_cells_by = "Cell.type",label_groups_by_cluster=FALSE,label_leaves=TRUE,label_branch_points=TRUE)
```
![markdown](https://github.com/ccgBiotechLover/single-cell-course/raw/master/monocle%20figures/fig12.webp "markdown")

### 定义时间开始节点&&伪时间分析
```{r}
##一个有用的寻找起源节点的函数
get_earliest_principal_node <- function(cds, time_bin="Dendritic.cells.activated"){
  cell_ids <- which(colData(cds)[, "Cell.type"] == time_bin)
  closest_vertex <-
  cds@principal_graph_aux[["UMAP"]]$pr_graph_cell_proj_closest_vertex
  closest_vertex <- as.matrix(closest_vertex[colnames(cds), ])
  root_pr_nodes <-
  igraph::V(principal_graph(cds)[["UMAP"]])$name[as.numeric(names
  (which.max(table(closest_vertex[cell_ids,]))))]
  root_pr_nodes
}

#order cell
cds <- order_cells(cds, root_pr_nodes=get_earliest_principal_node(cds))
#pseudotime analysis
plot_cells(cds,color_cells_by = "pseudotime",label_cell_groups=FALSE,label_leaves=FALSE,label_branch_points=FALSE,graph_label_size=1.5)
```
![markdown](https://github.com/ccgBiotechLover/single-cell-course/raw/master/monocle%20figures/fig13.webp "markdown")

PS:对多样本进行伪时间分析，请参考[使用Monocle3对多样本单细胞数据进行伪时间分析](https://www.hongguangblog.cn/archives/48/ "普通链接带标题")

其他教程链接：
[整合刺激性和对照性PBMC数据集，以学习细胞类型特异性反应](https://www.hongguangblog.cn/archives/79/ "普通链接带标题")

[10X单细胞数据针对细胞及其亚型的基因集功能分析和转录调控分析](https://www.hongguangblog.cn/archives/13/ "普通链接带标题")

Reference:<https://www.hongguangblog.cn/archives/6/>

## Marker基因定义细胞亚群
由于不同的研究目的关注的细胞类型也不一样，一般基本分析结果中的细胞聚类是基于细胞间的表达相似情况进行的，并标记为cluster0,1,2……n；因此，对于单细胞转录组的分析结果，第一步也是非常重要的一步就是对聚类的cluster进行细胞亚型鉴定。

一般情况下，我们根据亚群上调表达的基因进行细胞亚型鉴定，基本分析结果中也展示了每个亚群差异倍数top10的基因小提琴图和tsne图，但很多时候鉴定细胞的基因往往不在top10的基因中，而每个亚群所有上调表达的基因又非常多。因此，细胞类型鉴定更多的是依赖人工的解读过程。

以**小鼠的外周血**(**PBMC**)样本为例，详细讲述下细胞亚型的鉴定方法。

通过基本分析，我们可以获得下图细胞聚类tsne图，该样本共获得14个（0-13）亚群，但每个cluster对应的细胞亚群我们如何鉴定呢？

![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/cellmarker_7.jfif)
### Step1 搜集样本中细胞类型及标记基因
通过已发表文献或者细胞标志物数据库CellMarker（官网：http://biocc.hrbmu.edu.cn/CellMarker/#）对样本中的细胞类型以及标记基因（需要注意的是，已报道的标记基因仅能说明这些基因在目标细胞中高表达，但并非在其他细胞中完全不表达，因此在细胞鉴定时往往需要多个标记基因共同才能确定）进行搜集。具体的搜集方法如下：

a.进入CellMarker官网，选择研究的物种及相应的组织，点击其中一类细胞进行查看；
![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/cellmarker_1.jfif)

b.以T细胞为例，细胞对应的marker及支持材料数量（从高往低排序）；
![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/cellmarker_2.jfif)

下表为按照上述方法从CellMarker（除了上面获得marker基因外，CellMarker还可以进行基因的搜索及其他功能，具体的可以查看：CellMarker：单细胞转录组测序定义细胞群体之利器 | 单细胞转录组专题）中提取的部分小鼠血液样本细胞类型及对应的marker基因（值得注意的是橙色标出的marker基因为在不同细胞类型中均表达量较高的基因，在后续的细胞亚型鉴定时选择细胞特异性表达的marker基因）：
![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/cellmarker_3.jfif)

### Step2 判断marker基因在各亚群中的表达情况

以B细胞marker基因CD19和Cd79b为例，我们结合小提琴图和tSNE映射图查看maker基因在各亚群中的表达情况，来判断具体哪些cluster亚群为B细胞。

a.基因表达小提琴图

小提琴图横坐标为对应的细胞聚类tSNE图的cluster信息，纵坐标为相应marker基因的表达情况，图中的点代表细胞，从图中我们可以看到cluster0,2,3,5,6,10,13中大部分细胞均高表达CD19和Cd79b基因。可初步判断，cluster0,2,3,5,6,10,13为B细胞，当cluster和细胞特别多时，通过小提琴图没办法直接判断marker基因具体在哪些cluster中表达，可以同时结合marker基因在tSNE图（图b）进行细胞分类。
![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/cellmarker_4.jfif)

b.基因表达tSNE映射图

基因表达tSNE映射图与细胞分类tSNE图中细胞对应的位置是一样的（图b中的点代表细胞），只是着色的方案不同，细胞分类tSNE图是按照细胞分类进行着色区分，基因表达tSNE图是按照目标基因在细胞中的表达高低进行着色，其中灰色表示目标基因在该细胞中不表达或表达量比较低，蓝色代表目标基因在该细胞中表达且颜色越深表达量越高。从图b中我们可以看出，CD19和Cd79b两个marker基因均集中在散点图的上半部分表达，对应细胞分类tSNE图，我们可以发现对应的cluster为0,2,3,5,6,10,13（即为图c左图红框圈出的部分）。
![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/cellmarker_5.jfif)

结合基因表达小提琴图和TSNE映射图，我们可以判断cluster0,2,3,5,6,10,13即为B细胞。

### Step3 鉴定其他细胞
使用相同的方法分别将T细胞，NK细胞，monocyte细胞，macropahage细胞鉴定出来，结果详见图中左图。从鉴定结果来看，cluster11使用已有的标记基因均未被鉴定到（这种可能是一种全新的未被报道的亚群，是后续关注的重点），而B细胞，T细胞分为很多亚类，对于这种情况有两种方式进行处理，方式一：基于B细胞，T细胞其他特异性表达基因，对两者进一步细分；方式二：将相同的细胞进行合并，统一标为T细胞或B细胞（图中右图），后续再单独将T细胞或B细胞挑出再次进行细分
![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/cellmarker_6.jfif)

Reference: http://www.360doc31.net/wxarticlenew/846311936.html