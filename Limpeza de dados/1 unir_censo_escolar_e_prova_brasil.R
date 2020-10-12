########################################
### Unir as bases de dados do censo  ###
###         Prova Brasil             ###
########################################
# autor: Ian F.

### library ----
library(dplyr)
rm(list=ls())

### Data ---- 
# Dados publicos, modificados (ver codigo exemplo_agrupar_microdados)
escolas <- readRDS("Dados/[DF AGREGADO]escolas_2009-2015.rds")
turmas <- readRDS("Dados/[DF AGREGADO]turmas_2009-2015.rds")
docentes <- readRDS("Dados/[DF AGREGADO]docentes_2009-2015.rds")
alunos <- readRDS("Dados/[DF AGREGADO]alunos_2009-2015.rds")
pb <- readRDS("Dados/PB_2009_2017.rds")

# verificar os nomes e padronizalos
bases <- c('escolas', 'turmas', 'docentes', 'alunos', 'pb')
# for (base in bases){
#       print(base)
#       names(get(base)) %>% print()
#       print("")
# }
names(pb)[2] <- "PK_COD_ENTIDADE"
names(pb)[3] <- "ANO"
names(turmas)[3] <- "ANO"
names(escolas)[8] <- "ANO"

# pegar apenas variaveis que serao utilizadas
escolas <- escolas[, c(2, 3, 8, 11, 18, 19, 20, 21, 22, 24)]
turmas <- turmas[, c(2,3,5,6,7,8)]
docentes <- docentes[, c(2, 3, 5, 11)]
alunos <- alunos[, c(2, 3, 4, 8, 9, 10, 11)]
pb <- pb[, c(2, 3, 4, 6, 7, 8, 9, 12, 15, 17, 18, 19, 20, 
             21, 22, 23, 24, 25, 26, 27, 28, 29)]

# unir os dados em um ?nico data frame
dff = merge(alunos, pb, by = c("PK_COD_ENTIDADE", "ANO"), 
            all.x=TRUE, all.y=TRUE)
for (base in bases[1:3]){
      dff = merge(dff, get(base), by = c("PK_COD_ENTIDADE", "ANO"), 
                  all.x=TRUE, all.y=TRUE)
}

### Filtros ----
# vamos utilizar apenas anos impares entre 2009 e 2015
# devido a disponibilidade da prova brasil apenas nesses anos
dff <- dff %>% filter(ANO %in% seq(2009, 2015, 2))

# vamos utilizar apenas escolas estaduais 
dff <- dff %>% filter(ID_DEPENDENCIA_ADM.x == 2 & ID_DEPENDENCIA_ADM.y == 2)
dff <- dff[, !(names(dff) %in% c("ID_DEPENDENCIA_ADM.x",
                                 "ID_DEPENDENCIA_ADM.y"))] # tudo estadual, entao tirei a coluna
rm(list=ls()[ls() != "dff"])

saveRDS(dff, "Dados/df_agregado.rds")
