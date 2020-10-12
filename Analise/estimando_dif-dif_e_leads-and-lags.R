########################################
### Modelos para estimar impacto     ###
###   causal da escola integral      ###
########################################
# autor: Ian F.

library(dplyr)
library(plm)
rm(list=ls())
dff <- readRDS("Dados/df_final.rds")

### covariadas para dif-in-dif e leads and lags ----
socioeconomica_aluno <- c("P_MAE_ES_COMP", "P_MAE_ANALFABETA", "P_IDADE_CERTA",
                          "P_TRABALHA", "P_EMPREGADA", "P_GELADEIRA",
                          "P_TV", "P_COMPUTADOR", "BANHEIRO",
                          "P_ALUNOS_TRANSPUB")
tipo_ensino <- c("ETI", "D_INTEGRAL")
caracteristica_aluno <- c("P_BRANCOS", "P_HOMENS", "P_IDADE_CERTA",
                          "P_SOMENTE_PUB", "P_REPROVADO", "P_ABANDONO",
                          "P_ENTRADA_TARDIA")
infraestrutura <- c("D_LAB_INFO", "D_LAB_CIENCIAS", "D_BIBLIOTECA",
                    "N_FUNCIONARIOS_PA", "P_PROF_POSGRAD",
                    "P_PROF_POSGRAD_PA", "D_QUADRA")

### dif-in-dif ----
mform <- as.formula(paste0("MTM ~ PEI + ", paste0(
      union(socioeconomica_aluno, union(tipo_ensino, 
            union(caracteristica_aluno, infraestrutura))), collapse = "+"
)))
mtm_dd <- plm(formula = mform, data = dff, 
            index = c("PK_COD_ENTIDADE", "ANO"), 
            model = "within", effect= "twoways")
summary(mtm_dd)

mform <- as.formula(paste0("PORT ~ PEI + ", paste0(
        union(socioeconomica_aluno, union(tipo_ensino, 
        union(caracteristica_aluno, infraestrutura))), collapse = "+"
)))
port_dd <- plm(formula = mform, data = dff, 
              index = c("PK_COD_ENTIDADE", "ANO"), 
              model = "within", effect= "twoways")
summary(port_dd)

### leads and lags ----
mform <- as.formula(paste0("MTM ~ ", 
                           paste0(names(dff)[c(42,46,45,48,47,50,49)],
                                  collapse = "+"), "+",
                           paste0(
                                   union(socioeconomica_aluno, union(tipo_ensino, 
                                        union(caracteristica_aluno, 
                                              infraestrutura))), collapse = "+"
                           )))
mtm_ll <- plm(formula = mform, data = dff, 
              index = c("PK_COD_ENTIDADE", "ANO"), 
              model = "within", effect= "twoways")
summary(mtm_ll)

mform <- as.formula(paste0("PORT ~ ", 
                           paste0(names(dff)[c(42,46,45,48,47,50,49)],
                                  collapse = "+"), "+",
                           paste0(union(socioeconomica_aluno, union(tipo_ensino, 
                                  union(caracteristica_aluno, 
                                        infraestrutura))), collapse = "+"
                           )))
port_ll <- plm(formula = mform, data = dff, 
              index = c("PK_COD_ENTIDADE", "ANO"), 
              model = "within", effect= "twoways")
summary(port_ll)

### resultados com stargazer
library(stargazer)
stargazer(mtm_dd, port_dd, keep = c(1, 12, 13),
          type = 'text', omit.stat = c('f', 'adj.rsq'))

stargazer(mtm_ll, port_ll, keep = c(1:7, 18, 19),
          type = 'text', omit.stat = c('f', 'adj.rsq'))

stargazer(mtm_dd, port_dd,mtm_ll, port_ll, keep=c(1:8, 19, 20),
          type = 'text', omit.stat = c('f', 'adj.rsq'))

### salvar alguns resultados
saveRDS(list(port_ll, mtm_ll), "Analise/ll_results.rds")
