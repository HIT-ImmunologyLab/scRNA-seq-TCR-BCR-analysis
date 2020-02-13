# NCP-scRNA-seq
single-cell sequencing,TCR analysis,scRNA-sequencing
The analysis process of single-cell and TCR based on scRNA sequencing

# Seurat  #
Seurat is an R package designed for quality control(QC), analysis, and exploration of single-cell RNA-seq data.<br>
(1) the selection and filtration of cells based on QC metrics<br>
(2) data normalization and scaling<br>
(3) the detection of highly variable features.<br>
We can use **Seurat** to get cell subtypes and marker genes

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

- step2:Standard the pre-processing workflow

        #PercentageFeatureSet calculates the percentage of counts originating from a set of features
    	#We use the set of all genes starting with MT- as a set of mitochondrial genes
		pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")
    	#We filter cells that have unique feature counts over 2,500 or less than 200
    	#We filter cells that have >5% mitochondrial counts
    	pbmc <- subset(pbmc, subset = nFeature_RNA > 200 & nFeature_RNA < 2500 & percent.mt < 5)

- step3:Normalizing the data

    `pbmc <- NormalizeData(pbmc, normalization.method = "LogNormalize", scale.factor = 10000)`

- step4:Identification of highly variable features (feature selection)

        ##a subset of features that exhibit high cell-to-cell variation in the dataset (i.e, they are highly expressed in some cells, and lowly expressed in others).we return 2,000 features per dataset.
        pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)
		## Identify the 10 most highly variable genes
		top10 <- head(VariableFeatures(pbmc), 10)
		## plot variable features with and without labels
		plot1 <- VariableFeaturePlot(pbmc)
		plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
		CombinePlots(plots = list(plot1, plot2))
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/seurat_selection_variable_feature.png)

- step5:Scaling the data

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


- step7:Determine the ‘dimensionality’ of the dataset,dentify ‘significant’ PCs as those who have a strong enrichment of low p-value features. 

        pbmc <- JackStraw(pbmc, num.replicate = 100)
        pbmc <- ScoreJackStraw(pbmc, dims = 1:20)
        #JackStrawPlot function provides a visualization tool for comparing the distribution of p-values for each PC with a uniform distribution (dashed line). ‘Significant’ PCs will show a strong enrichment of features with low p-values
        JackStrawPlot(pbmc, dims = 1:15)
        # ‘Elbow plot’: a ranking of principle components based on the percentage of variance explained by each one
        ElbowPlot(pbmc)


- step8:Cluster the cells，细胞聚类

        pbmc <- FindNeighbors(pbmc, dims = 1:10)
        pbmc <- FindClusters(pbmc, resolution = 0.5)
        ## Look at cluster IDs of the first 5 cells
        head(Idents(pbmc), 5)
        #Run non-linear dimensional reduction (UMAP/tSNE)，可视化的非线性降维
        pbmc <- RunUMAP(pbmc, dims = 1:10)
        # plot to see individual clusters
        DimPlot(pbmc, reduction = "umap")
        #save pbmc variable
        saveRDS(pbmc, file = "../output/pbmc_tutorial.rds")
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/seurat_cell_cluster.png)    

- step9:Finding differentially expressed features (cluster biomarkers) ，选择marker gene   
    

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

- step10:Assigning cell type identity to clusters，细胞亚型注释


        new.cluster.ids <- c("Naive CD4 T", "Memory CD4 T", "CD14+ Mono", "B", "CD8 T", "FCGR3A+ Mono", "NK", "DC", "Platelet")
        names(new.cluster.ids) <- levels(pbmc)
        pbmc <- RenameIdents(pbmc, new.cluster.ids)
        DimPlot(pbmc, reduction = "umap", label = TRUE, pt.size = 0.5) + NoLegend()
        saveRDS(pbmc, file = "../output/pbmc3k_final.rds")
![](https://github.com/gancao/NCP-scRNA-seq/blob/master/seurat_cell_type_classification.png)    

    



