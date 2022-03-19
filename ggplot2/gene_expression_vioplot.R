library("ggplot2")

data = read.table(file = "E:/售后/马乐/diff_expression_gene.txt", header = T, sep = "\t", quote = "")
p <- ggplot(data, aes(factor(samples), log10_FPKM))
p <- p + geom_violin(aes(fill = factor(samples)), alpha = 0.5) + 
geom_boxplot(notchwidth = 0.3, alpha = 0.5, width = 0.3)  +
scale_fill_discrete(name = "samples") + 
labs(title = "FPKM distribution", x = "", y = "log10(FPKM+1)")+
		theme(plot.title=element_text(size=rel(2),face="bold",colour="black",lineheight =1,hjust = 0.5),
		      axis.title.x=element_text(size=rel(2),colour="black",angle=0,hjust=0.5,vjust=0,lineheight =0.5),
		      axis.title.y=element_text(size=rel(1.5),colour="black",angle=90,hjust=0.5,vjust=0,lineheight =0.5),
  			  axis.text.x=element_text(size=rel(1.5),colour="black",hjust=1,vjust=1),
  			  axis.text.y=element_text(size=rel(1.5),colour="black"),
			  plot.margin=unit(c(5,5,5,5),"mm"))

ggsave(p, file="E:/售后/马乐/diff_expression_gene.pdf", width = 10, height = 8)
