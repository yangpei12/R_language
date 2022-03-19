
data = read.delim(file="E:/售后/黄进强21-10-1/数据转换/total_RNA/miRNA/miRNA_KEGG_scatterplot.txt", header=TRUE, sep="\t")		
# names(data)
sortdata = data[order(data$qvalue),]			
topLineNum = 20
dataLineNum = dim(sortdata)[1]
topdata = sortdata
if (topLineNum < dataLineNum) {topdata = sortdata[1:topLineNum,]}

topdata$pathway_name=as.matrix(topdata$pathway_name)
for (i in (1:length(topdata$pathway_name))){
  if(nchar(as.vector(topdata$pathway_name[i]))>59){
    topdata$pathway_name[i] = paste(substr(topdata$pathway_name[i],1,59),"...",sep="")
  }else{
    topdata$pathway_name[i] =topdata$pathway_name[i]
  }
}

richFactor = topdata$S.gene.number/topdata$B.gene.number
topdata$richFactor = richFactor				
library("ggplot2")
pdf(file="E:/售后/黄进强21-10-1/数据转换/total_RNA/miRNA/miRNA_image/miRNA_KEGG_scatterplot.pdf",width=10, height=8)
qplot(x=richFactor, y=pathway_name, data=topdata, xlab="Rich factor", ylab="pathway_name", main="Statistics of Pathway Enrichment", color = qvalue, size = S.gene.number)+
  scale_size("Gene_number")+scale_color_gradientn("qvalue", colours=rainbow(3))+
  scale_y_discrete(limits=rev(topdata[,2]))+
  theme_bw() +
  theme(
    axis.text.x=element_text(angle=0,hjust=0.5,vjust=1,colour="black",face="plain",size=14),
    axis.text.y=element_text(angle=0,hjust=1,vjust=0.5,colour="black",face="plain",size=14),
    axis.title.x=element_text(angle=0,colour="black",face="plain",size=16),
    axis.title.y=element_text(angle=90,colour="black",face="plain",size=16),
    plot.title=element_text(angle=0,colour="black",face="plain",lineheight =2,size=16,hjust=0.5),
    legend.text=element_text(angle=0,hjust=0,vjust=0.5,colour="black",face="plain",size=14),
    legend.title=element_text(angle=0,hjust=0,vjust=0,colour="black",face="plain",size=14))
dev.off()