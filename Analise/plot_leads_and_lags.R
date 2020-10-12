# function to plot results from leads and lags
library(ggplot2)
plot_ll <- function(res, idx, idx_lag0){
      dsf = res$df.residual
      m = res$coefficients[idx]
      slope = qt(0.975, df=res$df.residual)
      h = m+sqrt(diag(res$vcov)[idx])*slope
      l = m-sqrt(diag(res$vcov)[idx])*slope
      lldf <- data.frame(m=m, l=l, h=h, x=names(m))
      lldf$x <- factor(lldf$x, levels=lldf$x)
      lldf$t <- 1:nrow(lldf)-idx_lag0
            
      ggplot(lldf, aes(x=t, y=m))+
            geom_vline(aes(linetype="Início do Programa",
                           xintercept = lldf$t[idx_lag0]), 
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
            theme(legend.title = element_blank())
}