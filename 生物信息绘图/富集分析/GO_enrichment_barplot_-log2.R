
library(ggplot2)
library(scales)

Legend_Text=c("biological_process","cellular_component","molecular_function")
file<-read.table("E:/售后/黄进强21-10-1/数据转换/circRNA/circRNA_GO_barplot_-log2.txt",sep="\t",header=T)
file[,3]<-factor(file[,3],levels=Legend_Text)
col_index<-c("#528DC4","#95BA6D","#F09D59")
names(col_index)<-levels(file[,3])
myColours<-col_index[file[,3]]
names(myColours)<-NULL
Y_Max<-max(file[,2])*1.1
	pdf("E:/售后/黄进强21-10-1/数据转换/circRNA/image/circRNA_GO_barplot_-log2.pdf",width=10,height=8)
ggplot(file, aes(file[,1],file[,2],fill=file[,3]))+
coord_flip() +
	geom_bar(position = "dodge",stat="identity",width=0.7)+
	geom_text(aes(label=file[,2]),vjust=0.5,hjust=-0.5,colour="black",
            position=position_dodge(1),size=0)+
     scale_y_continuous(limits=c(0,Y_Max),expand=c(0.02,0)) +
	scale_x_discrete(limits=file[,1],expand=c(0,0.8))+
			scale_fill_manual(values=col_index)+
			labs(x="GO terms",y="-log2(qval)",title="",fill=NULL)+
			theme_test() +
			theme(
			     axis.text.x=element_text(angle=0,hjust=0.5,vjust=1,colour="black",face="bold",size=12),
                 axis.text.y=element_text(angle=0,hjust=1,vjust=0.5,colour=myColours,face="bold",size=8),

                 axis.title.x=element_text(angle=0,colour="black",face="bold",size=12),
                 axis.title.y=element_text(angle=90,colour="black",face="bold",size=12),

                 plot.title=element_text(angle=0,colour="black",face="bold",lineheight =2,size=16),

                 legend.text=element_text(angle=0,hjust=0,vjust=0,colour="black",face="bold",size=12),
                 legend.title=element_text(angle=0,hjust=0,vjust=0,colour="black",face="bold",size=16),
                 legend.position="right",

                 plot.margin=unit(c(10,20,10,10),"mm")
            )
dev.off()
