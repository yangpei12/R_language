
data = read.delim(file="E:/�ۺ�/�쳬/GO_scat.txt", header=TRUE, sep="\t")

# names(data)
sortdata = data[order(data$pvalue),]
topLineNum = 100
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
# topdata[,2]<-factor(topdata$pathway_name,levels = data[,2])##锁定顺序,rev为反顺序函数
# topdata[,"pvalue"]<-unclass(topdata[,"pvalue"])
# topdata

pdf(file="E:/�ۺ�/�쳬/GO_scat.pdf",width=10, height=10)
qplot(x=richFactor, y=pathway_name, data=topdata, xlab="Rich factor", ylab="pathway_name", main="Statistics of Pathway Enrichment", color = pvalue, size = S.gene.number)+
scale_size("Gene_number")+
scale_y_discrete(limits=rev(data[,2])) +#按文件排�?
scale_color_gradientn("pvalue", colours=rainbow(3))+
# scale_color_gradient(low="#EB0A00",high="#3A8D17")+
# theme_test() +
# theme_classic() +##更换背景
theme_bw() +
theme(
axis.text.x=element_text(angle=0,hjust=0.5,vjust=1,colour="black",face="plain",size=13),
axis.text.y=element_text(angle=0,hjust=1,vjust=0.5,colour="black",face="plain",size=13),
axis.title.x=element_text(angle=0,colour="black",face="plain",size=15),
axis.title.y=element_text(angle=90,colour="black",face="plain",size=15),
plot.title=element_text(angle=0,colour="black",face="plain",lineheight =2,size=16,hjust=0.5),
legend.text=element_text(angle=0,hjust=0,vjust=0.5,colour="black",face="plain",size=13),
legend.title=element_text(angle=0,hjust=0,vjust=0,colour="black",face="plain",size=13))
dev.off()