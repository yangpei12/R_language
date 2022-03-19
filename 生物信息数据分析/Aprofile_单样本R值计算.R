library(openxlsx)
library(tidyverse)
setwd("G:/售后/王秀玲")
data <- read.xlsx("2_AS_All_sample.xlsx",1)
comp <- read.xlsx("比较组.xlsx",1)
es_event <- filter(data,event_type %in% c('SKIP_ON','SKIP_OFF'))
gene_id_list <- unique(es_event$gene_id)


for(n in seq(dim(comp)[1])){
  treat <- comp[n,'treat']
  cont <- comp[n,'cont']
  
  df_out <- data.frame()
  for(name in gene_id_list){
    select_gene_id <- filter(es_event, gene_id %in% c(name))
    gene_id_info <- select(select_gene_id,c('event_type','gene_id', all_of(treat), all_of(cont)))
    gene_id_on <- filter(gene_id_info, event_type %in% c('SKIP_ON'))
    gene_id_off <- filter(gene_id_info, event_type %in% c('SKIP_OFF'))
    treat_on <- gene_id_on[,treat]
    treat_off <- gene_id_off[,treat]
    cont_on <- gene_id_on[,cont]
    cont_off <- gene_id_off[,cont]
    Ri <- sum(treat_on)/(sum(treat_on)+sum(treat_off))
    Rj <- sum(cont_on)/(sum(cont_on)+sum(cont_off))
    delta_R <- abs(Ri-Rj)
    
    df <- data.frame('gene_id'=name,
                     'Ri'=Ri,
                     'Rj'=Rj,
                     'delta_R'=delta_R)
    df_out <- rbind(df_out,df)
  }
  file_name <- paste('ES_',treat,'_',cont,'_output.xlsx',sep='')
  write.xlsx(df_out,file_name,rowNames=F)
}

