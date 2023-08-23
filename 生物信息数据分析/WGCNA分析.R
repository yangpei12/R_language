library("WGCNA")
library("glue")

## 全局设置
options(stringsAsFactors = FALSE)

## 结果输出路径
outdir <- "Output"
dir.create(file.path(outdir), showWarnings = FALSE)

## 读取表达谱文件
inData <- read.csv("Input/LiverFemale3600.txt", sep = "\t", row.names = 1, check.names = FALSE)
datExpRaw <- t(inData)


#=====================================================================================
#
#  过滤基因
#
#=====================================================================================

## 过滤缺失值过多的基因或者样本
gsg <- goodSamplesGenes(datExpRaw, minFraction = 0.5, verbose = 3)
datExprFiltered <- datExpRaw[gsg$goodSamples, gsg$goodGenes]
gsg$allOK

## 过滤信息输出
if(!gsg$allOK)
{
  if(sum(!gsg$goodGenes) > 0)
    printFlush(paste("Removing genes:", paste(colnames(datExpRaw)[!gsg$goodGenes], collapse = ",")));
  if(sum(!gsg$goodSamples) > 0)
    printFlush(paste("Removing samples:", paste(rownames(datExpRaw)[!gsg$goodSamples], collapse = ",")));
}

## 保存过滤后表达谱
datExprFilteredOut <- t(datExprFiltered)
write.table(datExprFilteredOut, file = glue("{outdir}/datExpr_gene_filtered.txt"), sep = "\t", quote = FALSE, row.names = TRUE, col.names = NA)


#=====================================================================================
#
#  剔除离群样本
#
#=====================================================================================

## 绘制样本聚类树
sampleTree <- hclust(dist(datExprFiltered), method = "average")

## 保存图片
pdf(file = glue("{outdir}/Sample_dendrogram_rm_outlier.pdf"), width = 12, height = 9)
par(cex = 0.6)
par(mar = c(2,5,5,1))
plot(sampleTree, main = "Sample clustering to detect outliers", 
     sub="", xlab="", cex.lab = 1.5, cex.axis = 1.5, cex.main = 2)
abline(h = 15, col = "red")
dev.off()

## 获取需要保留的样本(clust 1 contains the samples we want to keep)
clust <- cutreeStatic(sampleTree, cutHeight = 15, minSize = 10)
keepSamples <- (clust == 1)
datExpr <- datExprFiltered[keepSamples, ]

## 保存过滤离群样本后的表达谱
datExprOut <- t(datExpr)
write.table(datExprOut, file = glue("{outdir}/datExpr_smp_filtered.txt"), sep = "\t", quote = FALSE, row.names = TRUE, col.names = NA)


#=====================================================================================
#
#  确定软阈值
#
#=====================================================================================

## 软阈值选择
powers <- c(1:20)  # often 20 in practice
sft <- pickSoftThreshold(datExpr, powerVector = powers, RsquaredCut = 0.9)

## 可视化展示
pdf(glue("{outdir}/Soft_Threshold.pdf"))
par(mfrow = c(1, 2))
plot(sft$fitIndices[, 1], -sign(sft$fitIndices[, 3]) * sft$fitIndices[, 2], 
     xlab = "Soft Threshold (power)", ylab = "SFT, signed R^2", 
     type = "n", main = paste("Scale independence"))
text(sft$fitIndices[, 1], -sign(sft$fitIndices[, 3]) * sft$fitIndices[, 2], 
     labels = powers, col = "red")
abline(h = 0.9, col = "red")   ## 阈值线
plot(sft$fitIndices[, 1], sft$fitIndices[, 5], type = "n",
     xlab = "Soft Threshold (power)", ylab = "Mean Connectivity", 
     main = paste("Mean connectivity"))
text(sft$fitIndices[, 1], sft$fitIndices[, 5], 
     labels = powers, col = "red")
dev.off()

## 获取合适的软阈值
power <- sft$powerEstimate ## 最佳power值
if (is.na(power)){  ## 经验值
  nSamples <- ncol(datExprFilterSmp)
  power <- ifelse(nSamples < 20, 9, ifelse(nSamples < 30, 8, ifelse(nSamples < 40, 7, 6)))
}


#=====================================================================================
#
#  模块鉴定
#
#=====================================================================================

## 结果输出路径
module_detect_dir <- "Output/module_detect"
dir.create(file.path(module_detect_dir), showWarnings = FALSE)

## 启用多线程
enableWGCNAThreads(nThreads = 2)

