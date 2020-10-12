########################################
### Dummies usadas para calcular     ###
###     efeito do tratamento         ###
########################################
# autor: Ian F.

library(dplyr)
rm(list=ls())
dff <- readRDS("Dados/df_agregado.rds")

### criar variaveis de tratamento (PEI) ----

# base com data de entrada no PEI e etapa de ensino:
pei_efaf <- read.csv("Dados/pei_efaf.csv")
# usaremos apenas ensino fundamental
pei_efaf <- pei_efaf %>% filter(ef == 1)
pei_efaf <- pei_efaf[, c(2, 3)] # cortar colunas que nao serao usadas
# tratados apos 2015 nao serao considerados (analise vai ate 2015)
pei_efaf <- pei_efaf %>% filter(ano <= 2015) 
# criar um vetor para cada ano com escolas que receberam pei
for (ano in 2013:2015){
      assign(paste0("t", ano), pei_efaf$COD_CENSO[pei_efaf$ano == ano])
}

# criar as dummies: 
#     treat: se recebe em algum momento, 
#     PEI: se esta recebendo no ano especifico
dff$treat <- as.integer(dff$PK_COD_ENTIDADE %in% pei_efaf$COD_CENSO)
dff$PEI <- with(dff,
                ifelse((PK_COD_ENTIDADE %in% t2013 & ANO >= 2013) | 
                             (PK_COD_ENTIDADE %in% t2014 & ANO >= 2014) |
                             (PK_COD_ENTIDADE %in% t2015 & ANO >= 2015),
                       1, 0))
table(dff$PEI, dff$ANO)
# ja perdemos uma obs... escola cod 35479342, entrou ano 2014, mas so ta 
# na base em 2013
table(pei_efaf$ano)


### criar leads and lags ----
for (ano in unique(dff$ANO)){
      for (ano_init in 2013:2015){
            prefix = ifelse(ano - ano_init < 0, "lead", "lag")
            number = abs(ano - ano_init)
            this_ll = paste0(prefix, "_", number)
            if (!this_ll %in% names(dff)){
                  dff[,this_ll] <- 0
            }
            dff[,this_ll] <- ifelse(
                  dff$PK_COD_ENTIDADE %in% get(paste0("t",ano_init)) &
                        dff$ANO == ano,
                  1, dff[,this_ll])
      }
}

for(i in 42:50){
      print(paste0(names(dff)[i],": "  ,sum(dff[,i])))
}

rm(list=ls()[ls()!="dff"])
### criar variaveis de outro programa de escola integral (ETI) ----
ETI <- read.csv("Dados/ETI_COD_CENSO.csv")
dff$ETI <- 0
for (ano in unique(dff$ANO)){
      dff$ETI[dff$ANO==ano] <- ifelse(dff$PK_COD_ENTIDADE[dff$ANO == ano] %in% 
                                            ETI$COD_CENSO[ETI$ano <= ano],
                                      1, dff$ETI)
}

saveRDS(dff, "Dados/df_pei.rds")
