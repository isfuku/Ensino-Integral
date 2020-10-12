library(dplyr)
library(ggplot2)
library(reshape2)
rm(list=ls())
dff <- readRDS("Dados/df_final.rds")

# evolução das notas ----
dff$Tratado <- as.factor(dff$treat)
(p1 <- ggplot(data=dff %>% group_by(ANO, Tratado) %>% 
             summarise(MTM = mean(MTM), PORT = mean(PORT)) %>%
             melt(id.vars = c("ANO", "Tratado"),
                  variable.name="DISCIPLINA", value.name="NOTA"), 
      aes(x=ANO, y=NOTA, group=Tratado,color=Tratado))+
      geom_vline(xintercept = 2013, linetype="dashed")+
      geom_line()+
      annotate(geom = "text", x = 2011.5, y = 256,
               label="Início do\nPrograma")+
      ylab("Nota")+
      ggtitle(paste0("Evolução das notas em escolas participantes", 
                     " e não participantes do programa"))+
      geom_curve(color="black",
            aes(x=2011.5, y = 257.5, 
                xend = 2012.9, yend = 260),
            arrow = arrow(length = unit(0.05, "npc")),
            angle = 90,
            curvature = -0.3)+
      theme(legend.position = "bottom")+
      facet_wrap(~DISCIPLINA)
)

# resultados leads and lags ----
ll_results <- readRDS("Analise/ll_results.rds")

ll_smr <- function(res, idx, idx_lag0){
      dsf = res$df.residual
      m = res$coefficients[idx]
      slope = qt(0.975, df=res$df.residual)
      h = m+sqrt(diag(res$vcov)[idx])*slope
      l = m-sqrt(diag(res$vcov)[idx])*slope
      lldf <- data.frame(m=m, l=l, h=h, x=names(m))
      lldf$x <- factor(lldf$x, levels=lldf$x)
      lldf$t <- 1:nrow(lldf)-idx_lag0
      return(lldf)
}

pt <- ll_smr(ll_results[[1]], 1:7, 5)
mtm <- ll_smr(ll_results[[2]], 1:7, 5)
pt$disciplina = "PORT"
mtm$disciplina = "MTM"
ll_results <- rbind(mtm, pt)


(p2 <- ggplot(ll_results, aes(x=t, y=m))+
      geom_vline(aes(linetype="Início do\n Programa",
                     xintercept = ll_results$t[5]), 
                 color="black")+
      scale_linetype_manual(values = c(2))+
      geom_point()+
      geom_line(aes(x=t))+
      geom_ribbon(aes(ymin=l, ymax=h, x=t, fill="95% C.I."), 
                  alpha = 0.3)+
      scale_fill_manual( values=4)+
      geom_hline(yintercept=0)+
      ylab("Impacto Causal")+
      xlab("Anos antes/depois do programa")+
      theme(legend.title = element_blank(),
            legend.position = "bottom")+
      ggtitle("Impacto do programa e teste de causalidade tipo Granger")+
      facet_wrap(~disciplina)
)

# ambos graficos ----
library(cowplot)
cowplot::plot_grid(p1, p2, ncol=1)