## 核心部分
nGenes <- ncol(datExpr)
block_thred <- 40000
if(nGenes <= block_thred){
  net <- blockwiseModules(datExpr, corType = "pearson", maxBlockSize = 1.1 * nGenes, 
                          networkType = "unsigned", power = 6, minModuleSize = 30, 
                          mergeCutHeight = 0.25, numericLabels = TRUE, saveTOMs = TRUE,
                          pamRespectsDendro = FALSE, saveTOMFileBase = glue("{module_detect_dir}/TOM"))
} else {
  net <- blockwiseModules(datExpr, corType = "pearson", maxBlockSize = block_thred, 
                          networkType = "unsigned", power = 6, minModuleSize = 30, 
                          mergeCutHeight = 0.25, numericLabels = TRUE, saveTOMs = TRUE,
                          pamRespectsDendro = FALSE, saveTOMFileBase = glue("{module_detect_dir}/TOM"))
}

## 将模块label转换为颜色名称
moduleLables <- net$colors
moduleColors <- labels2colors(moduleLables)
## 将信息进行保存，以便后续可以直接load使用
MEs <- net$MEs
geneTree <- net$dendrograms[[1]]
save(MEs, moduleLables, moduleColors, geneTree, net, 
     file = glue("{module_detect_dir}/networkConstruction_and_modules.RData"))

## 绘制聚类图和共表达模块
blocks <- length(unique(net$blocks))
if(blocks == 1){
  pdf(glue("{module_detect_dir}/Gene_Cluster_Dendrogram.pdf"))
  plotDendroAndColors(net$dendrogram[[1]], moduleColors[net$blockGenes[[1]]], 
                      groupLabels = "Module colors", dendroLabels = FALSE, 
                      hang = 0.03, addGuide = TRUE, guideHang = 0.05)
  dev.off()
} else {
  pdf(glue("{module_detect_dir}/Gene_Cluster_Dendrogram.pdf"))
  for (i in 1:blocks){
    plotDendroAndColors(net$dendrogram[[i]], moduleColors[net$blockGenes[[i]]], 
                        groupLabels = "Module colors", 
                        main = glue("Gene dendrogram and module colors in block {i}"),
                        dendroLabels = FALSE, 
                        hang = 0.03, addGuide = TRUE, guideHang = 0.05)
  }
  dev.off()
}


#导出每个模块中的基因列表
genes <- colnames(datExpr)
allModules <- unique(moduleColors)

for (mod in allModules)
{
  inModule <- (moduleColors == mod)
  modGenes <- genes[inModule]
  IMConn <- softConnectivity(datExpr[, modGenes])
  outConn <- cbind(modGenes, IMConn)
  orderConn <- outConn[order(as.numeric(outConn[,2]), decreasing = T), ]
  colnames(orderConn) = c("gene_id", "connectivity")
  write.table(orderConn, file = glue("{module_detect_dir}/module_{mod}_gene.txt"), sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)
}


#=====================================================================================
#
#  共表达网络可视化
#
#=====================================================================================

## 计算距离矩阵
dissTOM <- 1 - TOMsimilarityFromExpr(datExpr, power = 6)

## 选择基因进行可视化
set.seed(123)  ## 设定随机种子，便于复现结果
select <- sample(nGenes, size = as.numeric(400))
selectTOM <- dissTOM[select, select]
selectColors <- moduleColors[select]

## 层级聚类
selectTree <- hclust(as.dist(selectTOM), method = "average")

## 使图片结果更显著
plotDiss = selectTOM^7
diag(plotDiss) = NA

## 可视化
pdf(glue("{outdir}/Network_heatmap_plot_selectGenes.pdf"))
TOMplot(plotDiss, selectTree, selectColors, main = "Network heatmap plot, selected genes", col = heat.colors(12))
dev.off()


#=====================================================================================
#
#  表型数据关联分析
#
#=====================================================================================

## 读取表型数据
allTraits <- read.csv("Input/ClinicalTraits.txt", sep = "\t", check.names = FALSE, row.names = 1)

## 进行数据整理
Sample <- rownames(datExpr)
traitRows <- match(Sample, rownames(allTraits))
datTraits <- data.frame(allTraits[traitRows, ])
table(rownames(datTraits) == rownames(datExpr))

## 聚类树
sampleTree <- hclust(dist(datExpr), method = "average")

## 绘制样本聚类树和表型数据热图
traitColors <- data.frame(numbers2colors(datTraits, signed = FALSE))
pdf(glue("{outdir}/Sample_dendrogram_and_trait_heatmap.pdf"), width = 16, height = 9)
plotDendroAndColors(sampleTree, groupLabels = names(datTraits), colors = traitColors, 
                    main = "Sample dendrogram and trait heatmap", 
                    cex.dendroLabels = 0.7, marAll = c(1, 6, 3, 1))
