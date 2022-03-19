library('org.Mm.eg.db')
gene_id <- c("ENSMUSG00000034165")
cols <- c("ENTREZID")
select(org.Mm.eg.db, keys=gene_id, columns=cols, keytype="ENSEMBL")