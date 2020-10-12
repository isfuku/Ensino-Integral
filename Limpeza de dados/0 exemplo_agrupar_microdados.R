########################################
### codigo para pegar dados do censo ###
###     escolar - dos docentes       ###
########################################
# autor: Ian F.

### bibliotecas e diretorio ###
library(readr)
library (dplyr)

####################################################################
### Dados em painel, escolas no tempo, caracteristicas dos profs ###
####################################################################


### Variaveis:
###          N_PROF: numero de professores na escola ensinando no EFAF ou EM, Docente ou 
###                  atividade complementar
###          N_PROF_SUP_COMP: numero de professores com ens sup completo
###          N_PROF_POSGRAD: numero de professores com alguma pos graduacaoo
###          N_PROF_DOUTORADO: numero de professores com doutorado
###          N_PROF_MESTRADO: numero de professores com mestrado
###          N_PROF_ESPECIALIZACAO: numero de professores com especializacao

### NECESSARIO PASTA COM OS MICRODADOS:
#   'getwd, /Microdados_censo_escolar/', ano_do_censo, "/DOCENTES_SUDESTE.CSV"

## Vamos utilizar estas variaveis do censo, que estao nas colunas dentro dos vetores, 
## para cada ano:

# caso 2009 
dict0 <- c("FK_COD_ESCOLARIDADE", "ID_ESPECIALIZACAO", "ID_MESTRADO", "ID_DOUTORADO",
           "ID_TIPO_DOCENTE", "FK_COD_TIPO_TURMA", "FK_COD_ETAPA_ENSINO", "PK_COD_ENTIDADE",
           "FK_COD_ESTADO", "ID_DEPENDENCIA_ADM")

col2009 <- c(17, 63, 64, 65, 73, 75, 77, 79, 80, 84)
col2010 <- c(17, 63, 64, 65, 73, 75, 77, 79, 80, 84)

# caso de 2011-2014 #
dict1 <- c("ID_SITUACAO_CURSO_1", "ID_ESPECIALIZACAO", "ID_MESTRADO", "ID_DOUTORADO",
           "ID_TIPO_DOCENTE", "FK_COD_TIPO_TURMA", "FK_COD_ETAPA_ENSINO", "PK_COD_ENTIDADE", 
           "FK_COD_ESTADO", "ID_DEPENDENCIA_ADM")

col2011 <- c(18, 72, 73, 74, 87, 90, 92, 94, 95, 100)
col2012 <- c(28, 84, 85, 86, 104, 107, 109, 111, 112, 117)
col2013 <- col2012
col2014 <- c(27, 83, 84, 85, 103, 106, 108, 110, 111, 115)

# caso de 2015-2018 #
dict2 <- c("TP_SITUACAO_CURSO_1", "IN_ESPECIALIZACAO", "IN_MESTRADO", "IN_DOUTORADO",
           "TP_TIPO_DOCENTE", "TP_TIPO_TURMA", "TP_ETAPA_ENSINO", "CO_ENTIDADE", 
           "CO_UF", "TP_DEPENDENCIA")
col2015 <- c(28, 85, 86, 87, 105, 108, 114, 119, 120, 123)
col2016 <- c(28, 82, 83, 84, 102, 105, 111, 113, 117, 120)
col2017 <- c(28, 82, 83, 84, 102, 105, 111, 116, 117, 120)
col2018 <- c(28, 82, 83, 84, 102, 105, 111, 116, 117, 120)

col_list <- list(col2011, col2012, col2013, col2014, col2015, col2016, col2017, col2018)

### iniciando o data frame principal ###
df_docentes <- data.frame(PK_COD_ENTIDADE = NA, ANO = NA, N_PROF = NA, N_PROF_EFAF = NA, 
                          N_PROF_EM = NA, 
                          N_PROF_SUP_COMP = NA, N_PROF_SUP_COMP_EFAF = NA, N_PROF_SUP_COMP_EM = NA,
                          N_PROF_POSGRAD = NA, N_PROF_POSGRAD_EFAF = NA, N_PROF_POSGRAD_EM = NA,
                          N_PROF_DOUTORADO = NA, N_PROF_DOUTORADO_EFAF = NA, N_PROF_DOUTORADO_EM = NA,
                          N_PROF_MESTRADO = NA, N_PROF_MESTRADO_EFAF = NA, N_PROF_MESTRADO_EM = NA,
                          N_PROF_ESPECIALIZACAO = NA, N_PROF_ESPECIALIZACAO_EFAF = NA, N_PROF_ESPECIALIZACAO_EM = NA)




