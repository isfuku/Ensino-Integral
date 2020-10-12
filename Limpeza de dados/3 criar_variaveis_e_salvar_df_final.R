########################################
### Criar variaveis depedentes que   ###
### serao utilizadas nas regressoes  ###
########################################
# autor: Ian F.

library(dplyr)
library(Amelia)
rm(list=ls())
dff <- readRDS("Dados/df_pei.rds")

### modificar nomes e criar variaveis ----
# siglas:
      # N=Numero; P=Proporcao; D=Dummy; PA=Por Aluno; 
      # EFAF=Ensino fundamental anos finais; sd=Desvio Padrao;
names(dff)
names(dff) <- c(names(dff)[1:7], "D_URBANO", "MTM", "PORT", "sd_MTM", "sd_PORT", 
                "N_MATRICULAS", "P_IDADE_CERTA", "P_MAE_EM_COMP", "P_MAE_ES_COMP", 
                "P_MAE_ANALFABETA", "P_TRABALHA", "P_ENTRADA_TARDIA", "P_SOMENTE_PUB", 
                "P_REPROVADO", "P_ABANDONO", "P_EMPREGADA", "P_GELADEIRA", "P_TV",
                "P_COMPUTADOR", "BANHEIRO", "N_QUADRAS", "D_LAB_INFO", "D_LAB_CIENCIAS",
                "D_BIBLIOTECA", "N_SALAS_EXISTENTES", "N_SALAS_USADAS", "N_FUNCIONARIOS",
                "MAIS_EDUC", "D_INTEGRAL", "N_TURMAS", "N_PROF_EFAF",
                "N_PROF_EFAF_POSGRAD", names(dff)[40:51])
dff$P_HOMENS <- (dff$N_ALUNOS_EFAF - dff$N_F_EFAF)/dff$N_ALUNOS_EFAF
dff$P_BRANCOS <- (dff$N_BRANCO_EFAF)/dff$N_ALUNOS_EFAF
dff$P_PROF_POSGRAD <- (dff$N_PROF_EFAF - dff$N_PROF_EFAF_POSGRAD)/dff$N_PROF_EFAF
dff$N_TURMAS_PA <- dff$N_TURMAS/dff$N_ALUNOS_EFAF
dff$N_FUNCIONARIOS_PA <- dff$N_FUNCIONARIOS/dff$N_ALUNOS_EFAF
dff$P_ALUNOS_TRANSPUB <- (dff$N_ALUNOS_TRANSPUB_EFAF)/dff$N_ALUNOS_EFAF
dff$P_PROF_POSGRAD_PA <- dff$P_PROF_POSGRAD/dff$N_ALUNOS_EFAF
dff$D_QUADRA <- as.integer(dff$N_QUADRAS >= 1)

# remover NAs
missmap(dff[,c(9:10)])

df_sem_na <- dff[complete.cases(dff),]
saveRDS(df_sem_na, "Dados/df_final.rds")

# obs perdidas pois nao estao na prova brasil:
in_pei <- unique(dff$PK_COD_ENTIDADE[dff$PEI == 1])
all_schools <- unique(dff$PK_COD_ENTIDADE)

no_na_pei <- unique(df_sem_na$PK_COD_ENTIDADE[df_sem_na$PEI == 1])
no_na_schools <- unique(df_sem_na$PK_COD_ENTIDADE)
