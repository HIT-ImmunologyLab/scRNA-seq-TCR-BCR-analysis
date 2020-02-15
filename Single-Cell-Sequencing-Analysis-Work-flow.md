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

        pbmc.data <- Read10X(data.dir = "../seurat/seurat-master/tests/testdata/cr3.0")
        #Initialize the Seurat object with the raw (non-normalized data)
		pbmc <- CreateSeuratObject(counts = pbmc.data$`Gene Expression`, project = "pbmc3k", min.cells = 10,min.features = 30)

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
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/seurat_selection_variable_feature.png)

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
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/seurat_cell_cluster.png)    

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
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/seurat_expression_heatmap.png)



- step10:Assigning cell type identity to clusters, 细胞亚型分类注释


        new.cluster.ids <- c("Naive CD4 T", "Memory CD4 T", "CD14+ Mono", "B", "CD8 T", "FCGR3A+ Mono", "NK", "DC", "Platelet")
        names(new.cluster.ids) <- levels(pbmc)
        pbmc <- RenameIdents(pbmc, new.cluster.ids)
        DimPlot(pbmc, reduction = "umap", label = TRUE, pt.size = 0.5) + NoLegend()
        saveRDS(pbmc, file = "../output/pbmc3k_final.rds")
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/seurat_cell_type_classification.png) 


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