dev.off()


## 基因模块和表型数据相关性
# 计算module eigengenes
MEs0 <- moduleEigengenes(datExpr, moduleColors)$eigengenes
MEsCol <- orderMEs(MEs0)
# 计算模块和表型相关性
modTraitCor <- cor(MEsCol, datTraits, use = "p")
modTraitP <- corPvalueStudent(modTraitCor, nrow(datExpr))

## 相关性热图绘图
# 热图单元格上需要展示的文本"相关性系数(p值)"
textMatrix <- paste(signif(modTraitCor, 2), "\n(", signif(modTraitP, 1), ")", sep = "")
dim(textMatrix) <- dim(modTraitCor)
# 绘图
pdf(glue("{outdir}/Module-trait_relationship.pdf"), width = 12, height = 8)
par(mar = c(7, 8.5, 3, 3))
labeledHeatmap(Matrix = modTraitCor, xLabels = names(datTraits), yLabels = names(MEsCol),
               ySymbols = names(MEsCol), colorLabels = FALSE, colors = blueWhiteRed(50), 
               textMatrix = textMatrix, setStdMargins = FALSE, cex.text = 0.5, zlim = c(-1, 1), 
               main = paste("Module-trait relationships"))
dev.off()

# turquoise


#=====================================================================================
#
#   Gene relationship to trait and important modules
#
#=====================================================================================

## 挑选一个感兴趣的表型
weight <- as.data.frame(datTraits$weight_g) 
names(weight) <- "weight"

## 获取模块名字
modNames <- substring(names(MEsCol), 3)

## 计算基因和模块相关性
geneModuleMembership <- as.data.frame(cor(datExpr, MEsCol, use = "p"))
MMPvalue <- as.data.frame(corPvalueStudent(as.matrix(geneModuleMembership), nrow(datExpr)))
names(geneModuleMembership) <- paste("MM", modNames, sep="")
names(MMPvalue) <- paste("p.MM", modNames, sep="")

## 计算基因和表型相关性
geneTraitSignificance = as.data.frame(cor(datExpr, weight, use = "p"))
GSPvalue = as.data.frame(corPvalueStudent(as.matrix(geneTraitSignificance), nrow(datExpr)))
names(geneTraitSignificance) = paste("GS.", names(weight), sep="")
names(GSPvalue) = paste("p.GS.", names(weight), sep="")

## 选择模块
module <- "brown"   # 在模块和表型相关性分析中，和体重最相关的模块是brown
column <- match(module, modNames)
moduleGenes <- moduleColors==module

## 绘图（GS和MM散点图）
pdf(glue("{outdir}/GS_MM_ScatterPlot.pdf"), width = 7, height = 7)
par(mfrow = c(1,1));
verboseScatterplot(abs(geneModuleMembership[moduleGenes, column]),
                   abs(geneTraitSignificance[moduleGenes, 1]),
                   xlab = paste("Module Membership in", module, "module"),
                   ylab = "Gene significance for body weight",
                   main = paste("Module membership vs. gene significance\n"),
                   cex.main = 1.2, cex.lab = 1.2, cex.axis = 1.2, col = module)
dev.off()


#=====================================================================================
#
#   导出网络图数据，用于网络图绘制
#
#=====================================================================================

## 选择感兴趣的模块
modules <- c("brown")

## 取出模块中的基因
inModule <- is.finite(match(moduleColors, modules))
probes <- colnames(datExpr)
modProbes <- probes[inModule]

# 选择拓扑重叠矩阵中数据
TOM <- TOMsimilarityFromExpr(datExpr, power = 6)
modTOM <- TOM[inModule, inModule]
dimnames(modTOM) <- list(modProbes, modProbes)

## 导出数据用于网络图绘制
network_outdir <- "Output/export_network"
dir.create(file.path(network_outdir), showWarnings = FALSE)
cyt <- exportNetworkToCytoscape(modTOM,
                                edgeFile = paste(network_outdir, "/CytoscapeInput-edges-", paste(modules, collapse="-"), ".txt", sep=""),
                                nodeFile = paste(network_outdir, "/CytoscapeInput-nodes-", paste(modules, collapse="-"), ".txt", sep=""),
                                weighted = TRUE,
                                threshold = 0.02,
                                nodeNames = modProbes,
                                # altNodeNames = modGenes,
                                nodeAttr = moduleColors[inModule])


#=====================================================================================
#
#   ......
#
#=====================================================================================




