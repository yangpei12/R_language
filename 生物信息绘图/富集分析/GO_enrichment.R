
library(ggplot2)
library(scales)
# library(svglite)

data<-read.table("E:/售后/朱超/GO_barplot.txt",sep="	",header=T,quote="")
col_index<-c("#528DC4","#95BA6D","#F09D59")
##col_index<-c("#D3D3D3","#A9A9A9","#696969")
names(col_index)<-levels(data$GO_fuction)
myColours<-col_index[data$GO_fuction]
names(myColours)<-NULL

pdf("E:/售后/朱超/GO_barplot.pdf",width=12,height=8)

ggplot(data,aes(data$GO_term,data$S_gene_number,fill=data$GO_fuction))+
geom_bar(position="dodge",stat="identity",alpha=1)+
#geom_text(aes(label=data$S_gene_number),vjust=0,colour="black",position=position_dodge(0.8),size=3)+
scale_x_discrete(limits=data$GO_term)+   # 指??x????目??顺??
scale_fill_manual(values=col_index)+
#scale_y_log10(labels=trans_format("log10",math_format(10^.x)))+
labs(title="",x="GO_term",y="Num of Genes
",fill=NULL)+ 
theme_bw() +
theme(
	axis.text.x=element_text(angle=60,hjust=1,vjust=1,colour="black",face="bold",size=10),
	axis.text.y=element_text(angle=0,hjust=1,vjust=1,colour="black",face="bold",size=12),
	
	axis.title.x=element_text(angle=0,colour="black",face="bold",size=14),
	axis.title.y=element_text(angle=90,colour="black",face="bold",size=14),
	
	plot.title=element_text(angle=0,colour="black",face="bold",lineheight =2,size=16),
	
	legend.text=element_text(angle=0,hjust=0,vjust=0,colour="black",face="italic",size=18),
	legend.title=element_text(angle=0,hjust=0,vjust=0,colour="black",face="italic",size=16),
	legend.position="top",

	plot.margin=unit(c(13,26,13,13),"mm")
	)
dev.off()
