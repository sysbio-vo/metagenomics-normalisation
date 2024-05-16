library("vegan")
library("viridis")
library("ggplot2")
library("ggpubr")

# ====== Preparatory stuff ======

palette=c("#003f5c",
          "#2f4b7c",
          "#665191",
          "#a05195",
          "#d45087",
          "#f95d6a",
          "#ff7c43",
          "#ffa600")

# dictionary of titles
titles <- c('tss' = 'TSS', 'uq' = 'UQ', 'med' = 'MED', 'css' = 'CSS',
            'tmm' = 'TMM', 'clr' = 'CLR', 'blom' = 'Blom', 'npn' = 'NPN',
            'combat' = 'ComBat', 'limma' = 'Limma',
            'prepped' = 'Сирі дані')
# common meta
meta <- read.table('data/otutable_metadata.csv',
                   sep = ",", header = TRUE, row.names = 1)


plotpca <- function(method, colorby){
  pathtoftable <- paste('camp_normalization_out/normalization/otutable_', method, '.csv', sep='')
  ftable <- read.table(pathtoftable,
                       sep = ",", header = TRUE, row.names = 1)
  dist <- vegdist(t(ftable), method = 'euclidean', na.rm = TRUE)
  pcoa <- data.frame(wcmdscale(dist, k=2)) # store 2 coordinates
  ggplot(as.data.frame(pcoa),
         aes(x=X1, y=X2, color = colorby, shape = meta$study_name)) +
    geom_point(size=3) +
    labs(title = titles[method]) +
    scale_color_manual(name = NULL, values = magma(2, begin = 0.23, end = 0.8),
                       labels = c("здорові", "рак")) +
    scale_shape_manual(name = NULL, values = c(1, 17),
                       labels = c("GuptaA 2019", "ThomasAM 2018b")) +
    theme_light()
}

# ====== Plotting =======
prep <- plotpca('prepped', colorby = meta$study_condition) +
  theme(legend.position="bottom")
css <- plotpca('css', colorby = meta$study_condition)
blom <- plotpca('blom', colorby = meta$study_condition)
combat <- plotpca('combat', colorby=meta$study_condition)
clr <- plotpca('clr', colorby=meta$study_condition)

#tss, uq, med, css, tmm, clr, blom, npn, combat, limma
norm_plots <- ggarrange(css, clr, blom, combat,
                       common.legend = TRUE, legend = "none", ncol = 2, nrow = 2)

ggarrange(prep, norm_plots,
          ncol=2, nrow=1, widths = c(1, 2), labels = "AUTO") %>% 
  ggexport(filename = "figures/pca_all.png",
           width=2058, height=1176, res = 150)

