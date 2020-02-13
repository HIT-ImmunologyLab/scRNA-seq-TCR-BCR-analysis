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

Seurat 的安装，使用，结果分析详见Seurat文档