######################################################################################
### loop para abrir todos os censos escolares e agrega-los no data frame principal ###
######################################################################################

for(ano in 2009:2018){
        ano <- as.character(ano)
        
        print(paste("Lendo microdados do censo escolar de ", ano))
        
        ### lendo o microdado ###
        init_time <- Sys.time()
        
        if(as.integer(ano) > 2014){
                docentes <- read_delim(paste0('D:/Mestrado/PEI/Microdados_censo_escolar/', 
                                            ano, "/DOCENTES_SUDESTE.CSV"),
                                     col_types = cols_only(TP_SITUACAO_CURSO_1 = "i", 
                                                           IN_ESPECIALIZACAO = "i", 
                                                           IN_MESTRADO = "i",
                                                           IN_DOUTORADO = "i",
                                                           TP_TIPO_DOCENTE = "i",
                                                           TP_TIPO_TURMA = "i",
                                                           TP_ETAPA_ENSINO = "i",
                                                           CO_ENTIDADE = "i",
                                                           CO_UF = "i",
                                                           TP_DEPENDENCIA = "i"),
                                     delim = "|", escape_double = FALSE, trim_ws = TRUE)
        }else if(as.integer(ano) < 2011){
                docentes <- read_delim(paste0('D:/Mestrado/PEI/Microdados_censo_escolar/', 
                                            ano, "/DOCENTES_SUDESTE.CSV"),
                                     col_types = cols_only(FK_COD_ESCOLARIDADE = "i", 
                                                           ID_ESPECIALIZACAO = "i", 
                                                           ID_MESTRADO = "i",
                                                           ID_DOUTORADO = "i",
                                                           ID_TIPO_DOCENTE = "i",
                                                           FK_COD_TIPO_TURMA = "i",
                                                           FK_COD_ETAPA_ENSINO = "i",
                                                           PK_COD_ENTIDADE = "i",
                                                           FK_COD_ESTADO = "i",
                                                           ID_DEPENDENCIA_ADM = "i"),
                                     delim = "|", escape_double = FALSE, trim_ws = TRUE)
        }else{
                docentes <- read_delim(paste0('D:/Mestrado/PEI/Microdados_censo_escolar/', 
                                          ano, "/DOCENTES_SUDESTE.CSV"),
                                   col_types = cols_only(ID_SITUACAO_CURSO_1 = "i", 
                                                         ID_ESPECIALIZACAO = "i", 
                                                         ID_MESTRADO = "i",
                                                         ID_DOUTORADO = "i",
                                                         ID_TIPO_DOCENTE = "i",
                                                         FK_COD_TIPO_TURMA = "i",
                                                         FK_COD_ETAPA_ENSINO = "i",
                                                         PK_COD_ENTIDADE = "i",
                                                         FK_COD_ESTADO = "i",
                                                         ID_DEPENDENCIA_ADM = "i"),
                                   delim = "|", escape_double = FALSE, trim_ws = TRUE)
        }
        
        
        finish_time <- Sys.time()
        print(paste("Data frame criado em", as.character(finish_time - init_time)))
        
        # verificar se as colunas estão corretas e padronizar o caso de 2015+#
        print(names(docentes))
        if(as.integer(ano) > 2014){
                if(all(names(docentes) == dict2)){
                        print(paste("colunas OK, prosseguir para filtro e agregação"))
                }else{
                        print(paste("1 - PROBLEMA NO NOME DAS COLUNAS DO ANO", ano))
                        names(docentes)
                }
                colnames(docentes) <- dict1
                
        }else if(as.integer(ano) < 2011){
                if(all(names(docentes) == dict0)){
                        print(paste("colunas OK, prosseguir para filtro e agregação"))
                        docentes$ID_SITUACAO_CURSO_1 <- docentes %>%
                                with(ifelse(FK_COD_ESCOLARIDADE == 6, 1, 0))
                }else{
                        print(paste("2 - PROBLEMA NO NOME DAS COLUNAS DO ANO", ano))
                }
        }else{
                if(all(names(docentes) == dict1)){
                        print(paste("colunas OK, prosseguir para filtro e agregação"))
                }else{
                        print(paste("3 - PROBLEMA NO NOME DAS COLUNAS DO ANO", ano))
                        names(docentes)
                }
        }
        
        
        ######################################################
        ### filtrando para ter so os docentes de interesse ###
        ######################################################
        
        ### Filtro: apenas SP ###
        docentes <- docentes %>%
                filter(FK_COD_ESTADO == 35)
        
        ## Filtro: apenas escola publica ###
        docentes <- docentes %>%
                filter(ID_DEPENDENCIA_ADM %in% c(2, 3))
        
        ### Filtro: remover classe hospitalar, prisional, atividade complementar e AEE###
        docentes <- docentes %>%
                filter(FK_COD_TIPO_TURMA == 0)
        
        ### Filtro: apenas EFAF e EM ##
        EFAF <- c(8:11, 19:21, 41)
        EM <- c(25:38)
        docentes <- docentes %>%
                filter(FK_COD_ETAPA_ENSINO %in% union(EFAF, EM))
        
        ### Filtro: remover auxiliares de sala, monitor e tradutor ###
        docentes <- docentes %>%
                filter(ID_TIPO_DOCENTE == 1)
        
        
        
        ###########################################
        ### pegar as variaveis para a agregacao ###
        ###########################################
        
        ### Dummy para EFAF e EM ###
        docentes$EFAF <- as.integer(docentes$FK_COD_ETAPA_ENSINO %in% EFAF)
        docentes$EM <- as.integer(docentes$FK_COD_ETAPA_ENSINO %in% EM)
        
        ### Graduacao e pos graduacao ###
        docentes$SUPERIOR_COMPLETO <- as.integer(docentes$ID_SITUACAO_CURSO_1 == 1)
        docentes <- docentes %>% 
                mutate(POSGRAD = ID_ESPECIALIZACAO + ID_MESTRADO + ID_DOUTORADO)
        docentes$POSGRAD <- as.integer(docentes$POSGRAD != 0)
        
        ### Agrupar por escola para comecar as contagens ###
        docentes <- docentes %>% group_by(PK_COD_ENTIDADE)
        
        ### vetor com o numero de profs ###
        df1 <- count(docentes, name = "N_PROF")
        df2 <- count(docentes, EFAF, name = "N_PROF_EFAF") %>%
                filter(EFAF == 1)
        df2 <- df2[,c(1,3)]
        df3 <- count(docentes, EM, name = "N_PROF_EM") %>% 
                filter(EM == 1)
        df3 <- df3[,c(1,3)]
        
        ### vetor com numero de profs com ensino superior completo###
        df4<- count(docentes, ID_SITUACAO_CURSO_1, name = "N_PROF_SUP_COMP") %>%
                filter(ID_SITUACAO_CURSO_1 == 1)
        df4 <- df4[,c(1,3)]
        
        ### distinguir profs do EF e do EM com superior completo e incompleto ###
        #** 1 se sao do EF/EM e completou ES, 2 se incompleto, NA se nao entrou ES, 
        #** 0 se sao do EM/EF
        docentes <- docentes %>% mutate(SITUACAO_CURSO_EFAF = EFAF*ID_SITUACAO_CURSO_1)
        docentes <- docentes %>% mutate(SITUACAO_CURSO_EM = EM*ID_SITUACAO_CURSO_1)
        
        ### vetor com numero de profs com ensino superior completo e incompleto para as series ###
        df6 <- count(docentes, SITUACAO_CURSO_EFAF, name = "N_PROF_SUP_COMP_EFAF") %>%
                filter(SITUACAO_CURSO_EFAF == 1)
        df6 <- df6[,c(1,3)]
        
        df7 <- count(docentes, SITUACAO_CURSO_EM, name = "N_PROF_SUP_COMP_EM") %>%
                filter(SITUACAO_CURSO_EM == 1)
        df7 <- df7[,c(1,3)]
        
        
        ### vetor com numero de profs com pos graduacao ###
        df8 <- count(docentes, POSGRAD, name = "N_PROF_POSGRAD") %>%
                filter(POSGRAD == 1)
        df8 <- df8[,c(1,3)]
        
        ### distinguir profs do EF e do EM com pos graduacao ###
        docentes <- docentes %>% mutate(POSGRAD_EFAF = EFAF*POSGRAD)
        docentes <- docentes %>% mutate(POSGRAD_EM = EM*POSGRAD)
        
        ### vetor com numero de profs com pos graduacao para as series ###
        df9 <- count(docentes, POSGRAD_EFAF, name = "N_PROF_POSGRAD_EFAF") %>%
                filter(POSGRAD_EFAF == 1)
        df9 <- df9[,c(1,3)]
        
        df10 <- count(docentes, POSGRAD_EM, name = "N_PROF_POSGRAD_EM") %>%
                filter(POSGRAD_EM == 1)
        df10 <- df10[,c(1,3)]
        
        
        ### contar mestrado e doutorado total, em e efaf ###
        
        ## criar interacoes
        docentes <- docentes %>% mutate(ESPECIALIZACAO_EFAF = EFAF*ID_ESPECIALIZACAO)
        docentes <- docentes %>% mutate(ESPECIALIZACAO_EM = EM*ID_ESPECIALIZACAO)
        
        docentes <- docentes %>% mutate(MESTRADO_EFAF = EFAF*ID_MESTRADO)
        docentes <- docentes %>% mutate(MESTRADO_EM = EM*ID_MESTRADO)
        
        docentes <- docentes %>% mutate(DOUTORADO_EFAF = EFAF*ID_DOUTORADO)
        docentes <- docentes %>% mutate(DOUTORADO_EM = EM*ID_DOUTORADO)
        
        ## contar doutorados
        df11 <- count(docentes, ID_DOUTORADO, name = "N_PROF_DOUTORADO") %>%
                filter(ID_DOUTORADO == 1)
        df11 <- df11[,c(1,3)]
        
        df12 <- count(docentes, DOUTORADO_EFAF, name = "N_PROF_DOUTORADO_EFAF") %>%
                filter(DOUTORADO_EFAF == 1)
        df12 <- df12[,c(1,3)]
        
        df13 <- count(docentes, DOUTORADO_EM, name = "N_PROF_DOUTORADO_EM") %>%
                filter(DOUTORADO_EM == 1)
        df13 <- df13[,c(1,3)]
        
        ## contar mestrado
        df14 <- count(docentes, ID_MESTRADO, name = "N_PROF_MESTRADO") %>%
                filter(ID_MESTRADO == 1)
        df14 <- df14[,c(1,3)]
        
        df15 <- count(docentes, MESTRADO_EFAF, name = "N_PROF_MESTRADO_EFAF") %>%
                filter(MESTRADO_EFAF == 1)
        df15 <- df15[,c(1,3)]
        
        df16 <- count(docentes, MESTRADO_EM, name = "N_PROF_MESTRADO_EM") %>%
                filter(MESTRADO_EM == 1)
        df16 <- df16[,c(1,3)]
        
        ## contar especializacao
        df17 <- count(docentes, ID_ESPECIALIZACAO, name = "N_PROF_ESPECIALIZACAO") %>%
                filter(ID_ESPECIALIZACAO == 1)
        df17 <- df17[,c(1,3)]
        
        df18 <- count(docentes, ESPECIALIZACAO_EFAF, name = "N_PROF_ESPECIALIZACAO_EFAF") %>%
                filter(ESPECIALIZACAO_EFAF == 1)
        df18 <- df18[,c(1,3)]
        
        df19 <- count(docentes, ESPECIALIZACAO_EM, name = "N_PROF_ESPECIALIZACAO_EM") %>%
                filter(ESPECIALIZACAO_EM == 1)
        df19 <- df19[,c(1,3)]
        
        ##########################################################
        ### Colocar as agregacoes no nosso data frame agregado ###
        ##########################################################
        
        ### iniciando um df para o ano ###
        df <- df1[,1]
        df$ANO <- as.integer(ano)
        
        ### loop para grudar os df ###
        frame_list <- list(df1, df2, df3, df4, df6, df7, df8, df9, df10, df11, df12, 
                           df13, df14, df15, df16, df17, df18, df19)
        for (d in frame_list) {
                df <- merge(df, d, by = "PK_COD_ENTIDADE", all.x=TRUE, all.y=TRUE)
        }
        
        ### nesse caso, ficaram como NA as escolas que nao tem certos tipos de prof... vamos 
        ### substituir NA por 0
        df[is.na(df)] <- 0
        
        ### agora é só agregar no data frame principal, que é um painel ###
        df_docentes <- bind_rows(df_docentes, df)
        rm(docentes, frame_list)
        gc()
        print(paste("Ano", ano, "agregado com sucesso!"))
}

### Salvar pois esta pronta para uso ###
df_docentes <- df_docentes[2:nrow(df_docentes),]
saveRDS(df_docentes, "Dados/[DF AGREGADO]docentes_2009-2018.rds")

### Variaveis:
###          N_PROF: numero de professores na escola ensinando no EFAF ou EM, Docente ou 
###                  atividade complementar
###          N_PROF_SUP_COMP: numero de professores com ens sup completo
###          N_PROF_POSGRAD: numero de professores com alguma pos graduação
###          N_PROF_DOUTORADO: numero de professores com doutorado
###          N_PROF_MESTRADO: numero de professores com mestrado
###          N_PROF_ESPECIALIZACAO: numero de professores com especializacao
