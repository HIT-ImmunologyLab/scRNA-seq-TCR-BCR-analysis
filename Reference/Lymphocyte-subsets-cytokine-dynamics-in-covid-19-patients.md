## COVID-19患者的淋巴细胞亚群、细胞因子动态变化，以及预测重症发展的最佳指标

2020年2月19日，华中科技大学同济医学院附属协和医院感染性疾病科Jing Liu等人在The Lancet Infectious Diseases发表了对COVID-19患者的**白细胞、T、B、NK以及T细胞亚群，还有细胞因子**，进行了16天以上的跟踪，这种纵向的监测，对于理解免疫过程，还是相当有帮助的，不过作者此文的目的，除了**总结轻症和重症患者变化的不同**之外，还**总结出了中性粒/CD8+T比例（简称N8R）和中性粒/淋巴比例（简称NLR）**，这两个指标**预测患者向重症发展的极佳指标**，N8R cut-off值21.9（特异度: 92.6%, 灵敏度: 84.6%），NLR cut-off值5.0（特异度96.3%，灵敏度84.6%。另外两个次选的预测指标为中性粒细胞绝对数（cut-off值3.2，特异度81.5%，灵敏度84.6%）和白细胞数量（cut-off值4.3，特异度74.1%，灵敏度84.6%）。

下面直接看图。

轻症患者（蓝色）和重症患者（红色）的**白细胞、中性粒细胞、淋巴细胞、单核细胞变化**，时间点为6个：

![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/Mild_and_Severe_patients.webp)

轻症患者（蓝色）和重症患者（红色）的**T细胞、细胞毒T细胞、辅助T细胞、B细胞的绝对数变化**：

![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/Mild_and_Severe_patients_T_cell.webp)

轻症患者（蓝色）和重症患者（红色）的I**L-6、IL-10、IL-2、IL-4、TNF-a、γ干扰素的变化**：

![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/Mild_and_Severe_patients_IL.webp)

对上述所有指标，进行PCA分析，发现N8R（中性粒细胞:CD8+T比值）和NLR（中性粒细胞:淋巴细胞比值）预测重症发展的意义最大，B图是各指标的ROC分析结果，反映的是指标的预测性能：

![image](https://github.com/fengxiaZhou/NCP-scRNA-seq/raw/master/images/PCA.webp)

## Reference
1. https://mp.weixin.qq.com/s/WS1ymHMgneSN5FoDgAJNrw
2. Longitudinal Characteristics of Lymphocyte Responses and Cytokine Profiles in the Peripheral Blood of SARS-CoV-2 Infected Patients